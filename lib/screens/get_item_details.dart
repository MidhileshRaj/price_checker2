import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:price_checker/screens/configuration_screen.dart';
import 'package:price_checker/screens/widget/custom_drawer_widget.dart';
import 'package:price_checker/utils/constants/colors.dart';
import 'package:price_checker/utils/constants/image_strings.dart';
import 'package:price_checker/utils/devices/device_utilities.dart';

import '../controller/main_controller.dart';
import '../utils/theme/custom_clippers.dart';
import 'widget/output_widgets.dart';

class GetItemDetails extends StatelessWidget {
  const GetItemDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    final screenController = Get.put(MainController(), tag: UniqueKey().toString());
    final height = MyAppDeviceUtils.getScreenHeight();
    final width = MyAppDeviceUtils.getScreenWidth();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.focusNode.requestFocus();
      controller.resetInactivityTimer();
    });

    controller.focusNode.requestFocus();
    controller.resetInactivityTimer();
    controller.checkAvailableImages();


    return GestureDetector(
      onTap: () {
        controller
            .resetInactivityTimer(); // Reset inactivity timer on interaction
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageStrings.background),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          endDrawer: const CustomDrawerWidget(),
          key: screenController.scaffoldKey,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              screenController.openDrawerMethod();
            },
            backgroundColor: Colors.white60,
            child: const Icon(Icons.settings),
          ),
          backgroundColor: Colors.transparent,
          body: Obx(
            () {
              return Stack(
                children: [
                  /// Keystroke event catching textfield - Hidden
                  Positioned(
                    top: 10,
                    child: Center(
                      child: SizedBox(
                        width: width,
                        child: TextField(
                          controller: controller.getItemController,
                          focusNode: controller.focusNode,
                          onTapAlwaysCalled: true,
                          keyboardType: TextInputType.none,
                          onTapOutside: (value) {
                            if (controller.getItemController.text.length > 12) {
                              controller.fetchProductMSSql(
                                  productCode:
                                      controller.getItemController.text);
                            }
                          },
                          cursorColor: Colors.transparent,
                          onChanged: (value) {
                            if (value.length > 12) {
                              controller.fetchProductMSSql(productCode: value);
                            }
                            if (value.isEmpty) {
                              controller.focusNode.requestFocus();
                            }
                          },
                          style: const TextStyle(color: Colors.transparent),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Arch shape widget with carousel
                  controller.showCarousel.value?Center(
                    child:  controller.imageLinks.isEmpty? SizedBox(
                      height: height * .6,
                      width: width * .8,
                      child: Image(
                        image: AssetImage(ImageStrings.alSafeer),
                        fit: BoxFit.fill,
                      ),
                    ):SizedBox(
                        height: min(width / 3.3 * (16 / 9),height*.9),
                        child:CarouselSlider(
                          options: CarouselOptions(height: height*.7,autoPlay: true,animateToClosest: true,),
                          items: controller.imageLinks.map((i) {

                            return Builder(
                              builder: (BuildContext context) {

                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: const BoxDecoration(
                                        color: Colors.amber
                                    ),
                                    child:Image.file(File(i),fit: BoxFit.cover,)
                                );
                              },
                            );
                          }).toList(),
                        )
                    ),
                  ):
                  Positioned(
                    top: 0,
                    left: width * .2,
                    right: width * .2,
                    child: ClipPath(
                      clipper: CustomCurveClipper(),
                      child: Container(
                        color: Colors
                            .white, // Background color for the content area
                        height: height * .45,
                        width: width * 0.5,
                      ),
                    ),
                  ),
                  controller.showCarousel.value?const SizedBox():
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        // Logo
                        SizedBox(
                          height: height * .23,
                          width: width * .23,
                          child: Image(
                            image: AssetImage(ImageStrings.alSafeer),
                            fit: BoxFit.fill,
                          ),
                        ),

                        // Lottie Animation
                        // Item Details Area
                      ],
                    ),
                  ),
                  Positioned(
                    top: height * .68,
                    left: width * .1,
                    right: width * .1,
                    child: SizedBox(
                      height: 250,
                      width: 450,
                      child: Lottie.asset(ImageStrings.lottieDown),
                    ),
                  ),
                 controller.showCarousel.value?const SizedBox(): Positioned(
                    bottom: height * .25,
                    left: width * .1,
                    right: width * .1,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: MyAppColors.primary.withOpacity(.5),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "Scan Here",
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontWeight: FontWeight.bold),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                 controller.showCarousel.value?const SizedBox(): Positioned(
                      bottom: 90,
                      left: height * .1,
                      right: width * .1,
                      child: OutPutWidget(
                        onPressSpeaker:controller.speakPrice,
                          productDetails: controller.productDetails.value,
                          productPrice: controller.productPrice.value,
                          productName: controller.productDetails.value,
                          backgroundImage: ImageStrings.detailsBackground,
                          arabicProductName: controller.arabicProductName.value,
                          arabicProductPrice: controller.arabicProductPrice.value,
                          height: height,
                          width: width)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:price_checker/screens/add_slider_images.dart';
import 'package:price_checker/screens/widget/custom_drawer_widget.dart';
import 'package:price_checker/utils/constants/image_strings.dart';
import 'package:price_checker/utils/devices/device_utilities.dart';

import '../controller/main_controller.dart';
import 'widget/output_widgets.dart';

class GetItemDetails extends StatelessWidget {
  const GetItemDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    final screenController = Get.put(MainController(), tag: UniqueKey().toString());
    final height = MyAppDeviceUtils.getScreenHeight();
    final width = MyAppDeviceUtils.getScreenWidth();
    // controller.initializeDatabase();
    controller.onInit();
    controller.focusNode.requestFocus();


      controller.loadImagesFromDatabase();
      controller.resetInactivityTimer();


    return GestureDetector(
      onTap: () {
        controller.resetInactivityTimer(); //
        controller.focusNode.requestFocus();// Reset inactivity timer on interaction
        controller.loadImagesFromDatabase();// Reset inactivity timer on interaction
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageStrings.background),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          endDrawer:  CustomDrawerWidget(onTapAdConfig: ()async{
            await controller.onPageDistro();
            Get.to(const AddSliderImages());
          },),
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
                        height: height * .45,
                        width: width * .33,
                        child: Image(
                          image: AssetImage(ImageStrings.alSafeer),
                          fit: BoxFit.fill,
                        )
                    ):SizedBox(
                        height: min(width / 3.3 * (16 / 9),height*.9),
                        child:CarouselSlider(
                          options: CarouselOptions(height: height*.8,autoPlay: true,),
                          items: controller.imageLinks.map((i) {
                            print(i);
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: const BoxDecoration(
                                        color: Colors.amber
                                    ),
                                    child:Image(image: FileImage(File(i.toString())),fit: BoxFit.cover,)
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
                    // child: ClipPath(
                      // clipper: CustomCurveClipper(),
                      child: Container(
                       decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(40)),// Background color for the content area
                        height: height ,
                        width: width * 0.75,
                      ),
                    // ),
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
                          height: height * .55,
                          width: width * .42,
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
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "Scan Here",
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                // color: Colors.white,
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
                          productDetails: controller.productDetails.value,
                          productPrice: controller.productPrice.value,
                          productName: controller.productDetails.value,
                          backgroundImage: ImageStrings.detailsBackground,
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

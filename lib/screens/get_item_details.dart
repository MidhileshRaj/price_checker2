import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:price_checker/screens/configuration_screen.dart';
import 'package:price_checker/utils/constants/image_strings.dart';
import 'package:price_checker/utils/constants/images_constants.dart';
import 'package:price_checker/utils/devices/device_utilities.dart';

import '../controller/main_controller.dart';
import '../utils/theme/custom_clippers.dart';
import 'widget/output_widgets.dart';

class GetItemDetails extends StatelessWidget {
  const GetItemDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    final height = MyAppDeviceUtils.getScreenHeight();
    final width = MyAppDeviceUtils.getScreenWidth();
    // controller.initializeDatabase();

    controller.focusNode.requestFocus();
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageStrings.background),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => const ConfigurationScreen());
          },
          backgroundColor: Colors.white60,
          child: const Icon(Icons.settings),
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
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
                            productCode: controller.getItemController.text);
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
            // Arch shape widget
            Positioned(
              top: 0,
              left: width * .2,
              right: width * .2,
              child: ClipPath(
                clipper: CustomCurveClipper(),
                child: Container(
                  color: Colors.white, // Background color for the content area
                  height: height * .75,
                  width: width * 0.6,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  // Logo
                  SizedBox(
                    height: height * .22,
                    width: width * .28,
                    child:  Image(
                      image: AssetImage(ImageStrings.alMadina),
                      fit: BoxFit.fill,
                    ),
                  ),

                  // Lottie Animation
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Lottie.asset(ImageStrings.lottieDown),
                  ),

                  // Item Details Area

                ],
              ),
            ),
            Positioned(
              bottom: 90,
              left: height * .1,
              right: width * .1,
              child: Obx(
                    () {
                  return OutPutWidget(
                      productDetails: controller.productDetails.value,
                      productPrice: controller.productDetails.value,
                      productName: controller.productDetails.value,
                      backgroundImage: ImageStrings.detailsBackground,
                      height: height,
                      width: width);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:price_checker/screens/configuration_screen.dart';

import '../controller/main_controller.dart';

class GetItemDetails extends StatelessWidget {
  const GetItemDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    // controller.initializeDatabase();
    controller.focusNode.requestFocus();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
       floatingActionButton: FloatingActionButton(onPressed: () {
      Get.to(() => const ConfigurationScreen());
      },backgroundColor: Colors.white60,child: const Icon(Icons.settings),),
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   automaticallyImplyLeading: false,
        //   actions: [
        //     IconButton(
        //       onPressed: () {
        //         Get.to(() => const ConfigurationScreen());
        //       },
        //       icon: const Icon(
        //         Icons.settings,
        //         color: Colors.white,
        //       ),
        //     )
        //   ],
        // ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            /// Keystroke event catching textfield - Hidden
            Positioned(
              top: 10,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
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

                      // suffix: IconButton(onPressed: (){
                      //   controller.fetchProductMSSql(productCode: controller.getItemController.text);
                      // }, icon: Icon(Icons.arrow_circle_down_sharp, color: Colors.white,size: 25,))
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 0,
              left: MediaQuery.sizeOf(context).width * .2,
              right: MediaQuery.sizeOf(context).width * .2,
              child: ClipPath(
                clipper: CustomCurveClipper(),
                child: Container(
                  color: Colors.white, // Background color for the content area
                  height: MediaQuery.of(context).size.height *.75,
                  width: MediaQuery.of(context).size.width * 0.6,
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
                    height: MediaQuery.sizeOf(context).height * .22,
                    width: MediaQuery.sizeOf(context).width * .28,
                    child: const Image(
                      image: AssetImage("assets/images/al-madina.png"),
                      fit: BoxFit.fill,
                    ),
                  ),

                  // Lottie Animation
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Lottie.asset('assets/lottie/main.json'),
                  ),

                  // Item Details Area
                ],
              ),
            ),
            Obx(() {
              // Display product details reactively
              if (controller.productDetails.value == "No product selected.") {
                return Positioned(
                  bottom: 100,
                  left: MediaQuery.sizeOf(context).width * .2,
                  right: MediaQuery.sizeOf(context).width * .2,
                  child: const Center(
                    child: Text(
                      "DETAILS WILL BE DISPLAYED HERE.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              } else {
                return
                    // Text(controller.productDetails.value.toString(),style: TextStyle(color: Colors.white),);
                   /// Product details display
                    Positioned(
                  bottom: 50,
                  left: MediaQuery.sizeOf(context).width * .1,
                  right: MediaQuery.sizeOf(context).width * .1,
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.60,
                      decoration: BoxDecoration(
                          color: Colors.green.shade600
                              .withOpacity(.9), // Dark background color
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image:
                                AssetImage("assets/images/product-details.png"),
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.cover,opacity: .9,
                          )),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // Barcode Area

                          // Product Name and Price Area
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.productName.value.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  controller.productDetails.value.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "AED " +
                                      controller.productPrice.value.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Ojuju'
                                  ),
                                )
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                  //   children: [
                                //
                                //     Container(
                                //       padding: const EdgeInsets.symmetric(
                                //           horizontal: 5, vertical: 5),
                                //       decoration: BoxDecoration(
                                //         color: Colors.amber,
                                //         borderRadius: BorderRadius.circular(5),
                                //       ),
                                //       child:  Text(
                                //         controller.productPrice.value.toString(),
                                //         style: TextStyle(
                                //           color: Colors.black,
                                //           fontSize: 20,
                                //           fontWeight: FontWeight.bold,
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            })
          ],
        ),
      ),
    );
  }
}

class CustomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0); // Start at the top-left corner
    path.lineTo(
        0, size.height * 0.6); // Extend further down for the vertical section
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height, // Control point for bottom curve
      size.width,
      size.height * 0.6, // End point of the curve
    );
    path.lineTo(size.width, 0); // Top-right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

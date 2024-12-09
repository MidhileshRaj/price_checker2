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
    // controller.focusNode.requestFocus();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => const ConfigurationScreen());
              },
              icon: const Icon(Icons.settings,color: Colors.white,),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: 10,
              child: Center(
                child: SizedBox(width: MediaQuery.sizeOf(context).width,
                  child: TextField(
                    controller: controller.getItemController,
                    focusNode: controller.focusNode,
                    onTapAlwaysCalled: true,
                    onTapOutside: (value){
                      if(controller.getItemController.text.length>12){
                        controller.fetchProductMSSql(productCode: controller.getItemController.text);
                      }

                    },
                    cursorColor: Colors.transparent,
                    onChanged: (value) {
                      if(value.length>12){
                        controller.fetchProductMSSql(productCode: value);
                      }
                      if(value.isEmpty){
                        controller.focusNode.requestFocus();
                      }

                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none
                        ),

                        suffix: IconButton(onPressed: (){
                          controller.fetchProductMSSql(productCode: controller.getItemController.text);
                        }, icon: Icon(Icons.arrow_circle_down_sharp, color: Colors.white,size: 25,))
                    ),
                  ),),
              ),
            ),
            Positioned(
              left: MediaQuery.sizeOf(context).width * .2,
              right: MediaQuery.sizeOf(context).width * .2,
              child: ClipPath(
                clipper: CustomCurveClipper(),
                child: Container(
                  color: Colors.white, // Background color for the content area
                  height: MediaQuery.of(context).size.height * .65,
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  // Logo
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * .22,
                    width: MediaQuery.sizeOf(context).width * .28,
                    child: Image(
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
              if (controller.productDetails.value == "No product selected") {
                return Positioned(
                  bottom: 100,
                  left: MediaQuery.sizeOf(context).width * .2,
                  right: MediaQuery.sizeOf(context).width * .2,
                  child: Center(
                    child: const Text(
                      "DETAILS WILL BE DISPLAYED HERE.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              } else {
                return
                  // Text(controller.productDetails.value.toString(),style: TextStyle(color: Colors.white),);
                  Positioned(
                    bottom: 10,
                    left: MediaQuery.sizeOf(context).width * .2,
                    right: MediaQuery.sizeOf(context).width * .2,
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.32,
                        decoration: BoxDecoration(
                          color: Colors.green.shade600.withOpacity(.9), // Dark background color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            // Barcode Area
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Barcode No:",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "7110100922789",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Product Name and Price Area
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "PRODUCT NAME ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ), const Text(
                                    "Product Description ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: const Text(
                                          "1.95 Rs",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
    path.lineTo(0, size.height * 0.8); // Extend further down for the vertical section
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height, // Control point for bottom curve
      size.width,
      size.height * 0.8, // End point of the curve
    );
    path.lineTo(size.width, 0); // Top-right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_checker/utils/constants/images_constants.dart';

import '../controller/main_controller.dart';
import '../utils/widgets/button_widget.dart';
import 'configuration_screen.dart';

class GetItemDetails extends StatelessWidget {
  const GetItemDetails({super.key});




  @override
  Widget build(BuildContext context) {
    /// Ensure the database is initialized when the widget builds
    /// Initialize the controller using Get.find() for dependency injection
    final controller = Get.find<MainController>();
    // controller.initializeDatabase();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(ImagesConstants.bg_image), fit: BoxFit.fill),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: const Text("Product Details"),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => const ConfigurationScreen());
              },
              icon: const Icon(Icons.settings),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "GET ITEM PRICE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ButtonWidget(
                text: "",
                icon: const Icon(
                  Icons.qr_code_scanner,
                  size: 45,
                ),
                onClicked: () async {
                    // controller.startScan();
                   await controller.scanBarCode();
                   // await controller.fetchProductDetails();
                   // await controller.fetchProductDetails();

                },
              ),
              const SizedBox(height: 20),
              Obx(() {
                // Display product details reactively
                if (controller.productDetails.value == "No product selected.") {
                  return const Text(
                    "Details will be displayed here.",
                    style: TextStyle(color: Colors.white),
                  );
                } else {
                  return
                    // Text(controller.productDetails.value.toString(),style: TextStyle(color: Colors.white),);
                    Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  Container(
                        alignment: Alignment.center,
                        height: MediaQuery.sizeOf(context).height * .1,
                        width: MediaQuery.sizeOf(context).width * .70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // image: const DecorationImage(
                          //   image: AssetImage(
                          //       "assets/images/yellow_background.jpg"),
                          //   fit: BoxFit.fill,
                          //   opacity: .7,
                          // ),
                        ),
                        child:Column(
                        children: [controller.productID.value.isEmpty?
                            Text("Item Not Found"):
                          ListTile(
                          // leading: Text(
                          //     controller.productID.value,
                          //     style: const TextStyle(
                          //       fontWeight: FontWeight.bold,fontSize: 20
                          //     ),
                          //   ),
                          title: Text(controller.productDetails.value, style: const TextStyle(
                              fontWeight: FontWeight.bold,fontSize: 25
                          ),),
                          // subtitle: Text(controller.productPrice.value.toString(), style: const TextStyle(
                          //     fontWeight: FontWeight.bold,fontSize: 20
                          // ),),
                        ),

                        ],
                      ),
                      )
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

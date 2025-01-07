import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_checker/controller/add_network_images_controller.dart';

import '../utils/widgets/custom_text_field_design.dart';

class AddNetworkImages extends StatelessWidget {
  const AddNetworkImages({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddNetworkImagesController());
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Add Image Link'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextFieldDesign(
              label: 'ip',
              controller: controller.ipController.value,
              // enable: controller.enableField.value,
            ),
            CustomTextFieldDesign(
                label: 'Folder name', controller: controller.folderController.value),

            /// Version update 1.0.3
            CustomTextFieldDesign(
              label: 'Duration in seconds', controller: controller.duration.value,textInputType: TextInputType.number,),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: ()async {
                await controller.saveImagesFromLocalNetwork();
              },
              child: const Text('Add Link'),
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}

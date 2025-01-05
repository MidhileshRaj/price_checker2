import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_checker/controller/slider_item_controller.dart';

import '../utils/widgets/custom_text_field_design.dart';
class AddSliderImages extends StatelessWidget {
  const AddSliderImages({super.key});



  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SliderItemController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Image Link'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextFieldDesign(
              label: 'FTP server',
              controller: controller.ftpServer,
              enable: controller.enableField.value,
            ),
            CustomTextFieldDesign(
                label: 'FTP username', controller: controller.username),
            CustomTextFieldDesign(
                label: 'FTP password', controller: controller.password),
            const SizedBox(height: 10),

            /// Version update 1.0.3
            CustomTextFieldDesign(
                label: 'Duration in seconds', controller: controller.duration),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: ()async {

               await controller.testConnectionFtp();
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
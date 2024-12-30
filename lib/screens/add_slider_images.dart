import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_checker/controller/slider_item_controller.dart';

import '../utils/widgets/custom_text_field_design.dart';
class AddSliderImages extends StatelessWidget {
  const AddSliderImages({super.key});



  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SliderItemController());
    controller.checkAvailableImages();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Image Link'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            ElevatedButton(
              onPressed: () {
                controller.addImageLink();
              },
              child: const Text('Add Link'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.imageLinks.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(controller.imageLinks[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed:(){controller.removeItemFromList(index);},
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
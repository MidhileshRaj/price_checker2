import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_checker/controller/slider_item_controller.dart';
import 'package:price_checker/utils/widgets/custom_text_field_design.dart';

class AddSliderImages extends StatelessWidget {
  const AddSliderImages({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SliderItemController());
    controller.checkFtpConfiguration();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Image Link'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              // CustomTextFieldDesign(
              //   label: 'FTP Folder Path',
              //   controller: controller.imageLinkController,
              //   enable: controller.enableField.value,
              // ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: ()async {
                 await controller.saveFtpConfiguration();
                 await controller.testConnectionFtp();
                },
                child: const Text('Connect FTP Server'),
              ), ElevatedButton(
                onPressed: () {
                  controller.enableField.value = true;
                },
                child: const Text('Change'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Image Links',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

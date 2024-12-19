import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_checker/controller/configuration_controller.dart';
import 'package:price_checker/utils/constants/colors.dart';
import '../utils/helpers/persistance_helper.dart';
import '../utils/widgets/button_widget.dart';
import '../utils/widgets/custom_text_field_design.dart';
import 'get_item_details.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.find<ConfigurationController>();


    // Ensure initialization logic is executed
    controller.configurePageInitialization();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Database Config.",
                style: TextStyle(
                  color: MyAppColors.primary,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              CustomTextFieldDesign(
                enable: controller.enableTextField.value,
                label: 'Server name',
                hint: '192.168.100.75',
                controller: controller.serverNameController.value,
              ),
              CustomTextFieldDesign(
                enable: controller.enableTextField.value,
                label: 'Database Name',
                hint: 'TechSysDB',
                controller: controller.dataBaseNameController.value,
              ),
              CustomTextFieldDesign(
                enable: controller.enableTextField.value,
                label: 'Table Name',
                hint: 'Products',
                controller: controller.tableNameController.value,
              ),
              CustomTextFieldDesign(
                label: 'Username',
                hint: 'root',
                controller: controller.userNameController.value,
              ),
              CustomTextFieldDesign(
                label: 'Password',
                hint: '12345678',
                controller: controller.passwordController.value,
              ),
              const SizedBox(height: 20),

              /// Table Column Details
              const Text(
                "Column details",
                style: TextStyle(
                  color: MyAppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFieldDesign(
                label: 'Barcode Column',
                hint: 'eg:- product_code',
                controller: controller.itemCodeController.value,
              ),CustomTextFieldDesign(
                label: 'Product Name Column',
                hint: 'eg:- itemName',
                controller: controller.nameColumnController.value,
              ),CustomTextFieldDesign(
                label: 'Price Column',
                hint: 'eg:- itemPrice',
                controller: controller.priceColumnController.value,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWidget(
                    text: "Configure",
                    onClicked: () async {
                      await controller.saveConfiguration();
                      Get.to(() => const GetItemDetails());
                    },
                  ),
                  const SizedBox(width: 20),
                  ButtonWidget(
                    text: "Reset",
                    onClicked: () async {
                      await HelperServices.setConfiguration(false);
                      controller.configurePageInitialization();
                    },
                  ),
                ],
              ),

            ],
          )),
        ),
      ),

    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_checker/utils/constants/colors.dart';

import '../utils/helpers/persistance_helper.dart';
import '../utils/string_constants.dart';

class ConfigurationController extends GetxController {
  // Reactive TextEditingControllers wrapped in Rx
  var serverNameController = TextEditingController().obs;
  var dataBaseNameController = TextEditingController().obs;
  var tableNameController = TextEditingController().obs;
  var userNameController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var ipAddressController = TextEditingController().obs;


  // Reactive variable for enabling/disabling text fields
  var enableTextField = true.obs;


  /// Dynamic textfield add method
  var dynamicTextControllers = <TextEditingController>[].obs;
  void addTextField() {
    if (dynamicTextControllers.length < 10) {
      dynamicTextControllers.add(TextEditingController());
    } else {
      Get.snackbar(
        "Limit Reached",
        "You can only add up to 10 extra columns.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: MyAppColors.warning,
        colorText: Colors.white,
      );
    }
  }
  // Initialize configuration
  @override
  void onInit() {
    super.onInit();
    configurePageInitialization();
  }

  configurePageInitialization() async {
    var server = await HelperServices.getServerData(StringConstants.server);
    var table = await HelperServices.getServerData(StringConstants.table);
    var database = await HelperServices.getServerData(StringConstants.dataBase);

    var isConfigured = await HelperServices.checkConfiguration();

    if (isConfigured) {
      enableTextField.value = false;

      serverNameController.value.text = server;
      dataBaseNameController.value.text = database;
      tableNameController.value.text = table;

    } else {
      enableTextField.value = true;

      serverNameController.value.text = "192.168.20.2:4000";
      dataBaseNameController.value.text = "techsysdb";
      tableNameController.value.text = "products";

    }
  }

  // Save configuration
  saveConfiguration() async {
    await HelperServices.saveServerData(
        StringConstants.server, serverNameController.value.text);
    await HelperServices.saveServerData(
        StringConstants.table, tableNameController.value.text);
    await HelperServices.saveServerData(
        StringConstants.dataBase, dataBaseNameController.value.text);
    await HelperServices.saveServerData(
        StringConstants.password, passwordController.value.text);
    await HelperServices.saveServerData(
        StringConstants.userName, userNameController.value.text);
    await HelperServices.setConfiguration(true);
  }
}

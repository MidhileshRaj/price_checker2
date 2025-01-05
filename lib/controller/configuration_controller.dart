import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mssql_connection/mssql_connection.dart';
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
  var itemCodeController = TextEditingController().obs;
  var nameColumnController = TextEditingController().obs;
  var priceColumnController = TextEditingController().obs;

  // Reactive variable for enabling/disabling text fields
  var enableTextField = true.obs;

  /// Dynamic textfield add method
  var dynamicTextControllers = <TextEditingController>[].obs;

  final _sqlConnection = MssqlConnection.getInstance();

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
    var itemCode = await HelperServices.getServerData(StringConstants.itemCode);
    var itemName = await HelperServices.getServerData(StringConstants.itemName);
    var salesPrice =
        await HelperServices.getServerData(StringConstants.salesPrice);

    var isConfigured = await HelperServices.checkConfiguration();

    if (isConfigured) {
      enableTextField.value = false;

      serverNameController.value.text = server;
      dataBaseNameController.value.text = database;
      tableNameController.value.text = table;
      itemCodeController.value.text = itemCode;
      nameColumnController.value.text = itemName;
      priceColumnController.value.text = salesPrice;
    } else {
      enableTextField.value = true;

      serverNameController.value.text = "192.168.20.2";
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
    await HelperServices.saveServerData(
        StringConstants.itemCode, itemCodeController.value.text);
    await HelperServices.saveServerData(
        StringConstants.itemName, nameColumnController.value.text);
    await HelperServices.saveServerData(
        StringConstants.salesPrice, priceColumnController.value.text);
    await HelperServices.setConfiguration(true);
  }

  Future<dynamic> testMsSqlConnection() async {
    try {
      // Connect to the database
      bool isConnected = await _sqlConnection.connect(
        ip: serverNameController.value.text,
        port: '1433',
        databaseName: dataBaseNameController.value.text,
        username: userNameController.value.text,
        password: passwordController.value.text,
        timeoutInSeconds: 1,
      );

      if (!isConnected) {
        Get.snackbar(
          "Connection failed",
          "MsSql Server connection failed",
            colorText: MyAppColors.white,
            backgroundColor: MyAppColors.error.withOpacity(.5),
            maxWidth: 400,
            snackPosition: SnackPosition.BOTTOM,
            snackStyle: SnackStyle.GROUNDED
        );
      }

      // Construct the SQL query with dynamic table name
      String query =
          "SELECT * FROM ${tableNameController.value.text} WHERE ${itemCodeController.value.text}= '123'";

      // Prepare the parameters
      print(query);

      // Execute the query
      String result = await _sqlConnection.getData(query);
      print(result);

      Get.snackbar(
          " Connection success",
          "MSSql server connected successfully with new this server. Please verify the column names",
          colorText: MyAppColors.white,
          backgroundColor: MyAppColors.success.withOpacity(.5),
          maxWidth: 400,
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.GROUNDED
      );
      // Close the connection
      bool isDisconnected = await _sqlConnection.disconnect();
    } catch (e) {
      print('Error fetching product data: $e');
      Get.snackbar("Server connection Issues", "$e",
          backgroundColor: MyAppColors.warning.withOpacity(.6),
          colorText: MyAppColors.white,
          maxWidth: 400,
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.GROUNDED,duration: const Duration(seconds: 5));
    }
  }
}

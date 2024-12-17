import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mssql_connection/mssql_connection.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:price_checker/utils/constants/api_constans.dart';

import '../utils/helpers/persistance_helper.dart';
import '../utils/string_constants.dart';

class MainController extends GetxController {
  // Text Editing Controller
  final TextEditingController getItemController = TextEditingController();

  static const platform = MethodChannel('scanner_channel');
  final _sqlConnection = MssqlConnection.getInstance();
  FocusNode focusNode = FocusNode();

  // Reactive Variables for database configuration
  var getItemID = "".obs;
  var isConnected = false.obs;
  var barcode = "".obs;
  var server = "".obs;
  var table = "".obs;
  var itemCodeColumn = "".obs;
  var itemSalesPriceColumn = "".obs;
  var itemNameColumn = "".obs;

  /// Product details

  var userName = "".obs;
  var database = "".obs;
  var password = "".obs;
  var productDetails = "No product selected.".obs;
  var productID = "".obs;
  var productName = "".obs;
  var productPrice = "".obs;
  var productDetailsMap = {}.obs;

  // MySQL connection
  static MySQLConnection? _connection;

  @override
  void onInit() {
    super.onInit();
    // Set up method channel to listen for barcode results.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    print("Init state on count -----");
  }

  // Scan Barcode Method
  Future<void> scanBarCode() async {
    try {
      final result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.DEFAULT,
      );

      print('$result ----------------------- Barcode value ------');

      if (result != '-1') {
        // var result = "6290429015714";
        barcode.value = result;
        productDetails.value = result.toString();

        print('Attempting to fetch product details...${barcode.value}');
        await fetchProductMSSql(
          productCode: barcode.value,
        );

        if (productDetails.value.isNotEmpty) {
          print('Product details fetched successfully: $productDetails');
        } else {
          print('Product details not found.');
        }
      } else {
        print('Scan canceled by the user.');
      }
    } catch (e) {
      print('Error in scanBarCode: $e');
    }
  }

  // Initialize Database
  Future<void> initializeDatabase() async {
    server.value = await HelperServices.getServerData(StringConstants.server);
    database.value =
        await HelperServices.getServerData(StringConstants.dataBase);
    userName.value =
        await HelperServices.getServerData(StringConstants.userName);
    password.value =
        await HelperServices.getServerData(StringConstants.password);
    itemCodeColumn.value = await HelperServices.getServerData(StringConstants.itemCode);
    itemNameColumn.value = await HelperServices.getServerData(StringConstants.itemName);
    itemSalesPriceColumn.value = await HelperServices.getServerData(StringConstants.salesPrice);
    table.value = await HelperServices.getServerData(StringConstants.table);

    print("${server.value} === ${userName.value} === $table");

    try {
      _connection = await MySQLConnection.createConnection(
        host: server.value,
        port: 3306,
        userName: userName.value,
        password: password.value,
        databaseName: database.value,
      );
      await _connection!.connect();
    } catch (e) {
      print("Error initializing database: $e");
    }
  }

  Future<dynamic> fetchProductMSSql({required String productCode}) async {
    try {
      server.value = await HelperServices.getServerData(StringConstants.server);
      database.value =
          await HelperServices.getServerData(StringConstants.dataBase);
      userName.value =
          await HelperServices.getServerData(StringConstants.userName);
      password.value =
          await HelperServices.getServerData(StringConstants.password);
      table.value = await HelperServices.getServerData(StringConstants.table);
      itemCodeColumn.value = await HelperServices.getServerData(StringConstants.itemCode);
      itemNameColumn.value = await HelperServices.getServerData(StringConstants.itemName);
      itemSalesPriceColumn.value = await HelperServices.getServerData(StringConstants.salesPrice);

      // Connect to the database
      bool isConnected = await _sqlConnection.connect(
        ip: server.value,
        port: '1433',
        databaseName: database.value,
        // username: userName.value,
        // password: password.value,
        username: "silveradmin",
        password: "admin\$ilver",
        timeoutInSeconds: 1,
      );

      if (!isConnected) {
        print('Failed to connect to SQL Server');
        return null;
      }

      // Construct the SQL query with dynamic table name
      String query =
          "SELECT * FROM ${table.value} WHERE ${itemCodeColumn.value}= '$productCode'";

      // Prepare the parameters
      print(query);

      // Execute the query
      String result = await _sqlConnection.getData(query);

      var data = jsonDecode(result);

      // fetch corresponding product details
      var product = data.first;


      productDetails.value = product[itemNameColumn.value].toString();
      productName.value = product[itemNameColumn.value].toString();
      productID.value = product["id"].toString();
      print(product[itemSalesPriceColumn.value]);
      productPrice.value = product[itemSalesPriceColumn].toString();
      print(product["id"]);
      print(product[itemNameColumn] + "----- details");

      print(data.length);
      // Edit text clear values
      getItemController.text = "";

      // Close the connection
      bool isDisconnected = await _sqlConnection.disconnect();

      if (isDisconnected) {
        print(table.value);
        print(server.value);
        print(database.value);
        print(userName.value);
        print(password.value);
        print(productCode);
        print('Successfully connected from SQL Server');
        // Request the focus node after fetching product
        focusNode.requestFocus();
        hideProductDetails();

      } else {
        print('Failed to disconnect from SQL Server');
      }

      return json.decode(result);

    } catch (e) {
      print('Error fetching product data: $e');
      productDetails.value= "No product available";
      productPrice.value= "--";
      productID.value= "--";
      getItemController.text = "";
      return null;
    }
  }

  // Fetch Product Details
  Future fetchProductDetails() async {
    try {
      if (_connection == null) {
        print("Connection Error>>>-------$_connection");
        throw Exception("Database connection is not initialized.");
      }
      print(_connection);

      var query = 'SELECT * FROM $table WHERE product_code = :id';

      var result = await _connection!.execute(
        query,
        {'id': barcode},
      );

      print(result.toString() + "---------result");

      if (result.rows.isNotEmpty) {
        // productDetails.value = jsonDecode(result.rows.toString());
        productDetailsMap.value = result.rows.map((row) => row.assoc()).first;
        productID.value = productDetailsMap["id"].toString();
        productName.value = productDetailsMap["product_name"].toString();
        productPrice.value = productDetailsMap["price"].toString();
        print(productDetails);
        print(productDetailsMap.toString() +
            "-------------------- result==--------------");
        print('${result.rows}---------------- Output');
        return result.rows.first.assoc();
      } else {
        productDetails.value = "Product not found.";
      }
    } catch (e) {
      stdout.write("Error fetching product: $e");
    }
  }

  Future<dynamic> getProductDetails(productCode) async {
    try {
      server.value = await HelperServices.getServerData(StringConstants.server);
      database.value =
          await HelperServices.getServerData(StringConstants.dataBase);
      userName.value =
          await HelperServices.getServerData(StringConstants.userName);
      password.value =
          await HelperServices.getServerData(StringConstants.password);
      table.value = await HelperServices.getServerData(StringConstants.table);
      print(
          "APi integration with server${server.value} === ${userName.value} === $table");
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/get_data'));
      request.fields.addAll({
        'userName': userName.value,
        'dataBase': database.value,
        'host': server.value,
        'password': password.value,
        'productCode': productCode
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("Response==========");
        var result = await response.stream.bytesToString();

        productDetailsMap.value = jsonDecode(result);
        print(productDetailsMap.values);
        productName.value = productDetailsMap["product"]["name"].toString();
        productID.value = productDetailsMap["product"]["id"].toString();
        productPrice.value = productDetailsMap["product"]["price"].toString();
        return productDetailsMap.values;
      } else {
        print(response.reasonPhrase);
        throw Exception("Api request error ${response.statusCode}");
      }
    } catch (e) {
      print("Exception ---------> $e");
    }
  }

  bool _handleKeyEvent(KeyEvent event) {
    String _scannerData = "";
    var output = "";

    // print(event.character);
    _scannerData += event.character ?? "";
    output = _scannerData;
    if (output != '' && output.length > 12) {
      // if (output.contains('\n')) {
      output = output.replaceAll('\n', '');
      // }
      print(output);
      fetchProductMSSql(productCode: output);
    }

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      barcode.value = output;
      getItemController.text = output;
      _scannerData = "";
      output = "";
    }
    return false;
  }
  hideProductDetails(){
    if (productDetails.value != "No product selected."){
      Future.delayed(Duration(seconds: 15),(){
        productDetails.value ="No product selected.";
      });

    }
  }
}

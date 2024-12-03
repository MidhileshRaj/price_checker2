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

import '../utils/helpers/database_connector.dart';
import '../utils/helpers/persistance_helper.dart';
import '../utils/string_constants.dart';

class MainController extends GetxController {
  // Text Editing Controller
  final TextEditingController getItemController = TextEditingController();

  static const platform = MethodChannel('scanner_channel');
  final _sqlConnection = MssqlConnection.getInstance();



  // Reactive Variables
  var getItemID = "".obs;
  var isConnected = false.obs;
  var barcode = "".obs;
  var server = "".obs;
  var table = "".obs;
  var userName = "".obs;
  var database = "".obs;
  var password = "".obs;
  var productDetails = "No product selected.".obs;
  var productID = "".obs;
  var productName = "".obs;
  var productPrice = "".obs;
  var productDetailsMap ={}.obs;

  // MySQL connection
  static MySQLConnection? _connection;

  @override
  void onInit() {
    super.onInit();
    // Set up method channel to listen for barcode results.
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onBarcodeScanned') {
        barcode.value = call.arguments; // Update the barcode value.
      }
    });
  }

  void startScan() async {
    const scanIntent = 'nlscan.action.SCANNER_TRIG';

    try {
      // Attempt to start the scanner
      await platform.invokeMethod('startScanner', {'intent': scanIntent});
    } on PlatformException catch (e) {
      // If the scanner is not available, use the fallback barcode scanner
      print('Error: Scanner not available, using fallback scanner. $e');

      await scanBarCode();
    }
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
        productDetails.value =result.toString();

        print('Attempting to fetch product details...${barcode.value}');
         await fetchProductMSSql(productCode: barcode.value, tableName: table.value,);

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

  Future<dynamic> fetchProductMSSql({required String productCode,required String tableName}) async {
    try {
      server.value = await HelperServices.getServerData(StringConstants.server);
      database.value =
      await HelperServices.getServerData(StringConstants.dataBase);
      userName.value =
      await HelperServices.getServerData(StringConstants.userName);
      password.value =
      await HelperServices.getServerData(StringConstants.password);
      table.value = await HelperServices.getServerData(StringConstants.table);

      // Connect to the database
      bool isConnected = await _sqlConnection.connect(
        ip: server.value,
        port: '1433',
        databaseName: database.value,
        username: userName.value,
        password: password.value,
      );

      if (!isConnected) {
        print('Failed to connect to SQL Server');
        return null;
      }

      // Construct the SQL query with dynamic table name
      String query = '''
        SELECT *
        FROM [$tableName]
        WHERE product_code = '[$productCode]'
      ''';

      // Prepare the parameters

      // Execute the query
      String result = await _sqlConnection.getData(query);

      // Close the connection
      bool isDisconnected = await _sqlConnection.disconnect();

      List data = jsonDecode(result);
      productDetails.value = data.first["name"];


      if (isDisconnected) {
        print('Successfully disconnected from SQL Server');
      } else {
        print('Failed to disconnect from SQL Server');
      }

      return json.decode(result);
    } catch (e) {
      print('Error fetching product data: $e');
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

      print(result.toString()+"---------result");

      if (result.rows.isNotEmpty) {
        // productDetails.value = jsonDecode(result.rows.toString());
        productDetailsMap.value = result.rows.map((row) => row.assoc()).first;
        productID.value = productDetailsMap["id"].toString();
        productName.value = productDetailsMap["product_name"].toString();
        productPrice.value = productDetailsMap["price"].toString();
        print(productDetails);
        print(productDetailsMap.toString() + "-------------------- result==--------------");
        print('${result.rows}---------------- Output');
        return result.rows.first.assoc();
      } else {
        productDetails.value = "Product not found.";
      }
    } catch (e) {
      stdout.write("Error fetching product: $e");
    }
  }


Future<dynamic> getProductDetails(productCode)async{
    try {
      server.value = await HelperServices.getServerData(StringConstants.server);
      database.value =
      await HelperServices.getServerData(StringConstants.dataBase);
      userName.value =
      await HelperServices.getServerData(StringConstants.userName);
      password.value =
      await HelperServices.getServerData(StringConstants.password);
      table.value = await HelperServices.getServerData(StringConstants.table);
      print("APi integration with server${server.value} === ${userName
          .value} === $table");
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/get_data'));
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
       var result =await response.stream.bytesToString();

       productDetailsMap.value =  jsonDecode(result);
       print(productDetailsMap.values);
       productName.value = productDetailsMap["product"]["name"].toString();
       productID.value = productDetailsMap["product"]["id"].toString();
       productPrice.value = productDetailsMap["product"]["price"].toString();
       return productDetailsMap.values;
      }
      else {
        print(response.reasonPhrase);
        throw Exception("Api request error ${response.statusCode}");
      }

    }catch(e){
      print("Exception ---------> $e");

    }

}
}

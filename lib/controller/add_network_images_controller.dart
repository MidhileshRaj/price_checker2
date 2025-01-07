import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:price_checker/screens/get_item_details.dart';
import 'package:price_checker/utils/constants/colors.dart';

import '../utils/helpers/persistance_helper.dart';
import '../utils/helpers/sqf_lite_helper.dart';
import '../utils/string_constants.dart';

class AddNetworkImagesController extends GetxController {
  var ipController = TextEditingController().obs;
  var folderController = TextEditingController().obs;
  var  duration = TextEditingController().obs;

  saveImagesFromLocalNetwork() async {
    var ip = ipController.value.text;
    var path = folderController.value.text;
    var baseUrl = "http://$ip/$path";

    List<String> imageExtension = ["jpg", "png", "jpeg"];
    try {
      final dbHelper = DatabaseHelper();
      await dbHelper.clearImages();
      for (int i = 1; i <= 20; i++) {
        for (String j in imageExtension) {
          var imageName = "$baseUrl/$i.$j";
          var url = Uri.parse(imageName);
          var response = await http.get(url);
          if (response.statusCode == 200) {
            // imagesAvailable.add(imageName);
            print(url);
            dbHelper.insertImage("$i.$j", imageName);
          }
        }
      }
      await HelperServices.saveServerData("duration", duration.value.text);
     Get.to(()=>GetItemDetails());
    } catch (e) {
      Get.snackbar("Error", "On:   --- $e",
          backgroundColor: MyAppColors.error.withOpacity(.7),
          colorText: MyAppColors.white,
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.GROUNDED,
          maxWidth: 350,
          duration: const Duration(seconds: 5));
    }finally{

      print("---- task completed");
    }
  }
}

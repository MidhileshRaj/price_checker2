import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/helpers/persistance_helper.dart';
import '../utils/string_constants.dart';

class SliderItemController extends GetxController {
  var imageLinks = <String>[].obs;
  final TextEditingController imageLinkController = TextEditingController();
  final TextEditingController ftpServer = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  RxBool enableField = true.obs;

  checkAvailableImages() async {
    imageLinks.value =
        await HelperServices.getListOfItems(StringConstants.imageLinks);
  }

  checkFtpConfiguration()async{
    var server = await HelperServices.getServerData(StringConstants.ftpServer);
    var folder = await HelperServices.getServerData(StringConstants.ftpFolder);
    bool isConfigured = await HelperServices.checkFtpConfiguration();
    if(isConfigured){
      enableField.value = false;
      ftpServer.text = server;
      imageLinkController.text =folder;

    }else{
      enableField.value = true;
    }

  }

  /// FTP server saving
  saveFtpConfiguration() async {
    await HelperServices.saveServerData(
        StringConstants.ftpServer, ftpServer.value.text);
    await HelperServices.saveServerData(
        StringConstants.ftpUser, username.value.text);
    await HelperServices.saveServerData(
        StringConstants.ftpPassword, password.value.text);
    await HelperServices.saveServerData(
        StringConstants.ftpFolder, imageLinkController.value.text);
    await HelperServices.setFtpConfiguration(true);
  }

  // Add a new image link and save to SharedPreferences
  void addImageLink() async {
    String link = imageLinkController.text;
    imageLinks.value =
        await HelperServices.getListOfItems(StringConstants.imageLinks);
    print("Available images ------- ${imageLinks.length}");
    if (link.isNotEmpty) {
      if (!imageLinks.contains(link)) {
        imageLinks.add(link);
        print("new Item added....");
        await HelperServices.saveListOfItem(
            StringConstants.imageLinks, imageLinks.value);
      }
    }
  }

  removeItemFromList(int index) async {
    imageLinks.removeAt(index);
    await HelperServices.saveListOfItem(
        StringConstants.imageLinks, imageLinks.value);
  }
}

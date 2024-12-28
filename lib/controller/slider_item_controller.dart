import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
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
  testConnectionFtp() async {
    final FTPConnect ftpClient = FTPConnect(
      ftpServer.text,
      user: username.text,
      pass: password.text,
    );

    try {

      List<String> localImages =[];
      await ftpClient.connect();
      print("Connection Success..../");

      final externalStoragePath = await getExternalStorageDirectory();
      final appDir = Directory('${externalStoragePath?.path}');
      for (int i = 0; i <= 20; i++) {
        var existJpgFile = await ftpClient.existFile('$i.jpg');
        var existPngFile = await ftpClient.existFile('$i.png');
        if (existJpgFile) {
          String localFilePath = '${appDir.path}/$i.jpg';
          if(File(localFilePath).existsSync()){
            await File(localFilePath).delete();
          }
          await ftpClient.downloadFile('$i.jpg', File(localFilePath));
          print(localFilePath);
          localImages.add(localFilePath);
        } else if (existPngFile) {
          String localFilePath = '${appDir.path}/$i.png';
          if(File(localFilePath).existsSync()){
            await File(localFilePath).delete();
          }
          await ftpClient.downloadFile('$i.png', File(localFilePath));
          print(localFilePath);
          localImages.add(localFilePath);
        }
      }
      print(localImages.length);
      await HelperServices.saveListOfItem(
          StringConstants.imageLinks, localImages);

      // Download the image


      stdout.write("Images Fetching success----");
    } on FTPConnectException catch (e) {
      print("$e---");
    } catch (e) {
      print("Test connection failed $e");
    }finally{
     ftpClient.disconnect();
     print("FTP disconnected");
   }
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

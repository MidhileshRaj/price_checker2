import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:price_checker/utils/constants/colors.dart';

import '../screens/get_item_details.dart';
import '../utils/helpers/persistance_helper.dart';
import '../utils/helpers/sqf_lite_helper.dart';
import '../utils/string_constants.dart';

class SliderItemController extends GetxController {
  var imageLinks = <String>[].obs;
  final TextEditingController imageLinkController = TextEditingController();
  final TextEditingController ftpServer = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  /// Version update 1.0.3
  final TextEditingController duration = TextEditingController();
  RxBool enableField = true.obs;

  Future<void> testConnectionFtp() async {
    final FTPConnect ftpClient = FTPConnect(
      ftpServer.text,
      user: username.text,
      pass: password.text,
    );

    try {
      await ftpClient.connect();

      /// Version update 1.0.3
      Get.snackbar(
        "FTP Connection success..",
        "Please wait for getting images..",
        backgroundColor: MyAppColors.success.withOpacity(.5),
        duration: const Duration(milliseconds: 500),
      );

      final externalStoragePath = await getExternalStorageDirectory();
      if (externalStoragePath == null) {

        /// Version update 1.0.3
        Get.snackbar(
          "External Storage not accessible",
          "",
          backgroundColor: MyAppColors.warning.withOpacity(.5),
          duration: const Duration(milliseconds: 500),
        );
        return;
      }

      final appDir = Directory('${externalStoragePath.path}/MyAppImages');
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }

      final dbHelper = DatabaseHelper();
      await dbHelper.clearImages(); // Clear existing data before inserting new

      stdout.writeln("Download images one by one");
      for (int i = 0; i <= 20; i++) {
        String? imagePath = await _downloadAndSaveImage(ftpClient, appDir, i);
        if (imagePath != null) {
          String fileName = imagePath.split('/').last;
          await dbHelper.insertImage(fileName, imagePath);
        }
      }

      stdout.write("Images fetched and saved successfully...");
    } on FTPConnectException catch (e) {

      /// Version update 1.0.3
      Get.snackbar(
        "FTP connection Error.",
        "$e",
        backgroundColor: MyAppColors.error.withOpacity(.5),
        duration: const Duration(milliseconds: 500),
      );
    } catch (e) {

      /// Version update 1.0.3
      Get.snackbar(
        "Error on ",
        "Please wait for getting images..$e",
        backgroundColor: MyAppColors.error.withOpacity(.5),
        duration: const Duration(milliseconds: 500),
      );
    } finally {
      ftpClient.disconnect();

      /// Version update 1.0.3
      await HelperServices.saveServerData("duration", duration.text);
      Get.back();
    }
  }

  Future<String?> _downloadAndSaveImage(
      FTPConnect ftpClient, Directory appDir, int index) async {
    try {
      String jpgFileName = '$index.jpg';
      String pngFileName = '$index.png';

      String? fileNameToDownload;
      if (await ftpClient.existFile(jpgFileName)) {
        fileNameToDownload = jpgFileName;
      } else if (await ftpClient.existFile(pngFileName)) {
        fileNameToDownload = pngFileName;
      }

      if (fileNameToDownload != null) {
        String localFilePath = '${appDir.path}/$fileNameToDownload';

        // Delete if the file already exists
        final localFile = File(localFilePath);
        if (await localFile.exists()) {
          await localFile.delete();
        }

        // Download the file and save it to the local path
        await ftpClient.downloadFile(fileNameToDownload, localFile);
        print("Saved: $localFilePath");
        return localFilePath;
      }
    } catch (e) {
      print("Error downloading file: $e");
    }
    return null;
  }

  checkAvailableImages() async {
    imageLinks.value =
        await HelperServices.getListOfItems(StringConstants.imageLinks);
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

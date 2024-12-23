import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/helpers/persistance_helper.dart';
import '../utils/string_constants.dart';

class SliderItemController extends GetxController {
  var imageLinks = <String>[].obs;
  final TextEditingController imageLinkController = TextEditingController();


  checkAvailableImages()async{
    imageLinks.value = await HelperServices.getListOfItems(StringConstants.imageLinks);
  }



  // Add a new image link and save to SharedPreferences
  void addImageLink() async {
    String link = imageLinkController.text;
    imageLinks.value = await HelperServices.getListOfItems(StringConstants.imageLinks);
    print("Available images ------- ${imageLinks.length}");
    if (link.isNotEmpty) {
      if(!imageLinks.contains(link)) {

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
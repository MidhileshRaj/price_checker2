import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class MyAppChipTheme{
  MyAppChipTheme._();


  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: Colors.grey.withOpacity(.3),
    labelStyle: const TextStyle(color: Colors.black),
    selectedColor: MyAppColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
    checkmarkColor: Colors.white,
  );



  static ChipThemeData darktChipTheme = const ChipThemeData(
    disabledColor: Colors.grey,
    labelStyle: TextStyle(color: Colors.white),
    selectedColor: MyAppColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
    checkmarkColor: Colors.white,
  );
}
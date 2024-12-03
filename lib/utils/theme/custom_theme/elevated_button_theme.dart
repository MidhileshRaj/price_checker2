import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class MyAppElevatedButtonTheme{
  MyAppElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: MyAppColors.primary,
      disabledForegroundColor: Colors.grey.shade600,
      disabledBackgroundColor: Colors.grey,
      side: const BorderSide(color: MyAppColors.primary),
      padding: const EdgeInsets.symmetric(vertical: 15),
      textStyle: const TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
    )
  );
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: MyAppColors.primary,
      disabledForegroundColor: Colors.grey.shade600,
      disabledBackgroundColor: Colors.grey,
      side: const BorderSide(color: MyAppColors.primary),
      padding: const EdgeInsets.symmetric(vertical: 15),
      textStyle: const TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
    )
  );

}
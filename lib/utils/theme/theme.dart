import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'custom_theme/appbar_theme.dart';
import 'custom_theme/bottom_sheet_theme.dart';
import 'custom_theme/check_box_theme.dart';
import 'custom_theme/chip_theme.dart';
import 'custom_theme/elevated_button_theme.dart';
import 'custom_theme/outline_button_theme.dart';
import 'custom_theme/text_field_theme.dart';
import 'custom_theme/text_theme.dart';

class MyAppTheme{
  MyAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: MyAppColors.primary,
    scaffoldBackgroundColor: MyAppColors.primaryBackground,
    appBarTheme:  MyAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: MyAppBottomSheetTheme.lightBottomSheetTheme,
    checkboxTheme:MyAppCheckBoxTheme.lightCheckBoxTheme ,
    chipTheme: MyAppChipTheme.lightChipTheme,
    elevatedButtonTheme: MyAppElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme:MyAppTextFormFieldTheme.lightInputDecorationTheme ,
    outlinedButtonTheme: MyAppOutlinedButtonTheme.ligtOutlinedButtonTheme,
    textTheme: MyAppTextTheme.lightTextTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: MyAppColors.primary,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme:  MyAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: MyAppBottomSheetTheme.darkBottomSheetTheme,
    checkboxTheme:MyAppCheckBoxTheme.darkCheckBoxTheme ,
    chipTheme: MyAppChipTheme.darktChipTheme,
    elevatedButtonTheme: MyAppElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme:MyAppTextFormFieldTheme.darkInputDecorationTheme ,
    outlinedButtonTheme: MyAppOutlinedButtonTheme.darkOutlinedButtonTheme,
    textTheme: MyAppTextTheme.darkTextTheme,
  );
}
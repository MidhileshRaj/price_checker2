import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class MyAppCheckBoxTheme{
  MyAppCheckBoxTheme._();


  ///Customizable light checkbox theme
  static CheckboxThemeData lightCheckBoxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if(states.contains(WidgetState.selected)){
        return Colors.white;
      }else{
        return Colors.black;
      }
    },),
    fillColor:WidgetStateProperty.resolveWith((states) {
      if(states.contains(WidgetState.selected)){
        return MyAppColors.primary;
      }else{
        return Colors.transparent;
      }
    },),
  );

  ///Customizable light checkbox theme
  static CheckboxThemeData darkCheckBoxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if(states.contains(WidgetState.selected)){
        return Colors.white;
      }else{
        return Colors.black;
      }
    },),
    fillColor:WidgetStateProperty.resolveWith((states) {
      if(states.contains(WidgetState.selected)){
        return MyAppColors.primary;
      }else{
        return Colors.transparent;
      }
    },),
  );
}
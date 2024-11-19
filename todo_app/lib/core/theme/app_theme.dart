import 'package:flutter/material.dart';
import 'package:todo_app/core/theme/app_color.dart';

class AppTheme {
  static final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.darkBackGroundColor,
    appBarTheme: const AppBarTheme(backgroundColor: AppColor.darkAppBarColor),
    progressIndicatorTheme: 
        const ProgressIndicatorThemeData(color: AppColor.appColor));
  
  static final lightTheme = ThemeData.dark(useMaterial3: true).copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.lightBackGroundColor,
    appBarTheme: const AppBarTheme(backgroundColor: AppColor.lightAppBarColor),
    progressIndicatorTheme: 
        const ProgressIndicatorThemeData(color: AppColor.appColor));
}
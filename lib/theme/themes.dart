import 'package:flutter/material.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Themes {
  //Light Theme
  final lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    cardColor: AppColors.appWhiteColor,
    primaryColor: AppColors.appPrimaryColor,
    appBarTheme: AppBarTheme(
        titleTextStyle:
            TextStyle(color: AppColors.appBlackColor, fontSize: 16.sp)),
  );

  //Dark Theme
  final darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColor: AppColors.appContainerBgColor,
    scaffoldBackgroundColor: AppColors.appDefaultDarkMode,
    cardColor: AppColors.appContainerBgColor,
    appBarTheme: AppBarTheme(
        backgroundColor: AppColors.appContainerBgColor,
        titleTextStyle:
            TextStyle(color: AppColors.appWhiteColor, fontSize: 16.sp)),
  );
}

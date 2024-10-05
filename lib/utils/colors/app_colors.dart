
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors{

  //Dark and Light Mode
  static getBackgroundDarkLight(){
    return Get.isDarkMode? appDefaultDarkMode: appWhiteColor;
  }

  static getContainerBgDarkLight(){
    return Get.isDarkMode? appDefaultDarkMode: appWhiteColor;
  }

  static getContainerFillBgDarkLight(){
    return Get.isDarkMode? appDefaultDarkMode: appFillColor;
  }

  static getAppBarBgDarkLight(){
    return Get.isDarkMode? appContainerBgColor: appFillColor;
  }

  static getTextDarkLight(){
    return Get.isDarkMode? appWhiteColor: appBlackColor;
  }

  static getContainerBorderDarkLight(){
    return Get.isDarkMode? Colors.white10: Colors.black12;
  }

  static getTextFieldDarkLight(){
    return Get.isDarkMode? Colors.white10: appFillColor;
  }

  /// Base Color
  static const appWhiteColor = Color(0xffffffff);
  static const appContainerBgColor = Color(0xff17212B);
  static const appDefaultDarkMode = Color(0xff0E1621);
  static const appBlackColor = Color(0xff130820);
  static const appFillColor = Color(0xffF3FAFC);
  static const appBrandColor2 = Color(0xffFFF0DD);
  static const appBrandColor3 = Color(0xffECF8F7);
  static const appBrandDeep = Color(0xff93C3C0);
  static const appBg1 = Color(0xffE1ECFA);
  static const appBg2 = Color(0xffF9E3FF);
  static const appBg3 = Color(0xffE1ECFA);
  static const appTransactionCardColor = Color(0xffF8F5F3);
  static const appDashBoardTransactionGreen = Color(0xff65C18C);
  static const appDashBoardTransactionRed = Color(0xffF87474);
  static const appDashBoardTransactionPending = Color(0xffF29339);
  static const appRed50 = Color(0xffF5B7B8);
  static const appGreen50 = Color(0xffB0D3D2);
  static Color appTicketCloseColor = Color(0xffF87474).withOpacity(0.1);
  static Color appTicketOpenColor = Color(0xff93C3C0).withOpacity(0.1);
  static Color appTicketReplyColor = Color(0xff93C3C0).withOpacity(0.1);
  static const appBlackColor80 = Color(0xff42394D);
  static const appBlackColor60 = Color(0xff716B79);
  static const appBlackColor50 = Color(0xff88838F);
  static const appBlackColor40 = Color(0xffA19CA6);
  static const appBlackColor30 = Color(0xffB9B5BD);
  static const appBlackColor20 = Color(0xffF5F5F5);
  static const appBlackColor10 = Color(0xffE8E7E9);
  static Color appPrimaryColor = Color(0xff897EF2);
  static Color appMainBalanceIconColor = Color(0xffA2CDCA);
  static Color appTotalDepositIconColor = Color(0xffBD9172);
  static Color appTotalEarnIconColor = Color(0xff8971AD);
  static Color appTotalInvestIconColor = Color(0xff749BCD);
  static Color appTotalPayoutIconColor = Color(0xffBD9172);
  static Color appTotalTicketIconColor = Color(0xff93C3C0);


}
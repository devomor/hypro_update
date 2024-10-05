import 'package:flutter/material.dart';


class MyColor {

  static const Color primaryColor   = Color(0xFFF8BF27);
  static const Color secondaryColor = Color(0xffF6F7FE);

  static const Color cardBgColor               = Color(0xff192D36);
  static const Color backgroundColor           = Color(0xff0D222B);
  static const Color appBarBgColor             = Color(0xff192D36);
  static const Color screenBgColor             = Color(0xff0F0F0F);
  static const Color primaryTextColor          = Color(0xff262626);
  static const Color contentTextColor          = Color(0xff777777);
  static const Color lineColor                 = Color(0xffECECEC);
  static const Color borderColor               = Color(0xffD9D9D9);
  static const Color bodyTextColor             = Color(0xFF747475);
  static const Color secondaryPrimaryColor     = Color(0xFF1E293B);
  static const Color appBgColor                = Color(0xFF1E1E1E);
  static const Color navBarInactiveButtonColor = colorWhite;
  static const Color navBarActiveButtonColor   = Color(0xFFF8BF27);
  static const Color inActiveIndicatorColor    = Color(0xFFF29F11);
  static const Color activeIndicatorColor      = Color(0xFFF8BF27);
  static const Color gameTextColor             = Color(0xFFE3BC3F);
  static const Color gusessNumberFieldColor    = Color(0xFF151522);
  static const Color minesBackFieldColor       = Color(0xFF232640);

  static const orange1                = Color(0xffD69317);
  static const orange2                = Color(0xffD8AC3C);
  static const Color primaryColorDark = primaryColor;
  static const Color primaryColor2    = Color(0xFFF29F11);

  static const Color titleColor        = Color(0xff373e4a);
  static const Color textFieldBorder   = Color(0xff64748B);
  static const Color labelTextColor    = Color(0xffFFFFFF);
  static const Color smallTextColor1   = Color(0xff555555);
  static const Color textFieldColor    = Color(0x945A5A5A);
  static const Color textColor         = Color(0xB3E2E8F0);
  static const Color redAccent         = Color(0xB3FF6C64);
  static Color textColor2              = const Color(0xffFFFFFF).withOpacity(.8);
  static const Color dividerColor      = Color(0xffE2E8F0);
  static const Color blueColor         = Color(0xff0F0FD9);
  static const Color delteBtnTextColor = Color(0xff6C3137);
  static const Color delteBtnColor     = Color(0xffFF0000);
  // static const Color blueColor       = Color(0xff09097D);

  static const Color skyBlueColor   = Color(0xff1E9FF2);
  static const Color lightBlueColor = Color(0xff0E97FD);
  static const Color redColor       = Color(0xffFF0000);

  static const Color appBarColor        = secondaryColor900;
  static const Color appBarContentColor = colorWhite;

  static const Color textFieldDisableBorderColor = Color(0xffCFCEDB);
  static const Color textFieldEnableBorderColor  = primaryColor;
  static const Color hintTextColor               = Color(0xff98a1ab);

  static const Color primaryButtonColor       = Color(0xffF29F11);
  static const Color primaryButtonTextColor   = colorWhite;
  static const Color secondaryButtonColor     = colorWhite;
  static const Color secondaryButtonTextColor = colorBlack;

  static const Color iconColor             = Color(0xff555555);
  static const Color filterEnableIconColor = primaryColor;
  static const Color filterIconColor       = iconColor;

  static const Color colorWhite          = Color(0xffFFFFFF);
  static const Color colorBlack          = Color(0xff262626);
  static const Color colorDarkBlack      = Color(0xff00060D);
  static const Color colorDarkRed        = Color(0xffFF2424);
  static const Color colorBorder         = Color(0xff334155);
  static const Color colorBgCard         = Color(0xff01162F);
  static const Color colorGreen          = Color(0xff28C76F);
  static const Color colorSelected       = Color(0xff968E59);
  static const Color colorRed            = Color(0xFFD92027);
  static const Color colorGrey           = Color(0xff555555);
  static const Color colorCancel         = Color(0xff715E1F);
  static const Color numberCardInt       = Color(0xff13202F);
  static const Color casinoDiceCardColor = Color(0xffF8BF27);
  static const Color transparentColor    = Colors.transparent;

  static const Color greenSuccessColor       = greenP;
  static const Color redCancelTextColor      = Color(0xFFF93E2C);
  static const Color highPriorityPurpleColor = Color(0xFF7367F0);
  static const Color pendingColor            = Colors.orange;

  static const Color greenP            = Color(0xFF34C759);
  static const Color redP              = Color(0xFFFF3B30);
  static const Color greenText         = Color(0xFF34C759);
  static const Color containerBgColor  = Color(0xffF9F9F9);
  static const Color topColor          = Color(0xff04081A);
  static const Color bottomColor       = Color(0xFF0F172A);
  static const Color searchFieldColor  = Color(0xFF141f38);
  static const Color fieldColor        = Color(0xFF0F172A);
  static const Color labelTextsColor   = Color(0xff7B8FAB);
  static const Color subTitleTextColor = Color(0xff94A3B8);
  static const Color listTileColor     = Color(0xff15151C);
  static const Color borderTop         = Color(0xFF2196F3);
  static const Color borderBottom      = Color(0xFF291196);

  static const Color secondaryColor300 = Color(0xffCBD5E1);
  static const Color secondaryColor400 = Color(0xff94A3B8);
  static const Color secondaryColor500 = Color(0xff64748B);
  static const Color secondaryColor600 = Color(0xff475569);
  static const Color secondaryColor700 = Color(0xff334155);
  static const Color secondaryColor800 = Color(0xff1E293B);
  static const Color secondaryColor900 = Color(0xff0F172A);
  static const Color secondaryColor950 = Color(0xff020617);


  static const LinearGradient gradientBackground = LinearGradient(
    begin : Alignment.topCenter,
    end   : Alignment.bottomCenter,
    colors: [topColor, bottomColor],
  );

  static const LinearGradient gradientBorder = LinearGradient(
    colors: [
      Color(0xFF2196F3),
      Color(0xFF291196),
    ],
    begin: Alignment.topCenter,
    end  : Alignment.bottomCenter,
  );

  static Color getPrimaryColor() {
    return primaryColor;
  }

  static Color getScreenBgColor() {
    return screenBgColor;
  }

  static Color getGreyText() {
    return MyColor.colorBlack.withOpacity(0.5);
  }

  static Color getAppBarColor() {
    return appBarColor;
  }

  static Color getAppBarContentColor() {
    return appBarContentColor;
  }

  static Color getHeadingTextColor() {
    return primaryTextColor;
  }

  static Color getContentTextColor() {
    return contentTextColor;
  }

  static Color getLabelTextColor() {
    return labelTextColor;
  }

  static Color getHintTextColor() {
    return hintTextColor;
  }

  static Color getTextFieldDisableBorder() {
    return textFieldDisableBorderColor;
  }

  static Color getTextFieldEnableBorder() {
    return textFieldEnableBorderColor;
  }

  static Color getPrimaryButtonColor() {
    return primaryButtonColor;
  }

  static Color getPrimaryButtonTextColor() {
    return primaryButtonTextColor;
  }

  static Color getSecondaryButtonColor() {
    return secondaryButtonColor;
  }

  static Color getSecondaryButtonTextColor() {
    return secondaryButtonTextColor;
  }

  static Color getIconColor() {
    return iconColor;
  }

  static Color getFilterDisableIconColor() {
    return filterIconColor;
  }

  static Color getSearchEnableIconColor() {
    return colorRed;
  }

  static Color getTransparentColor() {
    return transparentColor;
  }

  static Color getTextColor() {
    return colorWhite;
  }

  static Color getCardBgColor() {
    return cardBgColor;
  }

  static List<Color> symbolPlate = [
    const Color(0xffDE3163),
    const Color(0xffC70039),
    const Color(0xff900C3F),
    const Color(0xff581845),
    const Color(0xffFF7F50),
    const Color(0xffFF5733),
    const Color(0xff6495ED),
    const Color(0xffCD5C5C),
    const Color(0xffF08080),
    const Color(0xffFA8072),
    const Color(0xffE9967A),
    const Color(0xff9FE2BF),
  ];

  static getSymbolColor(int index) {
    int colorIndex = index > 10 ? index % 10 : index;
    return symbolPlate[colorIndex];
  }
}

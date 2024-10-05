import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';

// ignore: must_be_immutable
class AppCustomDropDown extends StatelessWidget {
  double? height;
  double? width;
  bool? advanced;
  dynamic hint;
  double? dropDownWidth;
  double? dropdownMaxHeight;
  double? itemHeight;
  List<dynamic> items;
  BoxDecoration? decoration;
  BoxDecoration? dropdownDecoration;
  dynamic selectedValue;
  TextStyle? hintStyle;
  double? fontSize;
  Color? textColor;
  Color? boxColor;
  Color? buttonBackground;
  Color? dropdownBoxBackground;
  TextStyle? selectedStyle;
  double? boxBorderRadius;
  double? paddingLeft;
  ValueChanged<dynamic>? onChanged;

  AppCustomDropDown(
      {required this.items,
      @required this.onChanged,
      @required this.selectedValue,
      this.advanced = false,
      this.selectedStyle,
      this.height,
      this.decoration,
      this.dropdownDecoration,
      this.dropDownWidth,
      this.itemHeight,
      this.buttonBackground,
      this.dropdownBoxBackground,
      this.hint,
      this.width,
      this.textColor,
      this.boxColor,
      this.fontSize,
      this.dropdownMaxHeight,
      this.boxBorderRadius,
      this.paddingLeft,
      this.hintStyle,
      Key? key})
      : super(key: key);

  List<DropdownMenuItem<dynamic>> _addDividersAfterItems(List<dynamic> items) {
    List<DropdownMenuItem<dynamic>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          advanced == false
              ? DropdownMenuItem<dynamic>(
                  value: item,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: paddingLeft ?? 14),
                    child: Text(
                      item,
                      style: selectedStyle ??
                          TextStyle(
                              fontSize: fontSize ?? 14,
                              fontWeight: FontWeight.w400,
                              color: textColor ?? AppColors.appBlackColor40),
                    ),
                  ),
                )
              : DropdownMenuItem<dynamic>(
                  value: item,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: paddingLeft ?? 14),
                    child: Text(
                      item,
                      style: selectedStyle ??
                          TextStyle(
                              fontSize: fontSize ?? 14,
                              fontWeight: FontWeight.w400,
                              color: getColor(item) ?? Color(0xFF666666)),
                    ),
                  ),
                ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            DropdownMenuItem<dynamic>(
              enabled: false,
              child: Divider(
                thickness: 1,
                color: boxColor ?? Color(0xFFC7C7C7),
              ),
            ),
        ],
      );
    }
    return _menuItems;
  }

  Color? getColor(String value) {
    if (value.toLowerCase() == "paid") {
      return Color(0xFF33CC66);
    } else if (value.toLowerCase() == "pending") {
      return Color(0xFFECB409);
    } else if (value.toLowerCase() == "delivery") {
      return Color(0xFFED3E3E);
    } else {
      return textColor;
    }
  }

  List<double> _getCustomItemsHeights() {
    List<double> _itemsHeights = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        _itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _itemsHeights.add(4);
      }
    }
    return _itemsHeights;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      // buttonDecoration: decoration ??
      //     BoxDecoration(
      //       borderRadius: BorderRadius.circular(boxBorderRadius ?? 5),
      //     ),
      // dropdownDecoration: dropdownDecoration ??
      //     BoxDecoration(
      //       color: AppColors.appWhiteColor,
      //       border: Border.all(color: AppColors.appBlackColor10),
      //       borderRadius: BorderRadius.circular(boxBorderRadius ?? 5),
      //     ),
      // dropdownElevation: 0,
      isExpanded: true,
      hint: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingLeft ?? 14),
        child: Text(
          hint ?? 'Select Item',
          style: hintStyle ??
              TextStyle(
                fontSize: fontSize ?? 16,
                color: Color(0xFF666666),
              ),
        ),
      ),
      items: _addDividersAfterItems(items),
      // customItemsHeights: _getCustomItemsHeights(),
      value: selectedValue,
      onChanged: onChanged,
      // buttonHeight: height ?? 60,
      // itemHeight: itemHeight ?? 60,
      // dropdownMaxHeight: dropdownMaxHeight ?? 200,
      // buttonWidth: width ?? 200,
      // itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
    ));
  }
}

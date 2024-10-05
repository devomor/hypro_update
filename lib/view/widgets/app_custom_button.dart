import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/colors/app_colors.dart';


// ignore: must_be_immutable
class AppCustomButton extends StatelessWidget {
  dynamic height;
  dynamic width;
  dynamic color;
  dynamic title;
  dynamic onTap;
  dynamic titleColor;
  dynamic borderRadius;
  AppCustomButton({super.key, this.color, this.height, this.title, this.width,this.onTap,this.titleColor,this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 40.h,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
            color: color ?? AppColors.appPrimaryColor,
            borderRadius: BorderRadius.circular(borderRadius??10)),
        child: Center(
            child: Text(
              title ?? "Login",
              style: TextStyle(
                  color: titleColor ?? AppColors.appWhiteColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500),
            )),
      ),
    );
  }
}

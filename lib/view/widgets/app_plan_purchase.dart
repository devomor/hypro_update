import 'package:flutter/material.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PlanPurchaseSuccessful extends StatelessWidget {
  const PlanPurchaseSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.cancel_outlined),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
          Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 64.h,
          ),
          SizedBox(height: 10.h),
          Text(
            'Plan Purchased Successfully',
            style: TextStyle(fontSize: 16.sp, color: AppColors.appBlackColor),
          ),
          SizedBox(height: 20.h),
        ],
      ),
      actions: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: MaterialButton(
              minWidth: 100.w,
              height: 35,
              color: AppColors.appPrimaryColor,
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Text(
                'OK',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

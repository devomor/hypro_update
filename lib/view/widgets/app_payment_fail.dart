import 'package:flutter/material.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AppPaymentFail extends StatelessWidget {
  const AppPaymentFail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 30.w),
      child: Material(
          // Wrap with Material
          elevation: 0,
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              height: 300.h,
              width: 300.w,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Lottie.asset("assets/images/fail.json"),
                    Text(
                      "Payment failed",
                      style: GoogleFonts.publicSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.appBlackColor),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.appPrimaryColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Center(
                                    child: Text(
                                      "Ok",
                                      style: GoogleFonts.publicSans(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.appWhiteColor,
                                          fontSize: 16.sp),
                                    ),
                                  ),
                                ))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/resend_code_controller.dart';
import 'package:flutter_hypro/controller/verify_required_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors/app_colors.dart';

class SmsVerificationScreen extends StatefulWidget {
  static const String routeName = "/sms_verification_screen";
  SmsVerificationScreen({super.key});

  @override
  State<SmsVerificationScreen> createState() => _SmsVerificationScreenState();
}

class _SmsVerificationScreenState extends State<SmsVerificationScreen> {
  final selectedLanguageStorage = GetStorage();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int timerDuration = 120; // seconds
  bool isResendEnabled = true;
  late Timer timer;

  void startResendTimer() {
    setState(() {
      isResendEnabled = false;
      timerDuration = 120; // Reset the timer duration to 2 minutes
    });

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (timerDuration == 0) {
        // Timer expired, enable resend
        t.cancel();
        setState(() {
          isResendEnabled = true;
        });
      } else {
        timerDuration--;
      }

      // Update the UI
      if (mounted) {
        // Check if the widget is still mounted before updating the UI
        Get.forceAppUpdate();
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyRequiredController>(
        builder: (verifyRequiredController) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 150,
              left: 24,
              right: 24,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${selectedLanguageStorage.read("languageData")["Sms Verification"] ?? "Sms Verification"}",
                      style: GoogleFonts.publicSans(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.getTextDarkLight(),
                      ),
                    ),
                    SizedBox(
                      height: 100.h,
                    ),
                    Text(
                      "${selectedLanguageStorage.read("languageData")["Code"] ?? "Code"}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10.h),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Code is required';
                        }
                        return null;
                      },
                      controller:
                          verifyRequiredController.smsVerifyCodeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText:
                            "${selectedLanguageStorage.read("languageData")["Enter Your Code"] ?? "Enter Your Code"}",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding:
                            EdgeInsets.only(left: 12, top: 10, bottom: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: AppColors.getTextFieldDarkLight(),
                        filled: true,
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          if (isResendEnabled) {
                            // Trigger resend functionality
                            Get.find<ResendCodeController>()
                                .getResendCode("mobile")
                                .then((value) {
                              startResendTimer();
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              "Didn't receive any code?",
                              style: GoogleFonts.publicSans(
                                fontSize: 14.sp,
                                color: AppColors.appBlackColor,
                              ),
                            ),
                            isResendEnabled == true
                                ? Text(
                                    " Resend Code",
                                    style: GoogleFonts.publicSans(
                                      fontSize: 14.sp,
                                      color: AppColors
                                          .appDashBoardTransactionPending,
                                      decoration: TextDecoration.underline,
                                    ),
                                  )
                                : Text(
                                    " Resend in ${timerDuration}s",
                                    style: GoogleFonts.publicSans(
                                      fontSize: 14.sp,
                                      color: AppColors.appBlackColor,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          verifyRequiredController.smsVerifySubmit(
                              verifyRequiredController
                                  .smsVerifyCodeController.text
                                  .toString());
                        }
                      },
                      child: Container(
                        height: 52.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.appPrimaryColor,
                            borderRadius: BorderRadius.circular(32)),
                        child: Center(
                            child:
                                verifyRequiredController.isLoadingSms == false
                                    ? Text(
                                        "${selectedLanguageStorage.read("languageData")["Submit"] ?? "Submit"}",
                                        style: GoogleFonts.niramit(
                                            fontSize: 20.sp,
                                            color: AppColors.appWhiteColor,
                                            fontWeight: FontWeight.w500,
                                            height: 0.9),
                                      )
                                    : CircularProgressIndicator(
                                        color: AppColors.appWhiteColor,
                                      )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterCode extends StatefulWidget {
  EnterCode({super.key});

  @override
  State<EnterCode> createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  dynamic otpController = TextEditingController();

  final selectedLanguageStorage = GetStorage();

  int timerDuration = 60; // seconds
  bool isResendEnabled = true;
  late Timer timer;

  // void startResendTimer() {
  //   isResendEnabled = false;

  //   timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
  //     if (timerDuration == 0) {
  //       // Timer expired, enable resend
  //       t.cancel();
  //       isResendEnabled = true;
  //     } else {
  //       timerDuration--;
  //     }
  //     // Update the UI
  //     if (mounted) {
  //       // Check if the widget is still mounted before updating the UI
  //       Get.forceAppUpdate();
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   // Cancel the timer to avoid memory leaks
  //   timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${selectedLanguageStorage.read("languageData")["Enter your OTP code"] ?? "Enter your OTP code"}",
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: 'Dubai',
                      color: AppColors.getTextDarkLight(),
                      fontWeight: FontWeight.w500),
                ),

                SizedBox(
                  height: 8.h,
                ),

                Text(
                  "${selectedLanguageStorage.read("languageData")["Enter the 5 digits code that you received on your email"] ?? "Enter the 5 digits code that you received on your email"}",
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Dubai',
                      color: AppColors.appBlackColor50,
                      fontWeight: FontWeight.normal),
                ),

                SizedBox(height: 40.h),

                PinCodeTextField(
                  cursorColor: Colors.blue,
                  showCursor: true,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  length: 5,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    inactiveColor: AppColors.appBlackColor10,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50.h,
                    fieldWidth: 50.w,
                    activeFillColor: Colors.white,
                  ),
                  animationDuration: const Duration(milliseconds: 300),

                  //controller: otpController,
                  onCompleted: (v) {
                    if (kDebugMode) {
                      print("Completed");
                    }
                  },
                  beforeTextPaste: (text) {
                    if (kDebugMode) {
                      print("Allowing to paste $text");
                    }
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  appContext: context,
                ),

                // SizedBox(height: 16.h,),
                //
                // Row(
                //   children: [
                //     Text("Didn’t receive any code?",
                //       style: TextStyle(
                //           fontSize: 16.sp,
                //           fontFamily: 'Dubai',
                //           color: AppColors.appBlackColor50,
                //           fontWeight: FontWeight.normal
                //       ),
                //     ),
                //     Text(" Resend Code",
                //       style: TextStyle(
                //           fontSize: 16.sp,
                //           fontFamily: 'Dubai',
                //           color: AppColors.appBlackColor,
                //           fontWeight: FontWeight.normal
                //       ),
                //     ),
                //   ],
                // ),

                SizedBox(
                  height: 5.h,
                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      if (isResendEnabled) {
                        // Trigger resend functionality
                        authController.forgetPasswordRequest(context,
                            authController.forgetPasswordTxt.text.toString());

                        // Start the timer
                        // startResendTimer();
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
                        isResendEnabled
                            ? Text(
                                " Resend Code",
                                style: GoogleFonts.publicSans(
                                  fontSize: 14.sp,
                                  color:
                                      AppColors.appDashBoardTransactionPending,
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
                  height: 30.h,
                ),

                GestureDetector(
                  onTap: () {
                    print(authController.emailForgetPassword);
                    print(otpController.text.toString());
                    authController.recoveryPassCodeRequest(
                        context,
                        authController.emailForgetPassword,
                        otpController.text.toString());
                  },
                  child: Container(
                    height: 52.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.appPrimaryColor,
                        borderRadius: BorderRadius.circular(32)),
                    child: Center(
                      child: authController.isLoadingCode == false
                          ? Text(
                              "${selectedLanguageStorage.read("languageData")["Continue"] ?? "Continue"}",
                              style: GoogleFonts.niramit(
                                  fontSize: 20.sp,
                                  color: AppColors.appWhiteColor,
                                  fontWeight: FontWeight.w500),
                            )
                          : CircularProgressIndicator(
                              color: AppColors.appWhiteColor,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

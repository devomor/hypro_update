import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class NewPassword extends StatelessWidget {
  NewPassword({super.key});

  dynamic passCtrl = TextEditingController();
  dynamic confirmPassCtrl = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${selectedLanguageStorage.read("languageData")["Create New Password"] ?? "Create New Password"}",
                  style: TextStyle(
                      fontSize: 25.sp,
                      fontFamily: 'Dubai',
                      color: AppColors.getTextDarkLight(),
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  "${selectedLanguageStorage.read("languageData")["Set the new password for your account so that you can login and access all the features."] ?? "Set the new password for your account so that you can login and access all the features."}",
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Dubai',
                      color: AppColors.getTextDarkLight(),
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 32.h),
                Text(
                  "${selectedLanguageStorage.read("languageData")["Password"] ?? "Password"}",
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Dubai',
                      color: AppColors.getTextDarkLight(),
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 4.h,
                ),
                TextFormField(
                  controller: passCtrl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required';
                    }
                    // Add more validation logic here, e.g., check if it's a valid email format
                    // Return null if validation passes
                    return null;
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: AppColors.getTextFieldDarkLight(),
                      filled: true,
                      hintText:
                          "${selectedLanguageStorage.read("languageData")["Enter New Password"] ?? "Enter New Password"}",
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        size: 24.h,
                        color: AppColors.appBlackColor30,
                      ),
                      hintStyle: GoogleFonts.niramit(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          color: AppColors.appBlackColor30)),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  "${selectedLanguageStorage.read("languageData")["Confirm Password"] ?? "Confirm Password"}",
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Dubai',
                      color: AppColors.getTextDarkLight(),
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 4.h,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required';
                    }
                    // Add more validation logic here, e.g., check if it's a valid email format
                    // Return null if validation passes
                    return null;
                  },
                  controller: confirmPassCtrl,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: AppColors.getTextFieldDarkLight(),
                      filled: true,
                      hintText:
                          "${selectedLanguageStorage.read("languageData")["Confirm Password"] ?? "Confirm Password"}",
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        size: 24.h,
                        color: AppColors.appBlackColor30,
                      ),
                      hintStyle: GoogleFonts.niramit(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          color: AppColors.appBlackColor30)),
                ),
                SizedBox(
                  height: 54.h,
                ),
                GestureDetector(
                  onTap: () {
                    authController.forgetPassSubmitRequest(
                        context,
                        passCtrl.text.toString(),
                        confirmPassCtrl.text.toString(),
                        authController.emailForgetPassword);
                  },
                  child: Container(
                    height: 52.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.appPrimaryColor,
                        borderRadius: BorderRadius.circular(32)),
                    child: Center(
                      child: authController.isLoadingSubmit == false
                          ? Text(
                              "${selectedLanguageStorage.read("languageData")["Continue"] ?? "Continue"}",
                              style: GoogleFonts.niramit(
                                  fontSize: 20.sp,
                                  color: AppColors.appWhiteColor,
                                  fontWeight: FontWeight.w500),
                            )
                          : const CircularProgressIndicator(
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

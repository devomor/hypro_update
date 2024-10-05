import 'package:flutter/material.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/chnage_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  static const String routeName = "/changePasswordScreen";
  ChangePasswordScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordController>(
        builder: (changePasswordController) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.getAppBarBgDarkLight(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(19.0),
                child: Image.asset(
                  "assets/images/arrow_back_btn.png",
                  height: 20.h,
                  width: 20.w,
                  color: AppColors.getTextDarkLight(),
                ),
              )),
          title: Text(
            "${selectedLanguageStorage.read("languageData")["Change Password"] ?? "Change Password"}",
            style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: AppColors.getTextDarkLight(),
            ),
          ),
        ),
        backgroundColor: AppColors.getBackgroundDarkLight(),
        body: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: double.infinity,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 20.h, left: 24.w, right: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${selectedLanguageStorage.read("languageData")["Current Password"] ?? "Current Password"}",
                            style: GoogleFonts.niramit(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: AppColors.getTextDarkLight()),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'CurrentPassword is required';
                              }
                              return null;
                            },
                            controller:
                                changePasswordController.currentPassword,
                            obscureText: !changePasswordController
                                .isCurrentPasswordVisible.value,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      changePasswordController
                                          .toggleCurrentPasswordVisibility();
                                    },
                                    child: Icon(
                                      changePasswordController
                                              .isCurrentPasswordVisible.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    )),
                                contentPadding: EdgeInsets.only(
                                    right: 12, top: 10, bottom: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Set the border radius here
                                  borderSide: BorderSide
                                      .none, // Remove the default border
                                ),
                                fillColor: AppColors.getTextFieldDarkLight(),
                                filled: true,
                                hintText:
                                    "${selectedLanguageStorage.read("languageData")["Enter Current Password"] ?? "Enter Current Password"}",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Image.asset(
                                      "assets/images/password_textfield_img.png",
                                      height: 12.h),
                                ),
                                hintStyle: GoogleFonts.niramit(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    color: AppColors.appBlackColor30)),
                          ),
                          SizedBox(
                            height: 32.h,
                          ),
                          Text(
                            "${selectedLanguageStorage.read("languageData")["New Password"] ?? "New Password"}",
                            style: GoogleFonts.niramit(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: AppColors.getTextDarkLight()),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'New Password is required';
                              }
                              return null;
                            },
                            controller: changePasswordController.password,
                            obscureText: !changePasswordController
                                .isPasswordVisible.value,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    changePasswordController
                                        .togglePasswordVisibility();
                                  },
                                  child: Icon(
                                    changePasswordController
                                            .isPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(
                                    right: 12, top: 10, bottom: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Set the border radius here
                                  borderSide: BorderSide
                                      .none, // Remove the default border
                                ),
                                fillColor: AppColors.getTextFieldDarkLight(),
                                filled: true,
                                hintText:
                                    "${selectedLanguageStorage.read("languageData")["Enter New Password"] ?? "Enter New Password"}",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Image.asset(
                                      "assets/images/password_textfield_img.png",
                                      height: 12.h),
                                ),
                                hintStyle: GoogleFonts.niramit(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    color: AppColors.appBlackColor30)),
                          ),
                          SizedBox(
                            height: 32.h,
                          ),
                          Text(
                            "${selectedLanguageStorage.read("languageData")["Confirm Password"] ?? "Confirm Password"}",
                            style: GoogleFonts.niramit(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: AppColors.getTextDarkLight()),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Confirm Password is required';
                              }
                              return null;
                            },
                            obscureText: !changePasswordController
                                .isConfirmPasswordVisible.value,
                            controller:
                                changePasswordController.confirmPassword,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    changePasswordController
                                        .toggleConfirmPasswordVisibility();
                                  },
                                  child: Icon(
                                    changePasswordController
                                            .isConfirmPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(
                                    right: 12, top: 10, bottom: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Set the border radius here
                                  borderSide: BorderSide
                                      .none, // Remove the default border
                                ),
                                fillColor: AppColors.getTextFieldDarkLight(),
                                filled: true,
                                hintText:
                                    "${selectedLanguageStorage.read("languageData")["Confirm Password"] ?? "Confirm Password"}",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Image.asset(
                                      "assets/images/password_textfield_img.png",
                                      height: 12.h),
                                ),
                                hintStyle: GoogleFonts.niramit(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    color: AppColors.appBlackColor30)),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                changePasswordController.changePasswordRequest(
                                    changePasswordController
                                        .currentPassword.text
                                        .toString(),
                                    changePasswordController.password.text
                                        .toString(),
                                    changePasswordController
                                        .confirmPassword.text
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
                                    changePasswordController.isLoading == false
                                        ? Text(
                                            "${selectedLanguageStorage.read("languageData")["Update Password"] ?? "Update Password"}",
                                            style: GoogleFonts.niramit(
                                                fontSize: 20.sp,
                                                color: AppColors.appWhiteColor,
                                                fontWeight: FontWeight.w500),
                                          )
                                        : Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.appPrimaryColor,
                                            ),
                                          ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

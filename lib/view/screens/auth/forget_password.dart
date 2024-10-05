import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${selectedLanguageStorage.read("languageData")["Forgot Password"] ?? "Forgot Password"}",
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
                    "${selectedLanguageStorage.read("languageData")["Enter your email for the verification process, we will send 5 digits code to your email."] ?? "Enter your email for the verification process, we will send 5 digits code to your email."}",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Dubai',
                        color: AppColors.appBlackColor50,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Text(
                    "${selectedLanguageStorage.read("languageData")["Email"] ?? "Email"}",
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: 'Dubai',
                        color: Get.isDarkMode
                            ? AppColors.appWhiteColor
                            : AppColors.appBlackColor40,
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
                      // Add email format validation using regex
                      bool isEmailValid = RegExp(
                        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                      ).hasMatch(value);

                      if (!isEmailValid) {
                        return 'Invalid email format';
                      }

                      // Return null if validation passes
                      return null;
                    },
                    controller: authController.forgetPasswordTxt,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          "${selectedLanguageStorage.read("languageData")["Enter your email"] ?? "Enter your email"}",
                      hintStyle: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Dubai',
                          color: AppColors.appBlackColor30,
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      filled: true, // Fill the background with color
                      fillColor:
                          AppColors.getTextFieldDarkLight(), // Background color
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        authController.forgetPasswordRequest(context,
                            authController.forgetPasswordTxt.text.toString());
                      }
                    },
                    child: Container(
                      height: 52.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColors.appPrimaryColor,
                          borderRadius: BorderRadius.circular(32)),
                      child: Center(
                        child: authController.isLoadingForgetPassword == false
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
          ),
        ],
      );
    });
  }
}

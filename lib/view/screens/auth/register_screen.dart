import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = "/registerScreen";
  RegisterScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.getBackgroundDarkLight(),
        body: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Text(
                      "${selectedLanguageStorage.read("languageData")["Create Account"] ?? "Create Account"}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.publicSans(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.getTextDarkLight(),
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      "${selectedLanguageStorage.read("languageData")["Hello there, Sign Up to continue!"] ?? "Hello there, Sign Up to continue!"}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.niramit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.appBlackColor30,
                      ),
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    TextFormField(
                      controller: authController.sponsorTxt,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(right: 12, top: 10, bottom: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Set the border radius here
                            borderSide:
                                BorderSide.none, // Remove the default border
                          ),
                          fillColor: AppColors.getTextFieldDarkLight(),
                          filled: true,
                          hintText:
                              "${selectedLanguageStorage.read("languageData")["Enter Referral Username (Optional)"] ?? "Enter Referral Username (Optional)"}",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                                "assets/images/refer_txtfield_img.png",
                                height: 12.h),
                          ),
                          hintStyle: GoogleFonts.niramit(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: AppColors.appBlackColor30)),
                    ),
                    SizedBox(
                      height: 28.h,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Firstname is required';
                        }
                        return null;
                      },
                      controller: authController.firstNameTxt,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(right: 12, top: 10, bottom: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Set the border radius here
                            borderSide:
                                BorderSide.none, // Remove the default border
                          ),
                          fillColor: AppColors.getTextFieldDarkLight(),
                          filled: true,
                          hintText:
                              "${selectedLanguageStorage.read("languageData")["First Name"] ?? "First Name"}",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                                "assets/images/fname_lname_img.png",
                                height: 12.h),
                          ),
                          hintStyle: GoogleFonts.niramit(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: AppColors.appBlackColor30)),
                    ),
                    SizedBox(
                      height: 28.h,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Lastname is required';
                        }
                        return null;
                      },
                      controller: authController.lastNameTxt,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(right: 12, top: 10, bottom: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Set the border radius here
                            borderSide:
                                BorderSide.none, // Remove the default border
                          ),
                          fillColor: AppColors.getTextFieldDarkLight(),
                          filled: true,
                          hintText:
                              "${selectedLanguageStorage.read("languageData")["Last Name"] ?? "Last Name"}",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                                "assets/images/fname_lname_img.png",
                                height: 12.h),
                          ),
                          hintStyle: GoogleFonts.niramit(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: AppColors.appBlackColor30)),
                    ),
                    SizedBox(
                      height: 28.h,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                      controller: authController.userNameTxt,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(right: 12, top: 10, bottom: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Set the border radius here
                            borderSide:
                                BorderSide.none, // Remove the default border
                          ),
                          fillColor: AppColors.getTextFieldDarkLight(),
                          filled: true,
                          hintText:
                              "${selectedLanguageStorage.read("languageData")["Username"] ?? "Username"}",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                                "assets/images/person_textfield_img.png",
                                height: 12.h),
                          ),
                          hintStyle: GoogleFonts.niramit(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: AppColors.appBlackColor30)),
                    ),
                    SizedBox(
                      height: 28.h,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                      controller: authController.emailAddressTxt,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(right: 12, top: 10, bottom: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Set the border radius here
                            borderSide:
                                BorderSide.none, // Remove the default border
                          ),
                          fillColor: AppColors.getTextFieldDarkLight(),
                          filled: true,
                          hintText:
                              "${selectedLanguageStorage.read("languageData")["Email Address"] ?? "Email Address"}",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset("assets/images/mail_img.png",
                                height: 12.h),
                          ),
                          hintStyle: GoogleFonts.niramit(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: AppColors.appBlackColor30)),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.getTextFieldDarkLight(),
                            ),
                            child: CountryCodePicker(
                              dialogBackgroundColor: Get.isDarkMode
                                  ? AppColors.appContainerBgColor
                                  : AppColors.appWhiteColor,
                              dialogTextStyle: TextStyle(
                                  color: Get.isDarkMode
                                      ? AppColors.appWhiteColor
                                      : AppColors.appBlackColor),
                              textStyle: const TextStyle(
                                  fontSize: 12.0,
                                  color: AppColors.appBlackColor30),
                              onChanged: (CountryCode countryCode) {
                                authController.selectedCountryCode.value =
                                    countryCode;
                                if (kDebugMode) {
                                  print(
                                      authController.selectedCountryCode.value);
                                }
                                authController.selectedCountryName.value =
                                    countryCode.name!;
                                authController.selectedCountryNameCode.value =
                                    countryCode.code!;

                                if (kDebugMode) {
                                  print(
                                      'Selected Country Name: ${authController.selectedCountryName.value}');
                                  print(
                                      'Selected Country Code: ${authController.selectedCountryNameCode.value}');
                                }
                              },
                              initialSelection: 'US',
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 6),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Phone number is required';
                                }
                                return null;
                              },
                              controller: authController.phoneTxt,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
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
                                      "${selectedLanguageStorage.read("languageData")["Phone Number"] ?? "Phone Number"}",
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Image.asset(
                                        "assets/images/call_img.png",
                                        height: 12.h),
                                  ),
                                  hintStyle: GoogleFonts.niramit(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp,
                                      color: AppColors.appBlackColor30)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 28.h,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      controller: authController.passwordTxt,
                      obscureText:
                          !authController.isRegisterPasswordVisible.value,
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              authController.toggleRegisterPasswordVisibility();
                            },
                            child: Icon(
                                authController.isRegisterPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Get.isDarkMode
                                    ? AppColors.appBlackColor50
                                    : AppColors.appBlackColor50),
                          ),
                          contentPadding:
                              EdgeInsets.only(right: 12, top: 10, bottom: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Set the border radius here
                            borderSide:
                                BorderSide.none, // Remove the default border
                          ),
                          fillColor: AppColors.getTextFieldDarkLight(),
                          filled: true,
                          hintText:
                              "${selectedLanguageStorage.read("languageData")["Password"] ?? "Password"}",
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
                      height: 28.h,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Confirm password is required';
                        }
                        return null;
                      },
                      controller: authController.confirmPasswordTxt,
                      obscureText: !authController
                          .isRegisterConfirmPasswordVisible.value,
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              authController
                                  .toggleRegisterConfirmPasswordVisibility();
                            },
                            child: Icon(
                                authController
                                        .isRegisterConfirmPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Get.isDarkMode
                                    ? AppColors.appBlackColor50
                                    : AppColors.appBlackColor50),
                          ),
                          contentPadding:
                              EdgeInsets.only(right: 12, top: 10, bottom: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Set the border radius here
                            borderSide:
                                BorderSide.none, // Remove the default border
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
                      height: 32.h,
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          authController.register(
                              context,
                              authController.firstNameTxt.text.toString(),
                              authController.lastNameTxt.text.toString(),
                              authController.userNameTxt.text.toString(),
                              authController.emailAddressTxt.text.toString(),
                              authController.selectedCountryNameCode.value
                                  .toString(),
                              authController.selectedCountryCode.value
                                  .toString(),
                              "${authController.selectedCountryCode.value}${authController.phoneTxt.text.toString()}",
                              authController.passwordTxt.text.toString(),
                              authController.confirmPasswordTxt.text.toString(),
                              authController.sponsorTxt.text.toString());
                        }
                      },
                      child: Container(
                        height: 52.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.appPrimaryColor,
                            borderRadius: BorderRadius.circular(32)),
                        child: Center(
                          child: authController.isLoadingRegister == false
                              ? Text(
                                  "${selectedLanguageStorage.read("languageData")["Register"] ?? "Register"}",
                                  style: GoogleFonts.niramit(
                                      fontSize: 20.sp,
                                      color: AppColors.appWhiteColor,
                                      fontWeight: FontWeight.w500,
                                      height: 0.9),
                                )
                              : const CircularProgressIndicator(
                                  color: AppColors.appWhiteColor,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${selectedLanguageStorage.read("languageData")["Already have an account?"] ?? "Already have an account?"}",
                          style: GoogleFonts.niramit(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: AppColors.appBlackColor30),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "${selectedLanguageStorage.read("languageData")["Login"] ?? "Login"}",
                            style: GoogleFonts.niramit(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: AppColors.appPrimaryColor),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Get.isDarkMode
                ? Image.asset(
                    "assets/images/auth_bottom_shape.png",
                    color: AppColors.appContainerBgColor,
                  )
                : Image.asset("assets/images/auth_bottom_shape.png"),
          ],
        ),
      );
    });
  }
}

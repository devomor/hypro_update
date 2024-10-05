import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/view/screens/auth/forget_password.dart';
import 'package:flutter_hypro/view/screens/auth/register_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/loginScreen";
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final selectedLanguageStorage = GetStorage();

  bool isRemember = false;

  @override
  void initState() {
    super.initState();
    // Retrieve saved credentials from SharedPreferences
    retrieveSavedCredentials();
  }

  // Function to retrieve saved credentials from SharedPreferences
  void retrieveSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Get.find<AuthController>().loginUserNameTxt.text =
          prefs.getString('username') ?? '';
      Get.find<AuthController>().loginUserNameTxt.text =
          prefs.getString('password') ?? '';
      isRemember = Get.find<AuthController>().loginUserNameTxt.text.isNotEmpty;
    });
  }

  // Function to save credentials to SharedPreferences
  void saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'username', Get.find<AuthController>().loginUserNameTxt.text);
    prefs.setString(
        'password', Get.find<AuthController>().loginPasswordTxt.text);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.getBackgroundDarkLight(),
        body: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 158.h,
                        ),
                        Text(
                          "${selectedLanguageStorage.read("languageData")["Log In"] ?? "Log In"}",
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
                          "${selectedLanguageStorage.read("languageData")["Hello there, log in to continue!"] ?? "Hello there, log in to continue!"}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.niramit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.appBlackColor30,
                          ),
                        ),
                        SizedBox(
                          height: 100.h,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          },
                          controller: authController.loginUserNameTxt,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
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
                                  "${selectedLanguageStorage.read("languageData")["Username or Email"] ?? "Username or Email"}",
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
                          height: 32.h,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                          obscureText:
                              !authController.isLoginPasswordVisible.value,
                          controller: authController.loginPasswordTxt,
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    authController
                                        .toggleLoginPasswordVisibility();
                                  },
                                  child: Icon(
                                      authController
                                              .isLoginPasswordVisible.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Get.isDarkMode
                                          ? AppColors.appBlackColor50
                                          : AppColors.appBlackColor50)),
                              contentPadding: const EdgeInsets.only(
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
                          height: 24.h,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 2),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isRemember = !isRemember;

                                    if (!isRemember) {
                                      // Clear saved credentials if not checked
                                      clearSavedCredentials();
                                    }
                                  });
                                },
                                child: Container(
                                  width: 16.w,
                                  height: 16.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                      color: AppColors
                                          .appBlackColor30, // Border color when unchecked
                                      width: 1,
                                    ),
                                    color: isRemember
                                        ? AppColors.appPrimaryColor
                                        : Colors.white,
                                  ),
                                  child: isRemember
                                      ? Icon(
                                          Icons.check,
                                          color: Colors
                                              .white, // Checkmark color when checked
                                          size: 10.h,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            Text(
                                "${selectedLanguageStorage.read("languageData")["Remember Me"] ?? "Remember Me"}",
                                style: GoogleFonts.niramit(
                                    color: AppColors.appBlackColor30,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp)),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Get.bottomSheet(
                                  Container(
                                    color: AppColors.getBackgroundDarkLight(),
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 10.h,
                                      ),
                                      child: ForgetPassword(),
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                  "${selectedLanguageStorage.read("languageData")["Forgot Your Password?"] ?? "Forgot Your Password?"}",
                                  style: GoogleFonts.niramit(
                                      color: AppColors.appPrimaryColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 48.h,
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              authController.login(
                                  context,
                                  authController.loginUserNameTxt.text
                                      .toString(),
                                  authController.loginPasswordTxt.text
                                      .toString());

                              // Save credentials only if "Remember Me" is checked
                              if (isRemember) {
                                saveCredentials();
                              }
                            }
                          },
                          child: Container(
                            height: 52.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColors.appPrimaryColor,
                                borderRadius: BorderRadius.circular(32)),
                            child: Center(
                              child: authController.isLoadingLogin == false
                                  ? Text(
                                      "${selectedLanguageStorage.read("languageData")["Log In"] ?? "Log In"}",
                                      style: GoogleFonts.niramit(
                                          fontSize: 20.sp,
                                          color: AppColors.appWhiteColor,
                                          fontWeight: FontWeight.w500,
                                          height: 0.9),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(
                                      color: AppColors.appWhiteColor,
                                    )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Get.isDarkMode
                    ? Image.asset(
                        "assets/images/auth_bottom_shape.png",
                        color: AppColors.appContainerBgColor,
                      )
                    : Image.asset(
                        "assets/images/auth_bottom_shape.png",
                      )),
            Positioned(
                bottom: 130.h,
                left: 0,
                right: 0,
                child: Center(
                    child: Column(
                  children: [
                    Text(
                      "${selectedLanguageStorage.read("languageData")["Don’t have an account?"] ?? "Don’t have an account?"}",
                      style: GoogleFonts.niramit(
                          fontSize: 16.sp,
                          color: AppColors.appBlackColor30,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RegisterScreen.routeName);
                      },
                      child: Text(
                        "${selectedLanguageStorage.read("languageData")["Create account"] ?? "Create account"}",
                        style: GoogleFonts.niramit(
                            fontSize: 16.sp,
                            color: AppColors.appPrimaryColor,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                )))
          ],
        ),
      );
    });
  }

  // Function to clear saved credentials from SharedPreferences
  void clearSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('password');
  }
}

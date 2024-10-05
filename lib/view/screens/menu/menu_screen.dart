import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/controller/my_account_controller.dart';
import 'package:flutter_hypro/language/language_screen.dart';
import 'package:flutter_hypro/theme/theme_service.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:flutter_hypro/view/screens/menu/address_verification_screen.dart';
import 'package:flutter_hypro/view/screens/menu/change_password_screen.dart';
import 'package:flutter_hypro/view/screens/menu/edit_account_screen.dart';
import 'package:flutter_hypro/view/screens/menu/identity_verification_screen.dart';
import 'package:flutter_hypro/view/screens/menu/two_fa_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final selectedLanguageStorage = GetStorage();

  bool isSwitched = false;

  ThemeService themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    isSwitched = ThemeService().isSavedDarkMode();
  }

  void toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
      ThemeService().changeThemeMode();
      ThemeService().saveThemeSwitchState(isSwitched);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyAccountController>(builder: (myAccountController) {
      print("profile image ${myAccountController.message?.userImage}");
      return Scaffold(
        // backgroundColor: AppColors.getBackgroundDarkLight(),
        appBar: AppBar(
          titleSpacing: 24,
          //backgroundColor: AppColors.getAppBarBgDarkLight(),
          automaticallyImplyLeading: false,
          title: Text(
            "${selectedLanguageStorage.read("languageData")["Settings"] ?? "Settings"}",
            style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              //color: AppColors.getTextDarkLight()
            ),
          ),
        ),

        body: ListView(
          children: [
            myAccountController.isLoading == false &&
                    myAccountController.message != null
                ? Padding(
                    padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 0.h),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 12.h,
                        ),
                        Container(
                          height: 220.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 32.h,
                              ),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    "${myAccountController.message?.userImage}",
                                    height: 80.h,
                                    width: 80.w,
                                  )),
                              SizedBox(
                                height: 16.h,
                              ),
                              Text(
                                "${myAccountController.message?.username}",
                                style: GoogleFonts.niramit(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22.sp,
                                  //color: AppColors.getTextDarkLight(),
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                "${myAccountController.message?.userJoinDate}",
                                style: GoogleFonts.niramit(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    color: AppColors.appBlackColor50),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 30.h),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.w, right: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${selectedLanguageStorage.read("languageData")["Theme"] ?? "Theme"}",
                                  style: GoogleFonts.niramit(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp,
                                      color: AppColors.appPrimaryColor),
                                ),

                                SizedBox(
                                  height: 8.h,
                                ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                            EditAccountScreen.routeName);
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Image.asset(
                                              "assets/images/dark_theme.png",
                                              height: 22.h,
                                              width: 22.w,
                                              color:
                                                  AppColors.getTextDarkLight(),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12.w,
                                          ),
                                          Text(
                                            "${selectedLanguageStorage.read("languageData")["Light/Dark"] ?? "Light/Dark"}",
                                            style: GoogleFonts.niramit(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              //color: AppColors.getTextDarkLight(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GetBuilder<ThemeService>(
                                        builder: (themeService) {
                                      return Center(
                                        child: CupertinoSwitch(
                                          activeColor:
                                              AppColors.appPrimaryColor,
                                          value: isSwitched,
                                          onChanged: (value) {
                                            toggleSwitch(value);
                                          },
                                        ),
                                      );
                                    })
                                  ],
                                ),

                                SizedBox(
                                  height: 40.h,
                                ),

                                Text(
                                  "${selectedLanguageStorage.read("languageData")["Profile Setting"] ?? "Profile Setting"}",
                                  style: GoogleFonts.niramit(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp,
                                      color: AppColors.appPrimaryColor),
                                ),

                                SizedBox(
                                  height: 24.h,
                                ),

                                //Edit profile
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(EditAccountScreen.routeName);
                                  },
                                  child: Container(
                                    width: 350.w,
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Image.asset(
                                                "assets/images/dark_edit_profile.png",
                                                height: 18.h, width: 18.w,
                                                //color: AppColors.getTextDarkLight(),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12.w,
                                            ),
                                            Text(
                                              "${selectedLanguageStorage.read("languageData")["Edit Profile"] ?? "Edit Profile"}",
                                              style: GoogleFonts.niramit(
                                                  fontSize: 16.sp,
                                                  //color: AppColors.getTextDarkLight(),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        Center(
                                            child: Image.asset(
                                          "assets/images/right_arrow.png",
                                          height: 12.h, width: 12.w,
                                          //color: AppColors.getTextDarkLight(),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10.h),

                                Container(
                                  margin: EdgeInsets.only(left: 30.w),
                                  height: 1.h,
                                  width: 350.w,
                                  color: Get.isDarkMode
                                      ? Colors.grey
                                      : AppColors.appBlackColor10,
                                ),

                                SizedBox(
                                  height: 32.h,
                                ),

                                //Language
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(LanguageScreen.routeName);
                                  },
                                  child: Container(
                                    width: 350.w,
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Image.asset(
                                                "assets/images/dark_language.png",
                                                height: 18.h, width: 18.w,
                                                //  color: AppColors.getTextDarkLight(),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12.w,
                                            ),
                                            Text(
                                              "${selectedLanguageStorage.read("languageData")["Language"] ?? "Language"}",
                                              style: GoogleFonts.niramit(
                                                  fontSize: 16.sp,
                                                  //  color: AppColors.getTextDarkLight(),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        Center(
                                            child: Image.asset(
                                          "assets/images/right_arrow.png",
                                          height: 12.h,
                                          width: 12.w,
                                          //color: AppColors.getTextDarkLight(),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  margin: EdgeInsets.only(left: 30.w),
                                  height: 1.h,
                                  width: 350.w,
                                  color: Get.isDarkMode
                                      ? Colors.grey
                                      : AppColors.appBlackColor10,
                                ),

                                SizedBox(
                                  height: 32.h,
                                ),

                                //Change password
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(ChangePasswordScreen.routeName);
                                  },
                                  child: Container(
                                    width: 350.w,
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Image.asset(
                                                "assets/images/dark_password.png",
                                                height: 18.h,
                                                width: 18.w,
                                                //color: AppColors.getTextDarkLight(),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12.w,
                                            ),
                                            Text(
                                              "${selectedLanguageStorage.read("languageData")["Change password"] ?? "Change Password"}",
                                              style: GoogleFonts.niramit(
                                                  fontSize: 16.sp,
                                                  //color: AppColors.getTextDarkLight(),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        Center(
                                            child: Image.asset(
                                          "assets/images/right_arrow.png",
                                          height: 12.h,
                                          width: 12.w,
                                          //color: AppColors.getTextDarkLight(),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  margin: EdgeInsets.only(left: 30.w),
                                  height: 1.h,
                                  width: 350.w,
                                  color: Get.isDarkMode
                                      ? Colors.grey
                                      : AppColors.appBlackColor10,
                                ),

                                SizedBox(
                                  height: 32.h,
                                ),

                                //Identity Verification
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                        IdentityVerificationScreen.routeName);
                                  },
                                  child: Container(
                                    width: 350.w,
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Image.asset(
                                                "assets/images/dark_identity_verification.png",
                                                height: 18.h,
                                                width: 18.w,
                                                // color: AppColors.getTextDarkLight(),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12.w,
                                            ),
                                            Text(
                                              "${selectedLanguageStorage.read("languageData")["Identity Verification"] ?? "Identity Verification"}",
                                              style: GoogleFonts.niramit(
                                                  fontSize: 16.sp,
                                                  //color: AppColors.getTextDarkLight(),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        Center(
                                            child: Image.asset(
                                          "assets/images/right_arrow.png",
                                          height: 12.h,
                                          width: 12.w,
                                          //color: AppColors.getTextDarkLight(),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  margin: EdgeInsets.only(left: 30.w),
                                  height: 1.h,
                                  width: 350.w,
                                  color: Get.isDarkMode
                                      ? Colors.grey
                                      : AppColors.appBlackColor10,
                                ),

                                SizedBox(
                                  height: 32.h,
                                ),

                                //Address verification
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                        AddressVerificationScreen.routeName);
                                  },
                                  child: Container(
                                    width: 350.w,
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Image.asset(
                                                "assets/images/dark_address.png",
                                                height: 18.h, width: 18.w,
                                                // color: AppColors.getTextDarkLight(),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12.w,
                                            ),
                                            Text(
                                              "${selectedLanguageStorage.read("languageData")["Address Verification"] ?? "Address Verification"}",
                                              style: GoogleFonts.niramit(
                                                  fontSize: 16.sp,
                                                  // color: AppColors.getTextDarkLight(),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        Center(
                                            child: Image.asset(
                                          "assets/images/right_arrow.png",
                                          height: 12.h,
                                          width: 12.w,
                                          //color: AppColors.getTextDarkLight(),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  margin: EdgeInsets.only(left: 30.w),
                                  height: 1.h,
                                  width: 350.w,
                                  color: Get.isDarkMode
                                      ? Colors.grey
                                      : AppColors.appBlackColor10,
                                ),

                                SizedBox(
                                  height: 32.h,
                                ),

                                //Two Fa Security
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(TwoFaScreen.routeName);
                                  },
                                  child: Container(
                                    width: 350.w,
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Image.asset(
                                                "assets/images/dark_two_fa.png",
                                                height: 18.h, width: 18.w,
                                                //color: AppColors.getTextDarkLight(),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12.w,
                                            ),
                                            Text(
                                              "${selectedLanguageStorage.read("languageData")["2FA Security"] ?? "2FA Security"}",
                                              style: GoogleFonts.niramit(
                                                  fontSize: 16.sp,
                                                  //color: AppColors.getTextDarkLight(),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        Center(
                                            child: Image.asset(
                                          "assets/images/right_arrow.png",
                                          height: 12.h,
                                          width: 12.w,
                                          //color: AppColors.getTextDarkLight(),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  margin: EdgeInsets.only(left: 30.w),
                                  height: 1.h,
                                  width: 350.w,
                                  color: Get.isDarkMode
                                      ? Colors.grey
                                      : AppColors.appBlackColor10,
                                ),

                                SizedBox(
                                  height: 32.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.defaultDialog(
                                      titlePadding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      radius: 10,
                                      backgroundColor:
                                          AppColors.getContainerBgDarkLight(),
                                      titleStyle: GoogleFonts.publicSans(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.appPrimaryColor,
                                      ),
                                      title:
                                          "${selectedLanguageStorage.read("languageData")["Log Out"] ?? "Log Out"}",
                                      content: Column(
                                        children: [
                                          Container(
                                            height: 1.h,
                                            width: 350.w,
                                            color: Get.isDarkMode
                                                ? Colors.white12
                                                : Colors.black12,
                                          ),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          Text(
                                            "${selectedLanguageStorage.read("languageData")["Do you want to Log Out?"] ?? "Do you want to Log Out?"}",
                                            style: GoogleFonts.publicSans(
                                              fontSize: 16.sp,
                                              color:
                                                  AppColors.getTextDarkLight(),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.back(); // Close the dialog
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors
                                                .appDashBoardTransactionRed,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            "${selectedLanguageStorage.read("languageData")["No"] ?? "No"}",
                                            style: TextStyle(
                                                color: AppColors.appWhiteColor),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16.w,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            Get.find<AuthController>()
                                                .removeUserToken();
                                            await Get.offNamedUntil(
                                                LoginScreen.routeName,
                                                (route) => false);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors
                                                .appDashBoardTransactionGreen,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            "${selectedLanguageStorage.read("languageData")["Yes"] ?? "Yes"}",
                                            style: TextStyle(
                                                color: AppColors.appWhiteColor),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                      ],
                                    );
                                  },
                                  child: Container(
                                    width: 350.w,
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Image.asset(
                                                "assets/images/dark_logout.png",
                                                height: 18.h, width: 18.w,
                                                //color: AppColors.getTextDarkLight(),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12.w,
                                            ),
                                            Text(
                                              "${selectedLanguageStorage.read("languageData")["Log Out"] ?? "Log Out"}",
                                              style: GoogleFonts.niramit(
                                                  fontSize: 16.sp,
                                                  //color: AppColors.getTextDarkLight(),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.all(28.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
          ],
        ),
      );
    });
  }
}

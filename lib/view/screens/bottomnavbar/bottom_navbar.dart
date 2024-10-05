import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/bottom_navbar_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upgrader/upgrader.dart';

class BottomNavBar extends StatefulWidget {
  static const String routeName = '/bottomNavbar';

  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavController>(
      init: BottomNavController(),
      builder: (controller) => PopScope(
        canPop: false,
        onPopInvoked: (v) async {
          if (v) {
            return;
          }
          if (controller.selectedIndex == 0) {
            return await Get.defaultDialog(
              titlePadding: EdgeInsets.symmetric(vertical: 10),
              radius: 10,
              backgroundColor: AppColors.getContainerBgDarkLight(),
              titleStyle: GoogleFonts.publicSans(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.appPrimaryColor,
              ),
              title: "Alert!",
              content: Column(
                children: [
                  Container(
                    height: 1.h,
                    width: 350.w,
                    color: Get.isDarkMode ? Colors.white12 : Colors.black12,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    "${selectedLanguageStorage.read("languageData")["Do you want to Exit?"] ?? "Do you want to Exit?"}",
                    style: GoogleFonts.publicSans(
                      fontSize: 17.sp,
                      color: AppColors.getTextDarkLight(),
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
                    backgroundColor: AppColors.appDashBoardTransactionRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "${selectedLanguageStorage.read("languageData")["No"] ?? "No"}",
                    style: TextStyle(color: AppColors.appWhiteColor),
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                ElevatedButton(
                  onPressed: () async {
                    exit(0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appDashBoardTransactionGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "${selectedLanguageStorage.read("languageData")["Yes"] ?? "Yes"}",
                    style: TextStyle(color: AppColors.appWhiteColor),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            );
          } else {
            setState(() {
              controller.selectedIndex = 0;
            });
          }
        },
        child: UpgradeAlert(
          // upgrader: Upgrader(dialogStyle: UpgradeDialogStyle.material),
          child: Scaffold(
            //backgroundColor: AppColors.getBackgroundDarkLight(),
            body: controller.currentScreen,
            bottomNavigationBar: BottomAppBar(
              height: 70.h,
              elevation: 1,
              // color: AppColors.getAppBarBgDarkLight(),
              notchMargin: 8,
              shape: const CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Image.asset(
                      "assets/images/home.png",
                      height: 25.h,
                      width: 25.w,
                      color: controller.selectedIndex == 0
                          ? AppColors.appPrimaryColor
                          : AppColors.appBlackColor50,
                    ),
                    onPressed: () => controller.changeScreen(0),
                  ),
                  IconButton(
                    icon: Image.asset(
                      "assets/images/plan.png",
                      height: 25.h,
                      width: 25.w,
                      color: controller.selectedIndex == 1
                          ? AppColors.appPrimaryColor
                          : AppColors.appBlackColor50,
                    ),
                    onPressed: () => controller.changeScreen(1),
                  ),
                  IconButton(
                    icon: Image.asset(
                      "assets/images/transaction.png",
                      height: 25.h,
                      width: 25.w,
                      color: controller.selectedIndex == 3
                          ? AppColors.appPrimaryColor
                          : AppColors.appBlackColor50,
                    ),
                    onPressed: () => controller.changeScreen(3),
                  ),
                  IconButton(
                    icon: Image.asset(
                      "assets/images/menu_icon_new.png",
                      height: 25.h,
                      width: 25.w,
                      color: controller.selectedIndex == 4
                          ? AppColors.appPrimaryColor
                          : AppColors.appBlackColor50,
                    ),
                    onPressed: () => controller.changeScreen(4),
                  ),
                ],
              ),
            ),
            // floatingActionButton: ClipOval(
            //   child: FloatingActionButton(
            //     backgroundColor: AppColors.appPrimaryColor,
            //     child: Image.asset(
            //       "assets/images/transfer_bottom.png",
            //       height: 20.h,
            //       width: 20.w,
            //       fit: BoxFit.cover,
            //     ),
            //     onPressed: () {
            //       controller.changeScreen(2);
            //     },
            //   ),
            // ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          ),
        ),
      ),
    );
  }
}

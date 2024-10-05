import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/app_config_controller.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/controller/language_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/view/screens/bottomnavbar/bottom_navbar.dart';
import 'package:flutter_hypro/view/screens/onboarding/onboarding_screen.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final authController = Get.find<AuthController>();

  LanguageController languageController = Get.find<LanguageController>();

  @override
  void onInit() async {
    super.onInit();
    getDeviceId();
    Get.find<AppConfigController>().getConfigData().then((value) {
      languageController.getLanguageDataById(1).then((value) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          AppColors.appPrimaryColor =
              Get.find<AppConfigController>().message!.baseColor != null
                  ? Color(int.parse(Get.find<AppConfigController>()
                      .message!
                      .baseColor!
                      .replaceAll('#', '0xFF')))
                  : AppColors.appPrimaryColor;
          _navigateToScreen();
        });
      });
    });
  }

  String deviceId = 'Loading...';

  Future<void> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id; // Unique ID on Android
      print("Check Device Id : ${deviceId}");
      update();
    } catch (e) {
      print('Failed to get device info: $e');
    }
  }

  void _navigateToScreen() {
    authController.getUserToken().toString().isEmpty
        ? Get.offNamedUntil(
            OnboardingScreen.routeName,
            (route) => false,
          )
        : Get.offNamedUntil(
            BottomNavBar.routeName,
            (route) => false,
          );
  }
}

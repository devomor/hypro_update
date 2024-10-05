import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/repository/change_password_repo.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:get/get.dart';

import '../view/verify_required/mail_verification_screen.dart';
import '../view/verify_required/sms_verification_screen.dart';
import '../view/verify_required/two_factor_verification_screen.dart';

class ChangePasswordController extends GetxController {
  final currentPassword = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final ChangePasswordRepo changePasswordRepo;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ChangePasswordController({required this.changePasswordRepo});

  Future<dynamic> changePasswordRequest(
    dynamic currentPassword,
    dynamic password,
    dynamic passwordConfirm,
  ) async {
    _isLoading = true;
    update();

    ApiResponse apiResponse = await changePasswordRepo.changePasswordRequest(
        currentPassword, password, passwordConfirm);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        if (apiResponse.response!.data["message"] ==
            "Email Verification Required") {
          Get.offAllNamed(MailVerificationScreen.routeName);
        } else if (apiResponse.response!.data["message"] ==
            "Mobile Verification Required") {
          Get.offAllNamed(SmsVerificationScreen.routeName);
        } else if (apiResponse.response!.data["message"] ==
            "Two FA Verification Required") {
          Get.offAllNamed(TwoFactorVerificationScreen.routeName);
        } else if (apiResponse.response!.data["message"] ==
            "Your account has been suspend") {
          Get.find<AuthController>().removeUserToken();
          await Get.offNamedUntil(LoginScreen.routeName, (route) => false);
        } else {
          dynamic status = apiResponse.response!.data['status'];
          dynamic msg = apiResponse.response!.data['message'];
          Get.snackbar(
            'Message',
            '${msg}',
            backgroundColor:
                status == "success" ? AppColors.appGreen50 : Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(10),
            borderRadius: 8,
            shouldIconPulse: true,
            icon: Icon(status == "success" ? Icons.check : Icons.cancel,
                color: Colors.white),
            barBlur: 10,
          );
          update();
        }
      }
    } else {
      _isLoading = false;
      update();
    }
  }

  var isCurrentPasswordVisible = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
    update();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    update();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
    update();
  }
}

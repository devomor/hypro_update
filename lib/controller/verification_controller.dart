import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/controller/my_account_controller.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/repository/verification_repo.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:flutter_hypro/view/verify_required/mail_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/sms_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/two_factor_verification_screen.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController {
  final VerificationRepo verificationRepo;

  VerificationController({required this.verificationRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isIdentityLoading = false;
  bool get isIdentityLoading => _isIdentityLoading;

  ///verification Address
  Future<dynamic> sendAddressVerificationRequest(
      dynamic addressImagePath) async {
    _isLoading = true;
    update();
    ApiResponse apiResponse =
        await verificationRepo.sendAddressVerificationRequest(addressImagePath);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
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
              '$msg',
              backgroundColor: status == "success" ? Colors.green : Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(10),
              borderRadius: 8,
              shouldIconPulse: true,
              icon: Icon(status == "success" ? Icons.check : Icons.cancel,
                  color: Colors.white),
              barBlur: 10,
            );
            update();
          }
        }
      }
    } else {
      _isLoading = false;
      update();
    }
  }

  /// Payout Request
  Future<dynamic> sendIdentityVerificationRequest(
    dynamic identityType,
    List<dynamic> fieldNames,
    List<dynamic> fieldValues,
  ) async {
    _isIdentityLoading = true;
    update();
    ApiResponse apiResponse = await verificationRepo
        .identityVerificationRequest(identityType, fieldNames, fieldValues);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isIdentityLoading = false;
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
          Map map = apiResponse.response!.data;
          dynamic msg;
          msg = map["message"];
          dynamic status;
          status = map["status"];
          if (status == "success") {
            Get.find<MyAccountController>().getAccountData();
          }
          Get.snackbar(
            'Message',
            '$msg',
            backgroundColor: status != "success" ? Colors.red : Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(10),
            borderRadius: 8,
            barBlur: 10,
          );

          update();
        }
      }
    } else {
      _isIdentityLoading = false;
      update();
    }
  }
}

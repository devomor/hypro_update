import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/model/response_model/two_fa_security_model.dart';
import 'package:flutter_hypro/data/repository/two_factor_repo.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:flutter_hypro/view/verify_required/mail_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/sms_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/two_factor_verification_screen.dart';
import 'package:get/get.dart';

class TwoFaSecurityController extends GetxController {
  final TwoFaSecurityRepo twoFaSecurityRepo;

  TwoFaSecurityController({required this.twoFaSecurityRepo});

  final googleAuthEnableCode = TextEditingController();
  final googleAuthDisableCode = TextEditingController();

  String? _status;
  String? get status => _status;
  TwoFaSecurityData? _message;
  TwoFaSecurityData? get message => _message;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TwoFactorSecurityModel twoFactorSecurityModel = TwoFactorSecurityModel();

  ///Two Factor Security Data
  Future<dynamic> getTwoFaSecurityData() async {
    _isLoading = true;
    update();
    ApiResponse apiResponse = await twoFaSecurityRepo.getTwoFaSecurityData();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        _message = null;
        update();
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
          twoFactorSecurityModel =
              TwoFactorSecurityModel.fromJson(apiResponse.response!.data!);
          _message = twoFactorSecurityModel.message;
          update();
        }
      }
    } else {
      _isLoading = false;
      update();
    }
  }

  ///Enable Two Factor Security
  Future<dynamic> enableTwoFactorSecurity(
    dynamic code,
    dynamic key,
  ) async {
    _isLoading = true;
    update();
    ApiResponse apiResponse =
        await twoFaSecurityRepo.enableTwoFactorSecurity(code, key);

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
            backgroundColor: status == "success" ? Colors.green : Colors.red,
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

  ///Disable Two Factor Security
  Future<dynamic> disableTwoFactorSecurity(dynamic code) async {
    _isLoading = true;
    update();
    ApiResponse apiResponse =
        await twoFaSecurityRepo.disableTwoFactorSecurity(code);

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
            backgroundColor: status == "success" ? Colors.green : Colors.red,
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

  @override
  void onInit() {
    getTwoFaSecurityData();
    super.onInit();
  }
}

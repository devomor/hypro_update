import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/repository/payment_done_repo.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:flutter_hypro/view/verify_required/mail_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/sms_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/two_factor_verification_screen.dart';
import 'package:get/get.dart';

class PaymentDoneController extends GetxController {
  final PaymentDoneRepo paymentDoneRepo;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  PaymentDoneController({required this.paymentDoneRepo});

  Future<dynamic> paymentDoneRequest(
    dynamic gateway,
    dynamic amount,
    dynamic planId,
  ) async {
    _isLoading = true;
    update();
    ApiResponse apiResponse =
        await paymentDoneRepo.paymentDoneRequest(gateway, amount, planId);

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
            // dynamic msg = apiResponse.response!.data['message'];
            if (status == "success") {
              // Get.offAllNamed(InvestHistoryScreen.routeName);
              // Get.dialog(PlanPurchaseSuccessful());
            } else {
              Get.snackbar(
                'Message',
                'Payment Failed! Something went wrong',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(10),
                borderRadius: 8,
                shouldIconPulse: true,
                icon: const Icon(Icons.cancel, color: Colors.white),
                barBlur: 10,
              );
            }

            update();
          }
        }
      } else {
        _isLoading = false;
        update();
      }
    }
  }
}

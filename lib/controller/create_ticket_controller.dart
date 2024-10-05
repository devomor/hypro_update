import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/controller/ticket_list_controller.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/repository/create_ticket_repo.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:flutter_hypro/view/verify_required/mail_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/sms_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/two_factor_verification_screen.dart';
import 'package:get/get.dart';

class CreateTicketController extends GetxController {
  var subject = TextEditingController();
  var message = TextEditingController();

  final CreateTicketRepo createTicketRepo;

  CreateTicketController({required this.createTicketRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<dynamic> createTicketRequest(dynamic subject, dynamic message,
      dynamic result, BuildContext context) async {
    _isLoading = true;
    update();
    ApiResponse apiResponse =
        await createTicketRepo.createTicketRequest(subject, message, result);

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
          if (status == "success") {
            Get.find<TicketListController>().getTicketListData(1).then((value) {
              Navigator.pop(context);
            });
          }
          Get.snackbar(
            'Message',
            '${msg}',
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
    } else {
      _isLoading = false;
      update();
    }
  }
}

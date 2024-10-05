import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/model/response_model/view_ticket_model.dart';
import 'package:flutter_hypro/data/repository/view_ticket_repo.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:flutter_hypro/view/verify_required/mail_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/sms_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/two_factor_verification_screen.dart';
import 'package:get/get.dart';

class ViewTicketController extends GetxController {
  final ViewTicketRepo viewTicketRepo;

  ViewTicketController({required this.viewTicketRepo});

  dynamic _status;
  dynamic get status => _status;
  ViewTicketData? _message;
  ViewTicketData? get message => _message;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ViewTicketModel viewTicketModel = ViewTicketModel();

  Future<dynamic> getViewTicketData(dynamic id) async {
    _isLoading = true;
    update();
    ApiResponse apiResponse = await viewTicketRepo.getViewTicketData(id);

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
          viewTicketModel =
              ViewTicketModel.fromJson(apiResponse.response!.data!);
          _message = viewTicketModel.message;
          update();
        }
      }
    } else {
      _isLoading = false;
      update();
    }
  }
}

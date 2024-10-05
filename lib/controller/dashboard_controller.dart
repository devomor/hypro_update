import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/repository/dashboard_repo.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:flutter_hypro/view/verify_required/mail_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/sms_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/two_factor_verification_screen.dart';
import 'package:get/get.dart';

import '../data/model/response_model/dashboard_model.dart';

class DashBoardController extends GetxController {
  final DashBoardRepo dashBoardRepo;

  DashBoardController({required this.dashBoardRepo});

  @override
  void onInit() {
    getDashBoardData();
    super.onInit();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DashBoardModel dashBoardModel = DashBoardModel();

  var selectedTab = 0.obs;

  DashBoardData? _message;

  DashBoardData? get message => _message;

  void changeTab(int index) {
    selectedTab.value = index;
  }

  Future<dynamic> getDashBoardData() async {
    _isLoading = true;
    update();
    ApiResponse apiResponse = await dashBoardRepo.getDashBoardData();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
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
        dashBoardModel = DashBoardModel.fromJson(apiResponse.response!.data!);
        _message = dashBoardModel.message;
        update();
      }
    } else {
      _isLoading = false;
      update();
    }
  }
}

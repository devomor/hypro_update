import 'package:flutter/material.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/repository/verify_required_repo.dart';
import 'package:flutter_hypro/view/screens/bottomnavbar/bottom_navbar.dart';
import 'package:get/get.dart';

class VerifyRequiredController extends GetxController {
  final VerifyRequiredRepo verifyRequiredRepo;

  VerifyRequiredController({required this.verifyRequiredRepo});

  final twoFactorCodeController = TextEditingController();
  final mailVerifyCodeController = TextEditingController();
  final smsVerifyCodeController = TextEditingController();

  bool _isLoadingTwoFactor = false;
  bool get isLoadingTwoFactor => _isLoadingTwoFactor;

  bool _isLoadingMail = false;
  bool get isLoadingMail => _isLoadingMail;

  bool _isLoadingSms = false;
  bool get isLoadingSms => _isLoadingSms;

  twoFactorVerifySubmit(dynamic code) async {
    _isLoadingTwoFactor = true;
    update();
    ApiResponse apiResponse =
        await verifyRequiredRepo.twoFactorSubmitRepo(code);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoadingTwoFactor = false;
      update();
      if (apiResponse.response!.data != null) {
        dynamic status = apiResponse.response!.data['status'];
        dynamic msg = apiResponse.response!.data['message'];
        // if(status=="success"){
        //   Get.back();
        // }
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
        if (status == "success") {
          Get.offAllNamed(BottomNavBar.routeName);
        }
        update();
      }
    } else {
      _isLoadingTwoFactor = false;
      update();
    }
  }

  mailVerifySubmit(dynamic code) async {
    _isLoadingMail = true;
    update();
    ApiResponse apiResponse =
        await verifyRequiredRepo.mailVerifySubmitRepo(code);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoadingMail = false;
      update();
      if (apiResponse.response!.data != null) {
        dynamic status = apiResponse.response!.data['status'];
        dynamic msg = apiResponse.response!.data['message'];
        // if(status=="success"){
        //   Get.back();
        // }
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
        if (status == "success") {
          Get.offAllNamed(BottomNavBar.routeName);
        }
        update();
      }
    } else {
      _isLoadingMail = false;
      update();
    }
  }

  smsVerifySubmit(dynamic code) async {
    _isLoadingSms = true;
    update();
    ApiResponse apiResponse =
        await verifyRequiredRepo.smsVerifySubmitRepo(code);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoadingSms = false;
      update();
      if (apiResponse.response!.data != null) {
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
        if (status == "success") {
          Get.offAllNamed(BottomNavBar.routeName);
        }
        update();
      }
    } else {
      _isLoadingSms = false;
      update();
    }
  }
}

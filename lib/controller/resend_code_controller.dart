import 'package:flutter/material.dart';
import 'package:flutter_hypro/data/repository/resend_code_repo.dart';
import 'package:get/get.dart';

import '../data/model/base_model/api_response.dart';

class ResendCodeController extends GetxController {
  final ResendCodeRepo resendCodeRepo;

  ResendCodeController({required this.resendCodeRepo});

  dynamic _status;
  dynamic get status => _status;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<dynamic> getResendCode(dynamic type) async {
    _isLoading = true;
    update();
    ApiResponse apiResponse = await resendCodeRepo.getResendCode(type);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        dynamic status = apiResponse.response!.data['status'];
        dynamic msg = apiResponse.response!.data['message'];
        if (status == "success") {
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
        } else {
          Get.snackbar(
            'Message',
            'Something went wrong.please try again!',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(10),
            borderRadius: 8,
            shouldIconPulse: true,
            barBlur: 10,
          );
        }
        update();
      }
    } else {
      _isLoading = false;
      update();
    }
  }
}

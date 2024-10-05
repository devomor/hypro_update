import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/data/repository/auth_repo.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/view/screens/auth/new_password.dart';
import 'package:flutter_hypro/view/screens/bottomnavbar/bottom_navbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../data/datasource/remote/dio/dio_client.dart';
import '../data/model/base_model/api_response.dart';
import '../view/screens/auth/code.dart';

class AuthController extends GetxController {
  DioClient dioClient;
  final AuthRepo authRepo;
  AuthController({required this.authRepo, required this.dioClient});

  bool isLoadingLogin = false;

  bool isLoadingRegister = false;

  bool isLoadingForgetPassword = false;

  bool isLoadingCode = false;

  bool isLoadingSubmit = false;

  Rx<String> selectedCountryName = ''.obs;
  Rx<String> selectedCountryNameCode = ''.obs;

  var rememberMe = false.obs;

  Rx<CountryCode> selectedCountryCode = CountryCode().obs;

  var isLoginPasswordVisible = false.obs;
  var isRegisterPasswordVisible = false.obs;
  var isRegisterConfirmPasswordVisible = false.obs;

  void toggleLoginPasswordVisibility() {
    isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
    update();
  }

  void toggleRegisterPasswordVisibility() {
    isRegisterPasswordVisible.value = !isRegisterPasswordVisible.value;
    update();
  }

  void toggleRegisterConfirmPasswordVisibility() {
    isRegisterConfirmPasswordVisible.value =
        !isRegisterConfirmPasswordVisible.value;
    update();
  }

  @override
  void onInit() {
    // Set initial country code if needed
    selectedCountryCode.value = CountryCode.fromCountryCode('US');
    super.onInit();
  }

  final firstNameTxt = TextEditingController();
  final lastNameTxt = TextEditingController();
  final userNameTxt = TextEditingController();
  final emailAddressTxt = TextEditingController();
  final phoneTxt = TextEditingController();
  final passwordTxt = TextEditingController();
  final confirmPasswordTxt = TextEditingController();
  final sponsorTxt = TextEditingController();

  final loginUserNameTxt = TextEditingController();
  final loginPasswordTxt = TextEditingController();

  final forgetPasswordTxt = TextEditingController();

  var firstNameValid = ''.obs;
  var lastNameValid = ''.obs;
  var userNameValid = ''.obs;
  var emailValid = ''.obs;
  var phoneValid = ''.obs;
  var passwordValid = ''.obs;

  Future<dynamic> register(
    BuildContext context,
    dynamic firstName,
    dynamic lastName,
    dynamic userName,
    dynamic emailAddress,
    dynamic countryCode,
    dynamic phoneCode,
    dynamic phone,
    dynamic password,
    dynamic confirmPassword,
    dynamic sponsor,
  ) async {
    isLoadingRegister = true;
    update();
    ApiResponse apiResponse = await authRepo.register(
        context,
        firstName,
        lastName,
        userName,
        emailAddress,
        countryCode,
        phoneCode,
        phone,
        password,
        confirmPassword,
        sponsor);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      isLoadingRegister = false;
      Map map = apiResponse.response!.data;

      dynamic token;
      dynamic msg;
      dynamic status;

      update();

      try {
        token = map["token"];
        msg = map["message"];
        status = map["status"];

        update();
        if (kDebugMode) {
          print(token);
        }
        final backgroundColor = status != "success" ? Colors.red : Colors.green;

        final snackBar = SnackBar(
          content: Text(
            msg,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 10,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        if (token.isNotEmpty) {
          Get.offNamedUntil(BottomNavBar.routeName, (route) => false);
          authRepo.saveUserToken(token);
          // await authRepo.updateToken();
        }
      } catch (e) {
        if (kDebugMode) {
          print("e");
        }
      }
      if (token.isNotEmpty) {
        authRepo.saveUserToken(token);
        // await authRepo.updateToken();
      }
      // callback(true, token, temporaryToken, message);
      update();
    } else {
      isLoadingRegister = false;
      update();
    }
    return apiResponse.response!.statusCode;
  }

  Future<dynamic> login(
      BuildContext context, dynamic userName, dynamic password) async {
    isLoadingLogin = true;
    update();
    ApiResponse apiResponse = await authRepo.login(context, userName, password);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      isLoadingLogin = false;
      Map map = apiResponse.response!.data;

      dynamic token;
      dynamic msg;
      dynamic status;

      try {
        token = map["token"];
        msg = map["message"];
        status = map["status"];

        if (status != "failed") {
          if (kDebugMode) {
            print(token);
          }
          final backgroundColor =
              status != "success" ? Colors.red : Colors.green.shade200;

          final snackBar = SnackBar(
            content: Text(
              msg,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
            backgroundColor: backgroundColor,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 10,
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          if (token.isNotEmpty) {
            authRepo.saveUserToken(token);
            Get.offNamedUntil(BottomNavBar.routeName, (route) => false);
            // await authRepo.updateToken();
          }
        } else {
          final backgroundColor =
              status != "success" ? Colors.red : Colors.green.shade200;
          final snackBar = SnackBar(
            content: Text(
              msg,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
            backgroundColor: backgroundColor,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 10,
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        if (kDebugMode) {
          print("e");
        }
      }

      update();
    } else {
      isLoadingLogin = false;
      update();
    }
    return apiResponse.response!.statusCode;
  }

  dynamic emailForgetPassword;

  late Timer timer;
  Rx<int> remainingTime = 300.obs; // 5 minutes (5 * 60 seconds)
  bool isTimerRunning = false;

  void startTimer() {
    if (isTimerRunning) {
      return; // If the timer is already running, don't start a new one
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime.value--;
      } else {
        // Timer has reached zero, you can perform any action here if needed
        timer.cancel(); // Cancel the timer
        isTimerRunning = false; // Set the timer running flag to false
      }
      update();
    });
  }

  // Function to reset the timer
  void resetTimer() {
    update();
    if (kDebugMode) {
      print("Time reset");
    }
    remainingTime.value = 300; // Reset the remaining time to its initial value
    isTimerRunning = false; // Set the timer running flag to false
  }

  Future<dynamic> forgetPasswordRequest(
    BuildContext context,
    dynamic email,
  ) async {
    isLoadingForgetPassword = true;
    update();
    ApiResponse apiResponse =
        await authRepo.forgetPasswordRequest(context, email);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      isLoadingForgetPassword = false;
      update();
      if (apiResponse.response!.data != null) {
        dynamic status = apiResponse.response!.data['status'];
        dynamic msg = status == 'success'
            ? apiResponse.response!.data['message']['message']
            : apiResponse.response!.data['message'];

        emailForgetPassword = status == 'success'
            ? apiResponse.response!.data['message']['email']
            : "";

        if (status == 'success') {
          Get.back();
          Get.bottomSheet(
            Container(
              color: AppColors.getBackgroundDarkLight(),
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  child: EnterCode()),
            ),
          );
          Get.snackbar(
            'Message',
            '$msg',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(10),
            borderRadius: 8,
            barBlur: 10,
          );
          // startTimer();
        } else {
          Get.snackbar(
            'Message',
            '$msg',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(10),
            borderRadius: 8,
            shouldIconPulse: true,
            icon: const Icon(Icons.cancel, color: Colors.white),
            barBlur: 10,
          );
        }
        update();
      }
    } else {
      isLoadingForgetPassword = false;
      update();
    }
  }

  Future<dynamic> recoveryPassCodeRequest(
    BuildContext context,
    dynamic email,
    dynamic code,
  ) async {
    isLoadingCode = true;
    update();
    ApiResponse apiResponse =
        await authRepo.recoveryPassCodeRequest(context, email, code);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      isLoadingCode = false;
      update();
      if (apiResponse.response!.data != null) {
        dynamic status = apiResponse.response!.data['status'];
        dynamic msg = apiResponse.response!.data['message'];

        if (status == 'success') {
          Get.back();
          Get.bottomSheet(
            Container(
              color: AppColors.getBackgroundDarkLight(),
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
                child: NewPassword(),
              ),
            ),
          );
        } else {
          Get.snackbar(
            'Message',
            '$msg',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(10),
            borderRadius: 8,
            shouldIconPulse: true,
            icon: const Icon(Icons.cancel, color: Colors.white),
            barBlur: 10,
          );
        }
        update();
      }
    } else {
      isLoadingCode = false;
      update();
    }
  }

  Future<dynamic> forgetPassSubmitRequest(
    BuildContext context,
    dynamic pass,
    dynamic passConfirm,
    dynamic email,
  ) async {
    isLoadingSubmit = true;
    update();
    ApiResponse apiResponse = await authRepo.forgetPasswordSubmitRequest(
        context, pass, passConfirm, email);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      isLoadingSubmit = false;
      update();
      if (apiResponse.response!.data != null) {
        dynamic status = apiResponse.response!.data['status'];
        dynamic msg = apiResponse.response!.data['message'];
        print(apiResponse.response!.data);

        if (status == 'success') {
          Get.back();
          Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.sp,
          );
        } else {
          Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp,
          );
        }
        update();
      }
    } else {
      isLoadingSubmit = false;
      update();
    }
  }

  // for user Section
  dynamic getUserToken() {
    update();
    print(authRepo.getUserToken());
    return authRepo.getUserToken();
  }

  // remove user Section
  void removeUserToken() {
    update();
    print("remove");
    print(authRepo.removeUserToken());
    authRepo.removeUserToken();
  }

  //get auth token
  // for user Section
  String getAuthToken() {
    update();
    dioClient.updateHeader(authRepo.getAuthToken(), '');
    return authRepo.getAuthToken();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/model/response_model/invest_history_model.dart';
import 'package:flutter_hypro/data/repository/invest_history_repo.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:flutter_hypro/view/verify_required/mail_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/sms_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/two_factor_verification_screen.dart';
import 'package:get/get.dart';

class InvestHistoryController extends GetxController {
  final InvestHistoryRepo investHistoryRepo;

  InvestHistoryController({required this.investHistoryRepo});

  String? _status;
  Message? _message;
  bool _isLoading = false;

  String? get status => _status;
  Message? get message => _message;
  bool get isLoading => _isLoading;

  Rx<int> page = 1.obs;

  final scrollController = ScrollController();

  // ignore: unused_field
  double _currentScrollOffset = 0;

  List<Data> historyItems = []; // List to store all fetched items

  void resetPage() {
    page.value = 1;
    _message = null;
    historyItems.clear();
    update();
  }

  void pageCounter() {
    page.value++;
    update();
  }

  InvestHistoryModel investHistoryModel = InvestHistoryModel();

  Future<void> getInvestHistoryData(dynamic page) async {
    if (isLoading) return; // Prevent concurrent loading
    _isLoading = true;
    if (page == 1) {
      historyItems = [];
    }
    update();
    try {
      ApiResponse apiResponse =
          await investHistoryRepo.getInvestHistoryData(page);

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
            investHistoryModel =
                InvestHistoryModel.fromJson(apiResponse.response!.data!);
            _message = investHistoryModel.message;

            if (_message != null && _message!.data != null) {
              historyItems.addAll(_message!.data!);
              update();
            }
          }
        }
      } else {
        _isLoading = false;
        update();
      }
    } catch (error) {
      _isLoading = false;
      update();
      // Handle the error here, e.g., show a dialog or log the error.
      print('Error in getInvestHistoryData: $error');
    }
  }

  @override
  void onInit() {
    super.onInit();

    resetPage();
    getInvestHistoryData(page.value.toString());
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final data = message?.data;
    final isLoading = this.isLoading;

    if (!isLoading &&
        data!.length >= 10 &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      _currentScrollOffset =
          scrollController.position.pixels; // Save the current scroll offset
      pageCounter();
      final page = this.page.value;
      getInvestHistoryData(page.toString());
      print("scrolling");
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/model/response_model/payout_history_search_model.dart';
import 'package:flutter_hypro/data/repository/payout_history_repo.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:flutter_hypro/view/verify_required/mail_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/sms_verification_screen.dart';
import 'package:get/get.dart';

import '../view/verify_required/two_factor_verification_screen.dart';

class PayoutHistoryController extends GetxController {
  final PayoutHistoryRepo payoutHistoryRepo;

  PayoutHistoryController({required this.payoutHistoryRepo});

  var isWidgetVisible = false.obs;
  final name = TextEditingController();

  var selectedOption = 'All Payment'.obs;

  onDropdownChanged(String value) {
    selectedOption.value = value;
  }

  var selectedDate = ''.obs;

  void setDate(String date) {
    selectedDate.value = date;
    update();
  }

  void toggleWidgetVisibility() {
    isWidgetVisible.value = !isWidgetVisible.value;
    update();
  }

  Rx<int> page = 1.obs;

  final scrollController = ScrollController();

  // ignore: unused_field
  double _currentScrollOffset = 0;

  List<Data> payoutHistorySearchItems = []; // List to store all fetched items

  void resetPage() {
    page.value = 1;
    _message = null;
    payoutHistorySearchItems.clear();
    update();
  }

  void pageCounter() {
    page.value++;
    update();
  }

  String? _status;
  PayoutHistorySearchData? _message;
  bool _isLoading = false;

  String? get status => _status;
  PayoutHistorySearchData? get message => _message;
  bool get isLoading => _isLoading;

  PayoutHistorySearchModel payoutHistorySearchModel =
      PayoutHistorySearchModel();

  Future<dynamic> getPayoutHistorySearchData(
      dynamic name, dynamic createdAt, dynamic status,
      {dynamic page}) async {
    _isLoading = true;
    if (page == 1) {
      payoutHistorySearchItems = [];
    }
    update();
    ApiResponse apiResponse = await payoutHistoryRepo
        .searchRequestPayoutHistory(name, createdAt, status, page: page);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        _message = null;
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
            payoutHistorySearchModel =
                PayoutHistorySearchModel.fromJson(apiResponse.response!.data!);
            _message = payoutHistorySearchModel.message;

            if (_message != null) {
              payoutHistorySearchItems.addAll(_message!.data!);
              update();
            }

            update();
          }
        }
      }
    } else {
      _isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();

    resetPage();
    getPayoutHistorySearchData("", "", "", page: page.value.toString());
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
      final page = this.page;
      getPayoutHistorySearchData("", "", "", page: page.value.toString());
      print("scrolling");
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

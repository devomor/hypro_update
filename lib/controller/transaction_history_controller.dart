import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/model/response_model/transaction_history_search_model.dart';
import 'package:flutter_hypro/data/repository/transaction_history_repo.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:flutter_hypro/view/verify_required/mail_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/sms_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/two_factor_verification_screen.dart';
import 'package:get/get.dart';

class TransactionHistoryController extends GetxController {
  final TransactionHistoryRepo transactionHistoryRepo;

  TransactionHistoryController({required this.transactionHistoryRepo});

  var isWidgetVisible = false.obs;
  final transactionId = TextEditingController();
  final remark = TextEditingController();

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

  List<Data> transactionHistorySearchItems =
      []; // List to store all fetched items

  void resetPage() {
    page.value = 1;
    _message = null;
    transactionHistorySearchItems.clear();
    update();
  }

  void pageCounter() {
    page.value++;
    update();
  }

  String? _status;
  TransactionHistorySearchData? _message;
  bool _isLoading = false;

  String? get status => _status;
  TransactionHistorySearchData? get message => _message;
  bool get isLoading => _isLoading;

  TransactionHistorySearchModel transactionHistorySearchModel =
      TransactionHistorySearchModel();

  Future<dynamic> getTransactionHistorySearchData(
      dynamic transactionId, dynamic remark, dynamic createdAt,
      {dynamic page}) async {
    _isLoading = true;
    if (page == 1) {
      transactionHistorySearchItems = [];
    }
    update();
    ApiResponse apiResponse = await transactionHistoryRepo
        .searchRequestTransactionHistory(transactionId, remark, createdAt,
            page: page);

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
          transactionHistorySearchModel =
              TransactionHistorySearchModel.fromJson(
                  apiResponse.response!.data!);
          _message = transactionHistorySearchModel.message;

          if (_message != null) {
            transactionHistorySearchItems.addAll(_message!.data!);
            update();
          }

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
    super.onInit();

    resetPage();
    getTransactionHistorySearchData("", "", "", page: page.value.toString());
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
      getTransactionHistorySearchData("", "", "", page: page.value.toString());
      print("scrolling");
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    transactionId.dispose();
    remark.dispose();
    super.onClose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/model/response_model/referral_bonus_search_model.dart';
import 'package:flutter_hypro/data/repository/referral_bonus_repo.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:flutter_hypro/view/verify_required/mail_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/sms_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/two_factor_verification_screen.dart';
import 'package:get/get.dart';

class ReferralBonusController extends GetxController {
  final ReferralBonusRepo referralBonusSearchRepo;

  ReferralBonusController({required this.referralBonusSearchRepo});

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

  var isWidgetVisible = false.obs;
  var isBodyVisible = true.obs;
  var isBodySearchDataVisible = false.obs;

  void toggleWidgetVisibility() {
    isWidgetVisible.value = !isWidgetVisible.value;
    update();
  }

  void toggleBodyVisibility() {
    isBodyVisible.value = false;
    isBodySearchDataVisible.value = true;
    update();
  }

  Rx<int> page = 1.obs;

  final scrollController = ScrollController();

  // ignore: unused_field
  double _currentScrollOffset = 0;

  List<Data> referralBonusItems = []; // List to store all fetched items

  void resetPage() {
    page.value = 1;
    _message = null;
    referralBonusItems.clear();
    update();
  }

  void pageCounter() {
    page.value++;
    update();
  }

  dynamic _status;
  dynamic get status => _status;
  ReferralBonusSearchData? _message;
  ReferralBonusSearchData? get message => _message;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ReferralBonusSearchModel referralBonusSearchModel =
      ReferralBonusSearchModel();

  Future<dynamic> getReferralBonusSearchData(
      dynamic searchUser, dynamic createdAt,
      {dynamic page}) async {
    _isLoading = true;
    if (page == 1) {
      referralBonusItems = [];
    }
    update();
    ApiResponse apiResponse = await referralBonusSearchRepo
        .getReferralBonusSearchData(searchUser, createdAt, page: page);

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
          referralBonusSearchModel =
              ReferralBonusSearchModel.fromJson(apiResponse.response!.data!);
          _message = referralBonusSearchModel.message;

          if (_message != null) {
            referralBonusItems.addAll(_message!.data!);
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
    getReferralBonusSearchData("", "", page: page.value.toString());
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
      getReferralBonusSearchData("", "", page: page.value.toString());
      print("scrolling");
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

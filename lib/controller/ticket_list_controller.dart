import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/model/response_model/ticket_list_model.dart';
import 'package:flutter_hypro/data/repository/ticket_list_repo.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:flutter_hypro/view/verify_required/mail_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/sms_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/two_factor_verification_screen.dart';
import 'package:get/get.dart';

class TicketListController extends GetxController {
  final TicketListRepo ticketListRepo;

  TicketListController({required this.ticketListRepo});

  dynamic _status;
  TicketListData? _message;
  TicketListData? get message => _message;
  dynamic get status => _status;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Rx<int> page = 1.obs;

  dynamic scrollController = ScrollController();

  // ignore: unused_field
  double _currentScrollOffset = 0;

  List<Data> ticketListItems = []; // List to store all fetched items

  void resetPage() {
    page.value = 1;
    _message = null;
    ticketListItems.clear();
    update();
  }

  void pageCounter() {
    page.value++;
    update();
  }

  TicketListModel ticketListModel = TicketListModel();

  /// Get Ticket Data
  Future<dynamic> getTicketListData(
    dynamic page,
  ) async {
    _isLoading = true;
    if (page == 1) {
      ticketListItems = [];
    }
    update();
    ApiResponse apiResponse = await ticketListRepo.getTicketListData(page);

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
          ticketListModel =
              TicketListModel.fromJson(apiResponse.response!.data!);
          _message = ticketListModel.message;

          if (_message != null) {
            ticketListItems.addAll(_message!.data!);
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
    getTicketListData(page.value.toString());
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
      getTicketListData(page.value.toString());
      print("scrolling");
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

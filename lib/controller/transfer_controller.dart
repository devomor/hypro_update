import 'package:flutter/material.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/repository/transfer_repo.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class TransferScreenController extends GetxController {
  dynamic emailCtrl = TextEditingController();
  dynamic amountCtrl = TextEditingController();
  dynamic passwordCtrl = TextEditingController();

  final TransferRepo transferRepo;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TransferScreenController({required this.transferRepo});

  var selectedOption = 'Main Balance'.obs;

  onDropdownChanged(String value) {
    selectedOption.value = value;
  }

  Future<dynamic> sendBalanceTransferRequest(dynamic email, dynamic amount,
      dynamic walletType, dynamic password, BuildContext context) async {
    _isLoading = true;
    update();
    ApiResponse apiResponse = await transferRepo.sendBalanceTransferRequest(
        email, amount, walletType, password);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        dynamic status = apiResponse.response!.data['status'];
        dynamic msg = apiResponse.response!.data['message'];
        if (status == "success") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                content: Container(
                  height: 260.h,
                  width: 260.w,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Lottie.asset("assets/images/success.json"),
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                          "Transfer Successful",
                          style: GoogleFonts.publicSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.getTextDarkLight(),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.appDashBoardTransactionGreen,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Center(
                                    child: Text(
                                      "Ok",
                                      style: GoogleFonts.publicSans(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.appWhiteColor,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
          emailCtrl.text = "";
          amountCtrl.text = "";
          passwordCtrl.text = "";
          update();
        } else {
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
        }

        update();
      }
    } else {
      _isLoading = false;
      update();
    }
  }

  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    update();
  }
}

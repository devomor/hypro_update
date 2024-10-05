import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/deposit_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class DepositPreviewScreen extends StatefulWidget {
  static const String routeName = "/depositPreviewScreen";
  dynamic gateway;
  dynamic amount;
  dynamic planId;
  dynamic charge;
  dynamic percentageCharge;
  dynamic conversionRate;
  dynamic currency;
  dynamic currencySymbol;
  dynamic conventionRate;
  DepositPreviewScreen(
      {super.key,
      this.gateway,
      this.amount,
      this.conversionRate,
      this.charge,
      this.currency,
      this.currencySymbol,
      this.conventionRate,
      this.percentageCharge,
      this.planId});

  @override
  State<DepositPreviewScreen> createState() => _DepositPreviewScreenState();
}

class _DepositPreviewScreenState extends State<DepositPreviewScreen> {
  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DepositController>(builder: (depositController) {
      return SelectionArea(
        child: Scaffold(
          backgroundColor: AppColors.getBackgroundDarkLight(),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColors.getAppBarBgDarkLight(),
            titleSpacing: 0,
            elevation: 0,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: 25.h,
                color: AppColors.getTextDarkLight(),
              ),
            ),
            automaticallyImplyLeading: false,
            title: Text(
              "${selectedLanguageStorage.read("languageData")["Deposit Preview"] ?? "Deposit Preview"}",
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.getTextDarkLight()),
            ),
          ),
          body: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.getBackgroundDarkLight(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Please Follow The Instruction Below",
                              style: GoogleFonts.publicSans(
                                  color:
                                      AppColors.appDashBoardTransactionPending),
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Center(
                              child: Text(
                                "You have requested to deposit ${Get.find<DepositController>().amountController.text} USD , Please pay ${double.parse(widget.amount).toStringAsFixed(2)} for successful payment",
                                style: GoogleFonts.publicSans(
                                    color: AppColors.getTextDarkLight(),
                                    fontSize: 15.sp),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    GetBuilder<DepositController>(
                      builder: (depositController) {
                        if (depositController.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (depositController.message != null) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                if (depositController.message != null)
                                  if (depositController.message!.gateways !=
                                      null)
                                    if (depositController
                                        .message!.gateways!.isNotEmpty)
                                      HtmlWidget(depositController
                                          .manualPaymentNote
                                          .toString()),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: depositController
                                      .formFields, // Use the list of form fields here
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(child: Text("No data available"));
                        }
                      },
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (kDebugMode) {
                            print(widget.gateway);
                            print(widget.amount);
                            print(widget.planId);
                          }
                          depositController.manualPaymentRequest(
                              widget.gateway,
                              Get.find<DepositController>()
                                  .amountController
                                  .text,
                              widget.planId,
                              depositController.fieldNames,
                              depositController.fieldValuesList,
                              context);
                        },
                        child: Container(
                          height: 50.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppColors.appPrimaryColor,
                              borderRadius: BorderRadius.circular(32)),
                          child: Center(
                              child:
                                  depositController.isLoadingManualPay == false
                                      ? Text(
                                          "Pay Now",
                                          style: TextStyle(
                                              color: AppColors.appWhiteColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500),
                                        )
                                      : const CircularProgressIndicator(
                                          color: AppColors.appWhiteColor,
                                        )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

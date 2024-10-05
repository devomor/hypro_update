import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/invest_history_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class InvestHistoryScreen extends StatelessWidget {
  static const String routeName = "/investHistoryScreen";
  InvestHistoryScreen({super.key});

  String formatApiDate(String apiDate) {
    // Parse the API response date
    DateTime dateTime = DateTime.parse(apiDate);

    // Format it as 'dd MMM, yyyy h.mm a'
    String formattedDate = DateFormat('dd MMM, yyyy h.mm a').format(dateTime);

    return formattedDate;
  }

  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Get.find<InvestHistoryController>().getInvestHistoryData(1);
      },
      child: Scaffold(
        backgroundColor: AppColors.getBackgroundDarkLight(),
        appBar: AppBar(
          backgroundColor: AppColors.getAppBarBgDarkLight(),
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    "assets/images/arrow_back_btn.png",
                    height: 20.h,
                    width: 20.w,
                    color: AppColors.getTextDarkLight(),
                  )),
              SizedBox(
                width: 90.w,
              ),
              Center(
                child: Text(
                  "${selectedLanguageStorage.read("languageData")["Invest History"] ?? "Invest History"}",
                  style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      color: AppColors.getTextDarkLight()),
                ),
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: GetBuilder<InvestHistoryController>(
            builder: (investHistoryController) {
              final historyItems = investHistoryController.historyItems;

              if (investHistoryController.isLoading == true &&
                  historyItems.isEmpty) {
                return Center(
                    child: CircularProgressIndicator(
                  color: AppColors.appPrimaryColor,
                ));
              } else if (historyItems.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Get.isDarkMode
                            ? Image.asset(
                                "assets/images/dark_no_data_found.png",
                                height: 250.h,
                                width: 250.w,
                              )
                            : Image.asset(
                                "assets/images/no_data_found.png",
                                height: 250.h,
                                width: 250.w,
                              ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 32),
                          child: Text(
                            "${selectedLanguageStorage.read("languageData")["No data found."] ?? "No data found."}",
                            style: GoogleFonts.publicSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.sp,
                              color: AppColors.appBlackColor50,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller:
                      Get.find<InvestHistoryController>().scrollController,
                  shrinkWrap: true,
                  itemCount: investHistoryController.historyItems.length +
                      (investHistoryController.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < investHistoryController.historyItems.length) {
                      final item = investHistoryController.historyItems[index];
                      return Padding(
                        padding: EdgeInsets.only(
                            left: 24.w, right: 24.w, bottom: 16),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: AppColors.getAppBarBgDarkLight(),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 16.h),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${selectedLanguageStorage.read("languageData")["Investment Plan"] ?? "Investment Plan"}",
                                          style: GoogleFonts.niramit(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Get.isDarkMode
                                                  ? AppColors.appWhiteColor
                                                  : AppColors.appBlackColor50),
                                        ),
                                        Text(
                                          "${item.planName}",
                                          style: GoogleFonts.niramit(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Get.isDarkMode
                                                  ? AppColors.appWhiteColor
                                                  : AppColors.appBlackColor60),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${selectedLanguageStorage.read("languageData")["Amount"] ?? "Amount"}",
                                          style: GoogleFonts.niramit(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Get.isDarkMode
                                                  ? AppColors.appWhiteColor
                                                  : AppColors.appBlackColor50),
                                        ),
                                        Text(
                                          "${item.amount} ${item.currency}",
                                          style: GoogleFonts.niramit(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Get.isDarkMode
                                                  ? AppColors.appWhiteColor
                                                  : AppColors.appBlackColor60),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${selectedLanguageStorage.read("languageData")["Return Interest"] ?? "Return Interest"}",
                                          style: GoogleFonts.niramit(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Get.isDarkMode
                                                  ? AppColors.appWhiteColor
                                                  : AppColors.appBlackColor50),
                                        ),
                                        Text(
                                          "${item.returnInvest}",
                                          style: GoogleFonts.niramit(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Get.isDarkMode
                                                  ? AppColors.appWhiteColor
                                                  : AppColors.appBlackColor60),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${selectedLanguageStorage.read("languageData")["Received Amount"] ?? "Received Amount"}",
                                          style: GoogleFonts.niramit(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Get.isDarkMode
                                                  ? AppColors.appWhiteColor
                                                  : AppColors.appBlackColor50),
                                        ),
                                        Text(
                                          "${item.receivedAmount}",
                                          style: GoogleFonts.niramit(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Get.isDarkMode
                                                  ? AppColors.appWhiteColor
                                                  : AppColors.appBlackColor60),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 24.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${selectedLanguageStorage.read("languageData")["Upcoming Payment"] ?? "Upcoming Payment"}",
                                          style: GoogleFonts.niramit(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Get.isDarkMode
                                                  ? AppColors.appWhiteColor
                                                  : AppColors.appBlackColor50),
                                        ),
                                        Text(
                                          item.nextPaymentDate != null &&
                                                  item.nextPaymentDate != "null"
                                              ? "${formatApiDate(item.nextPaymentDate.toString())}"
                                              : "",
                                          style: GoogleFonts.niramit(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.appPrimaryColor),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    LinearPercentIndicator(
                                      barRadius: Radius.circular(12),
                                      padding: EdgeInsets.zero,
                                      width: 350.w,
                                      lineHeight: 12.h,
                                      percent: item.percentPayment != null
                                          ? double.parse(item.percentPayment
                                                      .toString()
                                                      .replaceAll('%', ''))
                                                  .toDouble() /
                                              100
                                          : 0,
                                      progressColor: AppColors.appPrimaryColor,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      // Display loading indicator only if isLoading is true
                      if (investHistoryController.isLoading) {
                        return SizedBox.shrink();
                      } else {
                        // Return an empty container if isLoading is false (no more data)
                        return Container();
                      }
                    }
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

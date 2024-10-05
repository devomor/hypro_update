import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/transaction_history_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        String formattedDate = "${picked.year}-${picked.month}-${picked.day}";
        Get.find<TransactionHistoryController>().setDate(formattedDate);
      });
    }
  }

  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Get.find<TransactionHistoryController>()
            .getTransactionHistorySearchData("", "", "", page: 1);
      },
      child: Scaffold(
          backgroundColor: AppColors.getBackgroundDarkLight(),
          appBar: AppBar(
            backgroundColor: AppColors.getAppBarBgDarkLight(),
            automaticallyImplyLeading: false,
            titleSpacing: 24,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // InkWell(
                //     onTap: () {
                //       Navigator.pop(context);
                //     },
                //     child: Image.asset(
                //       "assets/images/arrow_back_btn.png",
                //       height: 20.h,
                //       width: 20.w,
                //     )),
                Text(
                  "${selectedLanguageStorage.read("languageData")["Transaction"] ?? "Transaction"}",
                  style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      color: AppColors.getTextDarkLight()),
                ),
                InkWell(
                  onTap: () {
                    showDialog<void>(
                        barrierDismissible: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Material(
                            // Wrap with Material
                            elevation: 0,
                            type: MaterialType.transparency,
                            child: Center(
                              child: GetBuilder<TransactionHistoryController>(
                                  builder: (transactionHistoryController) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: AppColors
                                              .getBackgroundDarkLight(),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        child: Column(
                                          children: [
                                            Align(
                                                alignment: Alignment.topRight,
                                                child: IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const Icon(
                                                      Icons.cancel,
                                                      color: AppColors
                                                          .appBlackColor50,
                                                    ))),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Column(
                                              children: [
                                                TextFormField(
                                                  controller: Get.find<
                                                          TransactionHistoryController>()
                                                      .transactionId,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.r,
                                                              vertical: 5.r),
                                                      filled: true,
                                                      fillColor: AppColors
                                                          .getTextFieldDarkLight(),
                                                      border: InputBorder.none,
                                                      hintText:
                                                          "${selectedLanguageStorage.read("languageData")["Search for Transaction ID"] ?? "Search for Transaction ID"}",
                                                      hintStyle: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .appBlackColor50,
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 16.h,
                                                ),
                                                TextFormField(
                                                  controller: Get.find<
                                                          TransactionHistoryController>()
                                                      .remark,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.r,
                                                              vertical: 5.r),
                                                      filled: true,
                                                      fillColor: AppColors
                                                          .getTextFieldDarkLight(),
                                                      border: InputBorder.none,
                                                      hintText:
                                                          "${selectedLanguageStorage.read("languageData")["Remark"] ?? "Remark"}",
                                                      hintStyle: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .appBlackColor50)),
                                                ),
                                                SizedBox(
                                                  height: 16.h,
                                                ),
                                                TextFormField(
                                                  readOnly: true,
                                                  onTap: () {
                                                    setState(() {});
                                                    _selectDate(context);
                                                  },
                                                  controller: TextEditingController(
                                                      text: Get.find<
                                                              TransactionHistoryController>()
                                                          .selectedDate
                                                          .value),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 12, top: 14),
                                                    filled: true,
                                                    fillColor: AppColors
                                                        .getTextFieldDarkLight(),
                                                    border: InputBorder.none,
                                                    suffixIcon: GestureDetector(
                                                        onTap: () {
                                                          transactionHistoryController
                                                              .setDate("");
                                                        },
                                                        child:
                                                            transactionHistoryController
                                                                    .selectedDate
                                                                    .isNotEmpty
                                                                ? Padding(
                                                                    padding: EdgeInsets
                                                                        .all(16.0
                                                                            .h),
                                                                    child: Text(
                                                                      "${selectedLanguageStorage.read("languageData")["Clear"] ?? "Clear"}",
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize:
                                                                            12.sp,
                                                                        color: AppColors
                                                                            .appBlackColor50,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const SizedBox
                                                                    .shrink()),
                                                    hintText:
                                                        "${selectedLanguageStorage.read("languageData")["Select Date"] ?? "Select Date"}",
                                                    hintStyle: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .appBlackColor50,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 25.h,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      Get.find<
                                                              TransactionHistoryController>()
                                                          .transactionHistorySearchItems
                                                          .clear();
                                                      Get.find<
                                                              TransactionHistoryController>()
                                                          .getTransactionHistorySearchData(
                                                        Get.find<
                                                                TransactionHistoryController>()
                                                            .transactionId
                                                            .text
                                                            .toString(),
                                                        Get.find<
                                                                TransactionHistoryController>()
                                                            .remark
                                                            .text
                                                            .toString(),
                                                        Get.find<
                                                                TransactionHistoryController>()
                                                            .selectedDate
                                                            .value
                                                            .toString(),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 45.h,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .appPrimaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16)),
                                                      child: Center(
                                                          child: Text(
                                                        "${selectedLanguageStorage.read("languageData")["Search"] ?? "Search"}",
                                                        style: GoogleFonts.niramit(
                                                            fontSize: 20.sp,
                                                            color: AppColors
                                                                .appWhiteColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )),
                                                    )),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          );
                        });
                  },
                  child: CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.appBg3,
                      child: Image.asset(
                        "assets/images/search_icon.png",
                        height: 18.h,
                        width: 18.w,
                      )),
                )
              ],
            ),
          ),
          body: ListView(
            controller:
                Get.find<TransactionHistoryController>().scrollController,
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 8.h,
              ),
              GetBuilder<TransactionHistoryController>(
                builder: (transactionHistoryController) {
                  final historyItems = transactionHistoryController
                      .transactionHistorySearchItems;

                  if (transactionHistoryController.isLoading == true &&
                      historyItems.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.appPrimaryColor,
                      ),
                    );
                  } else if (historyItems.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 180.h),
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
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: transactionHistoryController
                              .transactionHistorySearchItems.length +
                          (transactionHistoryController.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index <
                            transactionHistoryController
                                .transactionHistorySearchItems.length) {
                          final item = transactionHistoryController
                              .transactionHistorySearchItems[index];
                          return GestureDetector(
                            onTap: () {
                              showDialog<void>(
                                barrierDismissible: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return item.color == "danger"
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 60.h, horizontal: 40.w),
                                          child: Material(
                                            // Wrap with Material
                                            elevation: 0,
                                            type: MaterialType.transparency,
                                            child: Center(
                                              child: GetBuilder<
                                                      TransactionHistoryController>(
                                                  builder:
                                                      (transactionHistoryController) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .getBackgroundDarkLight(),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        child: Column(
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                Container(
                                                                    width: double
                                                                        .infinity,
                                                                    color: AppColors
                                                                        .appPrimaryColor,
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/images/payout_alert_header_bg.png",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )),
                                                                Positioned(
                                                                    top: 15.h,
                                                                    right: 15.w,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/cancel_icon.png",
                                                                        height:
                                                                            15.h,
                                                                        width:
                                                                            15.w,
                                                                      ),
                                                                    )),
                                                                Positioned(
                                                                    top: 30.h,
                                                                    left: 0,
                                                                    right: 0,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Center(
                                                                          child:
                                                                              Image.asset(
                                                                            "assets/images/payout_alert_icon.png",
                                                                            height:
                                                                                55.h,
                                                                            width:
                                                                                55.w,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              12.h,
                                                                        ),
                                                                        Text(
                                                                          "${item.remarks}",
                                                                          style: GoogleFonts.publicSans(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 18.sp,
                                                                              color: AppColors.appBlackColor),
                                                                        )
                                                                      ],
                                                                    ))
                                                              ],
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              color: AppColors
                                                                  .getAppBarBgDarkLight(),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "${selectedLanguageStorage.read("languageData")["Transaction ID"] ?? "Transaction ID"}",
                                                                      style: GoogleFonts.publicSans(
                                                                          fontSize: 16
                                                                              .sp,
                                                                          color: AppColors
                                                                              .appBlackColor50,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          5.h,
                                                                    ),
                                                                    SelectableText(
                                                                      "${item.transactionId}",
                                                                      style: GoogleFonts.niramit(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color: AppColors
                                                                              .getTextDarkLight(),
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          12.h,
                                                                    ),
                                                                    SelectableText(
                                                                      "${selectedLanguageStorage.read("languageData")["Amount"] ?? "Amount"}",
                                                                      style: GoogleFonts.niramit(
                                                                          fontSize: 16
                                                                              .sp,
                                                                          color: AppColors
                                                                              .appBlackColor50,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          5.h,
                                                                    ),
                                                                    SelectableText(
                                                                      "${item.amount}",
                                                                      style: GoogleFonts.niramit(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color: AppColors
                                                                              .getTextDarkLight(),
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          12.h,
                                                                    ),
                                                                    Text(
                                                                      "${selectedLanguageStorage.read("languageData")["Date & Time"] ?? "Date & Time"}",
                                                                      style: GoogleFonts.niramit(
                                                                          fontSize: 16
                                                                              .sp,
                                                                          color: AppColors
                                                                              .appBlackColor50,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          5.h,
                                                                    ),
                                                                    Text(
                                                                      "${item.time}",
                                                                      style: GoogleFonts.niramit(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color: AppColors
                                                                              .getTextDarkLight(),
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          12.h,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ))
                                                  ],
                                                );
                                              }),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 60.h, horizontal: 30.w),
                                          child: Material(
                                            // Wrap with Material
                                            elevation: 0,
                                            type: MaterialType.transparency,
                                            child: Center(
                                              child: GetBuilder<
                                                      TransactionHistoryController>(
                                                  builder:
                                                      (transactionHistoryController) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .appBlackColor50,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        child: Column(
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                Container(
                                                                    width: double
                                                                        .infinity,
                                                                    color: AppColors
                                                                        .appPrimaryColor,
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/images/deposit_alert_header_bg.png",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )),
                                                                Positioned(
                                                                    top: 15.h,
                                                                    right: 15.w,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/cancel_icon.png",
                                                                        height:
                                                                            15.h,
                                                                        width:
                                                                            15.w,
                                                                      ),
                                                                    )),
                                                                Positioned(
                                                                    top: 30.h,
                                                                    left: 0,
                                                                    right: 0,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Center(
                                                                          child:
                                                                              Image.asset(
                                                                            "assets/images/deposit_alert_icon.png",
                                                                            height:
                                                                                55.h,
                                                                            width:
                                                                                55.w,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              12.h,
                                                                        ),
                                                                        Text(
                                                                          "${item.remarks}",
                                                                          style: GoogleFonts.publicSans(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 18.sp,
                                                                              color: AppColors.appBlackColor),
                                                                        )
                                                                      ],
                                                                    ))
                                                              ],
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              color: AppColors
                                                                  .appWhiteColor,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "${selectedLanguageStorage.read("languageData")["Transaction ID"] ?? "Transaction ID"}",
                                                                      style: GoogleFonts.publicSans(
                                                                          fontSize: 16
                                                                              .sp,
                                                                          color: AppColors
                                                                              .appBlackColor50,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          5.h,
                                                                    ),
                                                                    SelectableText(
                                                                      "${item.transactionId}",
                                                                      style: GoogleFonts.niramit(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color: AppColors
                                                                              .appBlackColor,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          12.h,
                                                                    ),
                                                                    SelectableText(
                                                                      "${selectedLanguageStorage.read("languageData")["Amount"] ?? "Amount"}",
                                                                      style: GoogleFonts.niramit(
                                                                          fontSize: 16
                                                                              .sp,
                                                                          color: AppColors
                                                                              .appBlackColor50,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          5.h,
                                                                    ),
                                                                    SelectableText(
                                                                      "${item.amount}",
                                                                      style: GoogleFonts.niramit(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color: AppColors
                                                                              .appBlackColor,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          12.h,
                                                                    ),
                                                                    Text(
                                                                      "${selectedLanguageStorage.read("languageData")["Date & Time"] ?? "Date & Time"}",
                                                                      style: GoogleFonts.niramit(
                                                                          fontSize: 16
                                                                              .sp,
                                                                          color: AppColors
                                                                              .appBlackColor50,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          5.h,
                                                                    ),
                                                                    Text(
                                                                      "${item.time}",
                                                                      style: GoogleFonts.niramit(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color: AppColors
                                                                              .appBlackColor,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          12.h,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ))
                                                  ],
                                                );
                                              }),
                                            ),
                                          ),
                                        );
                                },
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 24.w, right: 24.w, bottom: 12.h),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.getTextFieldDarkLight(),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.w, right: 24.w),
                                  child: Row(
                                    children: [
                                      item.color == "danger"
                                          ? Container(
                                              height: 40.h,
                                              width: 40.w,
                                              decoration: BoxDecoration(
                                                  color: AppColors
                                                      .appDashBoardTransactionRed,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Image.asset(
                                                  "assets/images/transaction_up.png",
                                                  height: 16.h,
                                                  width: 16.w,
                                                ),
                                              ),
                                            )
                                          : Container(
                                              height: 40.h,
                                              width: 40.w,
                                              decoration: BoxDecoration(
                                                  color: AppColors
                                                      .appDashBoardTransactionGreen,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Image.asset(
                                                  "assets/images/transaction_down.png",
                                                  height: 16.h,
                                                  width: 16.w,
                                                ),
                                              ),
                                            ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Expanded(
                                          flex: 10,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("${item.remarks}",
                                                    style: GoogleFonts.nunito(
                                                        color: AppColors
                                                            .getTextDarkLight(),
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(
                                                  height: 6.h,
                                                ),
                                                Text(
                                                  "${item.time}",
                                                  style: GoogleFonts.nunito(
                                                      color: AppColors
                                                          .appBlackColor50,
                                                      fontSize: 12.sp),
                                                ),
                                              ],
                                            ),
                                          )),
                                      Text("${item.amount} ${item.currency}",
                                          style: GoogleFonts.nunito(
                                              color: item.color == "danger"
                                                  ? AppColors
                                                      .appDashBoardTransactionRed
                                                  : AppColors
                                                      .appDashBoardTransactionGreen,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          // Display loading indicator only if isLoading is true
                          if (transactionHistoryController.isLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.appPrimaryColor,
                              ),
                            );
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
            ],
          )),
    );
  }
}

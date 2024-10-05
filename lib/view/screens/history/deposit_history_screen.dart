import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/deposit_history_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/view/screens/bottomnavbar/bottom_navbar.dart';
import 'package:flutter_hypro/view/widgets/app_custom_dropdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class DepositHistoryScreen extends StatefulWidget {
  static const String routeName = "/depositHistoryScreen";
  dynamic status;
  DepositHistoryScreen({super.key, this.status});

  @override
  State<DepositHistoryScreen> createState() => _DepositHistoryScreenState();
}

class _DepositHistoryScreenState extends State<DepositHistoryScreen> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Format the selected date to "mm/dd/yyyy" format
      // String formattedDate = "${picked.month}/${picked.day}/${picked.year}";
      String formattedDate = "${picked.year}-${picked.month}-${picked.day}";
      Get.find<DepositHistoryController>().setDate(formattedDate);
    }
  }

  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    print(widget.status);
    final status = Get.parameters['status'];
    print("Check $status");
    print(status == "true");

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        if (widget.status == "true") {
          Get.offAllNamed(BottomNavBar.routeName);
        } else {
          Navigator.pop(context);
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          Get.find<DepositHistoryController>()
              .getDepositHistorySearchData("", "", "", page: 1);
        },
        child: Scaffold(
          backgroundColor: AppColors.getBackgroundDarkLight(),
          appBar: AppBar(
            backgroundColor: AppColors.getAppBarBgDarkLight(),
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      if (widget.status == "true") {
                        Get.offAllNamed(BottomNavBar.routeName);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset(
                      "assets/images/arrow_back_btn.png",
                      height: 20.h,
                      width: 20.w,
                      color: AppColors.getTextDarkLight(),
                    )),
                Text(
                  "${selectedLanguageStorage.read("languageData")["Deposit History"] ?? "Deposit History"}",
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
                              child: GetBuilder<DepositHistoryController>(
                                  builder: (depositHistoryController) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
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
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            TextFormField(
                                              controller: Get.find<
                                                      DepositHistoryController>()
                                                  .name,
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
                                                      "${selectedLanguageStorage.read("languageData")["Type here"] ?? "Type here"}",
                                                  hintStyle: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 16.h,
                                            ),
                                            Container(
                                              height: 50.h,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Obx(
                                                () => AppCustomDropDown(
                                                  items: const [
                                                    'All Payment',
                                                    'Complete Payment',
                                                    'Pending Payment',
                                                    'Cancel Payment'
                                                  ],
                                                  onChanged: (value) => Get.find<
                                                          DepositHistoryController>()
                                                      .onDropdownChanged(
                                                          value!),
                                                  selectedValue: Get.find<
                                                          DepositHistoryController>()
                                                      .selectedOption
                                                      .value,
                                                  hint:
                                                      "${selectedLanguageStorage.read("languageData")["Select an option"] ?? "Select an option"}",
                                                  hintStyle: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: AppColors
                                                          .appBlackColor50),
                                                  decoration: BoxDecoration(
                                                    // Customize the button decoration here
                                                    // Example: You can set the border radius or background color
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color: AppColors
                                                        .getTextFieldDarkLight(),
                                                  ),
                                                  dropdownDecoration:
                                                      BoxDecoration(
                                                    // Customize the dropdown decoration here
                                                    // Example: You can set the border or background color
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color: Get.isDarkMode
                                                        ? AppColors
                                                            .appDefaultDarkMode
                                                        : Colors.white,
                                                  ),
                                                  itemHeight:
                                                      40, // Set the height of each item in the dropdown
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16.h,
                                            ),
                                            TextFormField(
                                              readOnly: true,
                                              onTap: () => _selectDate(context),
                                              controller: TextEditingController(
                                                  text: Get.find<
                                                          DepositHistoryController>()
                                                      .selectedDate
                                                      .value),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    top: 16, left: 10),
                                                filled: true,
                                                fillColor: AppColors
                                                    .getTextFieldDarkLight(),
                                                border: InputBorder.none,
                                                hintText:
                                                    "${selectedLanguageStorage.read("languageData")["Select Date"] ?? "Select Date"}",
                                                suffixIcon: GestureDetector(
                                                    onTap: () {
                                                      depositHistoryController
                                                          .setDate("");
                                                    },
                                                    child:
                                                        depositHistoryController
                                                                .selectedDate
                                                                .isNotEmpty
                                                            ? Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(16.0
                                                                            .h),
                                                                child: Text(
                                                                  "${selectedLanguageStorage.read("languageData")["Clear"] ?? "Clear"}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: AppColors
                                                                        .appBlackColor50, // Set the color for the border when not focused
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox
                                                                .shrink()),
                                                hintStyle: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 24.h,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Get.find<
                                                          DepositHistoryController>()
                                                      .depositHistorySearchItems
                                                      .clear();
                                                  Get.find<
                                                          DepositHistoryController>()
                                                      .getDepositHistorySearchData(
                                                    Get.find<
                                                            DepositHistoryController>()
                                                        .name
                                                        .text
                                                        .toString(),
                                                    Get.find<
                                                            DepositHistoryController>()
                                                        .selectedDate
                                                        .value,
                                                    "${checkStatus(Get.find<DepositHistoryController>().selectedOption.value)}",
                                                  );
                                                },
                                                child: Container(
                                                  height: 45.h,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color: AppColors
                                                          .appPrimaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16)),
                                                  child: Center(
                                                      child: Text(
                                                    "${selectedLanguageStorage.read("languageData")["Search"] ?? "Search"}",
                                                    style: GoogleFonts.niramit(
                                                        fontSize: 20.sp,
                                                        color: AppColors
                                                            .appWhiteColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )),
                                                )),
                                            SizedBox(
                                              height: 20.h,
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
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            controller: Get.find<DepositHistoryController>().scrollController,
            children: [
              SizedBox(
                height: 8.h,
              ),
              GetBuilder<DepositHistoryController>(
                builder: (depositHistoryController) {
                  final historyItems =
                      depositHistoryController.depositHistorySearchItems;

                  if (depositHistoryController.isLoading == true &&
                      historyItems.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: CircularProgressIndicator(
                          color: AppColors.appPrimaryColor,
                        ),
                      ),
                    );
                  } else if (historyItems.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 180.h),
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
                      ),
                    );
                  } else {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: depositHistoryController
                              .depositHistorySearchItems.length +
                          (depositHistoryController.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index <
                            depositHistoryController
                                .depositHistorySearchItems.length) {
                          final item = depositHistoryController
                              .depositHistorySearchItems[index];
                          return GestureDetector(
                            onTap: () {
                              showDialog<void>(
                                barrierDismissible: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 60.h, horizontal: 30.w),
                                    child: Material(
                                      // Wrap with Material
                                      elevation: 0,
                                      type: MaterialType.transparency,
                                      child: Center(
                                        child: GetBuilder<
                                                DepositHistoryController>(
                                            builder:
                                                (depositHistoryController) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                      color: AppColors
                                                          .appBlackColor50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Container(
                                                              width: double
                                                                  .infinity,
                                                              color: AppColors
                                                                  .appPrimaryColor,
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/deposit_alert_header_bg.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              )),
                                                          Positioned(
                                                              top: 20.h,
                                                              right: 20.w,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Image.asset(
                                                                  "assets/images/cancel_icon.png",
                                                                  height: 15.h,
                                                                  width: 15.w,
                                                                ),
                                                              )),
                                                          Positioned(
                                                              top: 30.h,
                                                              left: 0,
                                                              right: 0,
                                                              child: Column(
                                                                children: [
                                                                  Center(
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/images/deposit_history.png",
                                                                      height:
                                                                          50.h,
                                                                      width:
                                                                          50.w,
                                                                      color: checkStatusColor(
                                                                          item.status),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        12.h,
                                                                  ),
                                                                  Text(
                                                                    "${item.gateway}",
                                                                    style: GoogleFonts.publicSans(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize: 18
                                                                            .sp,
                                                                        color: AppColors
                                                                            .appBlackColor),
                                                                  )
                                                                ],
                                                              ))
                                                        ],
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        color: AppColors
                                                            .getAppBarBgDarkLight(),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "${selectedLanguageStorage.read("languageData")["Transaction ID"] ?? "Transaction ID"}",
                                                                style: GoogleFonts.publicSans(
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: AppColors
                                                                        .appBlackColor50,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              SelectableText(
                                                                "${item.transactionId}",
                                                                style: GoogleFonts.niramit(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: AppColors
                                                                        .getTextDarkLight(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                height: 12.h,
                                                              ),
                                                              SelectableText(
                                                                "${selectedLanguageStorage.read("languageData")["Amount"] ?? "Amount"}",
                                                                style: GoogleFonts.niramit(
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: AppColors
                                                                        .appBlackColor50,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              SelectableText(
                                                                "${item.amount}",
                                                                style: GoogleFonts.niramit(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: AppColors
                                                                        .getTextDarkLight(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                height: 12.h,
                                                              ),
                                                              SelectableText(
                                                                "${selectedLanguageStorage.read("languageData")["Charge"] ?? "Charge"}",
                                                                style: GoogleFonts.niramit(
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: AppColors
                                                                        .appBlackColor50,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              SelectableText(
                                                                "${item.charge}",
                                                                style: GoogleFonts.niramit(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: AppColors
                                                                        .getTextDarkLight(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                height: 12.h,
                                                              ),
                                                              SelectableText(
                                                                "${selectedLanguageStorage.read("languageData")["Status"] ?? "Status"}",
                                                                style: GoogleFonts.niramit(
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: AppColors
                                                                        .appBlackColor50,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              SelectableText(
                                                                "${item.status}",
                                                                style: GoogleFonts.niramit(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: checkStatusColor(item
                                                                        .status),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                height: 12.h,
                                                              ),
                                                              Text(
                                                                "${selectedLanguageStorage.read("languageData")["Date & Time"] ?? "Date & Time"}",
                                                                style: GoogleFonts.niramit(
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: AppColors
                                                                        .appBlackColor50,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text(
                                                                "${item.time}",
                                                                style: GoogleFonts.niramit(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: AppColors
                                                                        .getTextDarkLight(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                height: 24.h,
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
                                  color: Get.isDarkMode
                                      ? AppColors.appContainerBgColor
                                      : AppColors.appFillColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 16.w,
                                      right: 24.w,
                                      top: 10,
                                      bottom: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 40.h,
                                        width: 40.w,
                                        decoration: BoxDecoration(
                                            color:
                                                checkStatusColor(item.status),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.asset(
                                            "${checkStatusIcon(item.status)}",
                                            height: 16.h,
                                            width: 16.w,
                                          ),
                                        ),
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
                                                Text(
                                                  "${item.gateway}",
                                                  style: GoogleFonts.publicSans(
                                                    fontSize: 16.sp,
                                                    color: AppColors
                                                        .getTextDarkLight(),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 6.h,
                                                ),
                                                Text(
                                                  "${item.time}",
                                                  style: GoogleFonts.publicSans(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14.sp,
                                                      color: AppColors
                                                          .appBlackColor50),
                                                ),
                                              ],
                                            ),
                                          )),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "+${item.amount}",
                                        style: GoogleFonts.publicSans(
                                            fontSize: 16.sp,
                                            color: AppColors
                                                .appDashBoardTransactionGreen,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          // Display loading indicator only if isLoading is true
                          if (depositHistoryController.isLoading) {
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
          ),
        ),
      ),
    );
  }

  checkStatusColor(dynamic status) {
    if (status == "Complete") {
      return AppColors.appDashBoardTransactionGreen;
    } else if (status == "Pending") {
      return AppColors.appDashBoardTransactionPending;
    } else {
      return AppColors.appDashBoardTransactionRed;
    }
  }

  checkStatusIcon(dynamic status) {
    if (status == "Complete") {
      return "assets/images/transaction_down.png";
    } else if (status == "Pending") {
      return "assets/images/pending_icon_history.png";
    } else {
      return "assets/images/reject.png";
    }
  }

  checkStatus(dynamic statusValue) {
    if (statusValue == "All Payment") {
      return "";
    } else if (statusValue == "Complete Payment") {
      return 1;
    } else if (statusValue == "Pending Payment") {
      return 2;
    } else if (statusValue == "Cancel Payment") {
      return 3;
    }
  }
}

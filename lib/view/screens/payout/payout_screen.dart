import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hypro/controller/payout_controller.dart';
import 'package:flutter_hypro/view/screens/payout/payout_preview_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/model/response_model/payout_model.dart';
import '../../../utils/colors/app_colors.dart';

class PayoutScreen extends StatefulWidget {
  static const String routeName = "/payoutScreen";
  PayoutScreen({super.key});

  @override
  State<PayoutScreen> createState() => _PayoutScreenState();
}

class _PayoutScreenState extends State<PayoutScreen> {
  int selectedTabIndex = -1;

  dynamic indexList;

  dynamic selectedOption;
  final amountController = TextEditingController();

  dynamic walletType = "balance";

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  dynamic payoutBy;
  dynamic minAmount;
  dynamic maxAmount;
  dynamic fixCharge;
  dynamic percentageCharge;
  dynamic currency;

  dynamic data;

  final selectedLanguageStorage = GetStorage();

  List<Gateway> filteredPayoutGatewaysList = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PayoutController>(builder: (payoutController) {
      return Scaffold(
        backgroundColor: AppColors.getBackgroundDarkLight(),
        appBar: AppBar(
          backgroundColor: AppColors.getAppBarBgDarkLight(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(19.0),
                child: Image.asset(
                  "assets/images/arrow_back_btn.png",
                  height: 20.h,
                  width: 20.w,
                  color: AppColors.getTextDarkLight(),
                ),
              )),
          title: Text(
            "${selectedLanguageStorage.read("languageData")["Payout"] ?? "Payout"}",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: AppColors.getTextDarkLight()),
          ),
        ),
        body: GetBuilder<PayoutController>(builder: (payoutController) {
          if (payoutController.isLoading == false &&
              payoutController.message != null) {
            List<String> items = [
              '${payoutController.message!.balance}',
              '${payoutController.message!.interestBalance}',
            ];
            // Define selectedOption here as a state variable
            String selectedOption = items[0];
            return ListView(
              children: [
                payoutController.isLoading == false &&
                        payoutController.message != null
                    ? Column(
                        children: [
                          SizedBox(
                            height: 30.h,
                          ),
                          Container(
                            height: 180.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Get.isDarkMode
                                    ? AppColors.appContainerBgColor
                                    : AppColors.appBrandColor3),
                            child: Padding(
                              padding: EdgeInsets.only(top: 24.h, left: 24.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 30.h,
                                    width: 350.w,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "${selectedLanguageStorage.read("languageData")["Select Payment Method"] ?? "Select Payment Method"}",
                                            style: GoogleFonts.niramit(
                                                fontSize: 18.sp,
                                                color: AppColors
                                                    .getTextDarkLight(),
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              // Filter the gateways based on the search value
                                              List<Gateway> filteredGateways =
                                                  payoutController
                                                      .message!.gateways!
                                                      .where((gateway) => gateway
                                                          .name!
                                                          .toLowerCase()
                                                          .contains(value
                                                              .toLowerCase()))
                                                      .toList();

                                              // Update the state with the filtered gateways
                                              setState(() {
                                                filteredPayoutGatewaysList =
                                                    filteredGateways;
                                                selectedTabIndex = -1;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                hintText:
                                                    "${selectedLanguageStorage.read("languageData")["Search here"] ?? "Search here"}",
                                                hintStyle: GoogleFonts.niramit(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .appBlackColor30)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 32.h,
                                  ),

// Payment method
                                  SizedBox(
                                    height: 57.h,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: filteredPayoutGatewaysList
                                              .isNotEmpty
                                          ? filteredPayoutGatewaysList.length
                                          : payoutController
                                              .message!.gateways!.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        // Use the filtered gateways if available, otherwise use all gateways
                                        var gateway = filteredPayoutGatewaysList
                                                .isNotEmpty
                                            ? filteredPayoutGatewaysList[index]
                                            : payoutController
                                                .message!.gateways![index];

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedTabIndex = index;

                                              payoutBy = gateway.name;
                                              data = gateway;
                                              minAmount = gateway.minimumAmount;
                                              maxAmount = gateway.maximumAmount;
                                              fixCharge = gateway.fixedCharge;
                                              percentageCharge =
                                                  gateway.percentCharge;
                                              currency = gateway.currency;
                                              indexList = index;
                                            });
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 32.w),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height: 57.h,
                                                  width: 85.w,
                                                  decoration: BoxDecoration(
                                                    color: index !=
                                                            selectedTabIndex
                                                        ? AppColors
                                                            .appWhiteColor
                                                        : AppColors
                                                            .appBrandColor2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: Image.network(
                                                      "${gateway.image}",
                                                      height: 14.h,
                                                      width: 85.w,
                                                    ),
                                                  ),
                                                ),
                                                if (index == selectedTabIndex)
                                                  Positioned(
                                                    bottom: 0.h,
                                                    right: 0.w,
                                                    child: CircleAvatar(
                                                      radius: 10,
                                                      backgroundColor: AppColors
                                                          .appPrimaryColor,
                                                      child: Icon(
                                                        Icons.check,
                                                        color: AppColors
                                                            .appWhiteColor,
                                                        size: 16.sp,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                payoutBy != null
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 28),
                                        child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          color: AppColors.appBlackColor30,
                                          radius: Radius.circular(12),
                                          padding: EdgeInsets.all(6),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: AppColors
                                                    .getBackgroundDarkLight(),
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 24.w,
                                                  vertical: 20.h),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${selectedLanguageStorage.read("languageData")["Payout by"] ?? "Payout by"}",
                                                        style: GoogleFonts.niramit(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .appWhiteColor
                                                                : AppColors
                                                                    .appBlackColor50),
                                                      ),
                                                      Text(
                                                        "${payoutBy}",
                                                        style: GoogleFonts.niramit(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .appWhiteColor
                                                                : AppColors
                                                                    .appBlackColor50),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 12.h,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${selectedLanguageStorage.read("languageData")["Transaction Limit"] ?? "Transaction Limit"}",
                                                        style: GoogleFonts.niramit(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .appWhiteColor
                                                                : AppColors
                                                                    .appBlackColor50),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "${double.parse(minAmount).toStringAsFixed(2)} - ${double.parse(maxAmount).toStringAsFixed(2)} ${currency}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts.niramit(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? AppColors
                                                                      .appWhiteColor
                                                                  : AppColors
                                                                      .appBlackColor50),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 12.h,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${selectedLanguageStorage.read("languageData")["Charge"] ?? "Charge"}",
                                                        style: GoogleFonts.niramit(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .appWhiteColor
                                                                : AppColors
                                                                    .appBlackColor50),
                                                      ),
                                                      Text(
                                                        "${fixCharge} + ${percentageCharge}%",
                                                        style: GoogleFonts.niramit(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .appWhiteColor
                                                                : AppColors
                                                                    .appBlackColor50),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                SizedBox(
                                  height: 32.h,
                                ),
                                Form(
                                  key: formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${selectedLanguageStorage.read("languageData")["Select Wallet"] ?? "Select Wallet"}",
                                        style: GoogleFonts.niramit(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18.sp,
                                            color:
                                                AppColors.getTextDarkLight()),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Container(
                                        height: 52.h,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Get.isDarkMode
                                              ? AppColors.appContainerBgColor
                                              : AppColors.appFillColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: StatefulBuilder(
                                          builder: (context, setState) {
                                            return DropdownButton2<String>(
                                              items: [
                                                DropdownMenuItem(
                                                  value:
                                                      '${payoutController.message!.balance}',
                                                  child: Text(
                                                    '${payoutController.message!.balance}',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                DropdownMenuItem(
                                                  value:
                                                      '${payoutController.message!.interestBalance}',
                                                  child: Text(
                                                    '${payoutController.message!.interestBalance}',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedOption = value!;
                                                  int selectedIndex = items
                                                      .indexOf(selectedOption);

                                                  if (selectedIndex == 0) {
                                                    walletType = "balance";
                                                  }
                                                  if (selectedIndex == 1) {
                                                    walletType =
                                                        "interest_balance";
                                                  }
                                                  if (kDebugMode) {
                                                    print(walletType);
                                                  }
                                                });
                                              },
                                              value: selectedOption,
                                              hint: Text(
                                                'Select an option',
                                                style:
                                                    TextStyle(fontSize: 14.sp),
                                              ),
                                              isExpanded: true,
                                              underline: Container(),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 24.h,
                                      ),
                                      Text(
                                        "${selectedLanguageStorage.read("languageData")["Amount"] ?? "Amount"}",
                                        style: GoogleFonts.niramit(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18.sp,
                                            color:
                                                AppColors.getTextDarkLight()),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Amount is required';
                                          }
                                          return null;
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d+\.?\d{0,5}')),
                                        ],
                                        controller: amountController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: 12, top: 10, bottom: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(
                                                  8.0), // Set the border radius here
                                              borderSide: BorderSide
                                                  .none, // Remove the default border
                                            ),
                                            fillColor: Get.isDarkMode
                                                ? AppColors.appContainerBgColor
                                                : AppColors.appFillColor,
                                            filled: true,
                                            hintText:
                                                "${selectedLanguageStorage.read("languageData")["Enter Amount"] ?? "Enter Amount"}",
                                            hintStyle: GoogleFonts.niramit(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16.sp,
                                                color:
                                                    AppColors.appBlackColor30)),
                                      ),
                                      SizedBox(
                                        height: 48.h,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            if (selectedTabIndex == -1) {
                                              print("please select index");
                                              final backgroundColor =
                                                  Colors.red;
                                              final snackBar = SnackBar(
                                                content: Text(
                                                  "Please select a gateway first",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.sp),
                                                ),
                                                backgroundColor:
                                                    backgroundColor,
                                                duration:
                                                    const Duration(seconds: 2),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                margin: const EdgeInsets.all(5),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                elevation: 10,
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .removeCurrentSnackBar();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            } else {
                                              if (double.parse(
                                                      amountController.text) <=
                                                  double.parse(minAmount)) {
                                                final backgroundColor =
                                                    Colors.red;
                                                final snackBar = SnackBar(
                                                  content: Text(
                                                    "Minimum amount is $minAmount",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp),
                                                  ),
                                                  backgroundColor:
                                                      backgroundColor,
                                                  duration: const Duration(
                                                      seconds: 2),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  elevation: 10,
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .removeCurrentSnackBar();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } else if (double.parse(
                                                      amountController.text) >
                                                  double.parse(maxAmount)) {
                                                final backgroundColor =
                                                    Colors.red;
                                                final snackBar = SnackBar(
                                                  content: Text(
                                                    "Maximum amount is $maxAmount",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp),
                                                  ),
                                                  backgroundColor:
                                                      backgroundColor,
                                                  duration: const Duration(
                                                      seconds: 2),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  elevation: 10,
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .removeCurrentSnackBar();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } else if (double.parse(
                                                          amountController
                                                              .text) >
                                                      payoutController.message!
                                                          .depositAmount &&
                                                  walletType == "balance") {
                                                final backgroundColor =
                                                    Colors.red;
                                                final snackBar = SnackBar(
                                                  content: Text(
                                                    "You do not have sufficient funds to process the withdrawal",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp),
                                                  ),
                                                  backgroundColor:
                                                      backgroundColor,
                                                  duration: const Duration(
                                                      seconds: 2),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  elevation: 10,
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .removeCurrentSnackBar();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } else if (double.parse(
                                                          amountController
                                                              .text) >
                                                      payoutController.message!
                                                          .interestAmount &&
                                                  walletType != "balance") {
                                                final backgroundColor =
                                                    Colors.red;
                                                final snackBar = SnackBar(
                                                  content: Text(
                                                    "You do not have sufficient funds to process the withdrawal",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp),
                                                  ),
                                                  backgroundColor:
                                                      backgroundColor,
                                                  duration: const Duration(
                                                      seconds: 2),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  elevation: 10,
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .removeCurrentSnackBar();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PayoutPreviewScreen(
                                                      data: data,
                                                      amount: amountController
                                                          .text
                                                          .toString(),
                                                      selectedType: walletType,
                                                      depositAmount:
                                                          payoutController
                                                              .message!
                                                              .depositAmount,
                                                      interestAmount:
                                                          payoutController
                                                              .message!
                                                              .interestAmount,
                                                      currencySymbol: currency,
                                                      percentageCharge:
                                                          percentageCharge,
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: 52.h,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              color: AppColors.appPrimaryColor),
                                          child: Center(
                                            child: Text(
                                              "${selectedLanguageStorage.read("languageData")["Next"] ?? "Next"}",
                                              style: GoogleFonts.niramit(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20.sp,
                                                  color:
                                                      AppColors.appWhiteColor),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          color: AppColors.appPrimaryColor,
                        ),
                      )
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }),
      );
    });
  }
}

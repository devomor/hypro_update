import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hypro/controller/deposit_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/view/screens/deposit/manual_payment_screen.dart';
import 'package:flutter_hypro/view/screens/deposit/paynow_webview.dart';
import 'package:flutter_hypro/view/screens/deposit/securion_authorizepay_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/model/response_model/payment_method_model.dart';

dynamic selectedOption;

// ignore: must_be_immutable
class DepositScreen extends StatefulWidget {
  dynamic amount;
  dynamic planID;
  static const String routeName = "/depositScreen";
  DepositScreen({super.key, this.amount, this.planID});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  int selectedTabIndex = -1;

  final _formKey = GlobalKey<FormState>();

  final selectedLanguageStorage = GetStorage();

  dynamic fixedCharge;
  dynamic percentageCharge;
  dynamic paymentMethod;
  dynamic total;
  dynamic amount;
  dynamic currency;

  dynamic charge;
  dynamic totalPayable;

  dynamic minAmount;
  dynamic maxAmount;
  dynamic conversionRate;

  dynamic checkCrypto;

  dynamic selectedOptionCode;

  List<Gateway> filteredGatewaysList = [];

  bool _isLoading = false;

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
    // Simulate loading for 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    widget.amount != null
        ? Get.find<DepositController>().amountController.text = widget.amount
        : "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DepositController>(builder: (depositController) {
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
                  color: AppColors.getTextDarkLight(),
                  height: 20.h,
                  width: 20.w,
                ),
              )),
          title: Text(
            "${selectedLanguageStorage.read("languageData")["Deposit"] ?? "Deposit"}",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: AppColors.getTextDarkLight()),
          ),
        ),
        body: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
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
                      child: depositController.isLoading == false
                          ? Column(
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
                                              color:
                                                  AppColors.getTextDarkLight(),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          onChanged: (value) {
                                            // Filter the gateways based on the search value
                                            List<Gateway> filteredGateways =
                                                depositController
                                                    .message!.gateways!
                                                    .where((gateway) => gateway
                                                        .name!
                                                        .toLowerCase()
                                                        .contains(value
                                                            .toLowerCase()))
                                                    .toList();

                                            // Update the state with the filtered gateways
                                            setState(() {
                                              filteredGatewaysList =
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
                                if (depositController.message != null)
                                  SizedBox(
                                    height: 57.h,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: filteredGatewaysList.isNotEmpty
                                          ? filteredGatewaysList.length
                                          : depositController
                                              .message!.gateways!.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        // Use the filtered gateways if available, otherwise use all gateways
                                        var gateway =
                                            filteredGatewaysList.isNotEmpty
                                                ? filteredGatewaysList[index]
                                                : depositController
                                                    .message!.gateways![index];

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedTabIndex = index;

                                              setState(() {
                                                selectedOption = gateway;
                                                selectedOptionCode =
                                                    gateway.code;
                                                fixedCharge =
                                                    gateway.fixedCharge;
                                                percentageCharge =
                                                    gateway.percentageCharge;
                                                paymentMethod = gateway.name;
                                                currency = gateway.currency;
                                                minAmount = gateway.minAmount;
                                                maxAmount = gateway.maxAmount;
                                                conversionRate =
                                                    gateway.conventionRate;
                                                checkCrypto =
                                                    gateway.currencies != null
                                                        ? gateway
                                                            .currencies["1"]
                                                        : null;
                                                print(
                                                    "Check Crypto>>> ${checkCrypto}");
                                              });
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
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                color: AppColors.appPrimaryColor,
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "${selectedLanguageStorage.read("languageData")["Amount"] ?? "Amount"}",
                          style: GoogleFonts.niramit(
                              fontWeight: FontWeight.w400,
                              fontSize: 18.sp,
                              color: AppColors.getTextDarkLight()),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Amount is required';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,5}')),
                          ],
                          keyboardType: TextInputType.number,
                          controller: depositController.amountController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 12, top: 10, bottom: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Set the border radius here
                                borderSide: BorderSide
                                    .none, // Remove the default border
                              ),
                              fillColor: AppColors.getTextFieldDarkLight(),
                              filled: true,
                              hintText:
                                  "${selectedLanguageStorage.read("languageData")["Enter Amount"] ?? "Enter Amount"}",
                              hintStyle: GoogleFonts.niramit(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: AppColors.appBlackColor30)),
                        ),
                        fixedCharge != null &&
                                depositController.amountController.text
                                    .toString()
                                    .isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${selectedLanguageStorage.read("languageData")["Preview Details:"] ?? "Preview Details:"}",
                                      style: GoogleFonts.niramit(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18.sp,
                                          color: AppColors.getTextDarkLight()),
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    DottedBorder(
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
                                              horizontal: 24.w, vertical: 20.h),
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
                                                    "${selectedLanguageStorage.read("languageData")["Payment Method"] ?? "Payment Method"}",
                                                    style: GoogleFonts.niramit(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .appBlackColor50),
                                                  ),
                                                  Text(
                                                    "${paymentMethod}",
                                                    style: GoogleFonts.niramit(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
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
                                                    "${selectedLanguageStorage.read("languageData")["Amount"] ?? "Amount"}",
                                                    style: GoogleFonts.niramit(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .appBlackColor50),
                                                  ),
                                                  Text(
                                                    "${depositController.message!.baseSymbol}${depositController.amountController.text}",
                                                    style: GoogleFonts.niramit(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .appBlackColor50,
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
                                                        color: AppColors
                                                            .appBlackColor50),
                                                  ),
                                                  Text(
                                                    "${depositController.message!.baseSymbol}${(double.parse(fixedCharge) + (double.parse(depositController.amountController.text) * double.parse(percentageCharge) / 100))}",
                                                    style: GoogleFonts.niramit(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
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
                                                    "${selectedLanguageStorage.read("languageData")["Total Payable"] ?? "Total Payable"}",
                                                    style: GoogleFonts.niramit(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .appBlackColor50),
                                                  ),
                                                  Text(
                                                    "${depositController.message!.baseSymbol}${double.parse(depositController.amountController.text) + (double.parse(fixedCharge) + (double.parse(depositController.amountController.text) * double.parse(percentageCharge) / 100))}",
                                                    style: GoogleFonts.niramit(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .appBlackColor50),
                                                  ),
                                                ],
                                              ),

                                              checkCrypto == null
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "${selectedLanguageStorage.read("languageData")["Conversion Rate:"] ?? "Conversion Rate:"}",
                                                                style: GoogleFonts.niramit(
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: AppColors
                                                                        .appBlackColor50),
                                                              ),
                                                              Text(
                                                                "1 ${depositController.message!.baseCurrency} = ${double.parse(conversionRate)} ${currency}",
                                                                style: GoogleFonts.niramit(
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: AppColors
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
                                                                "${selectedLanguageStorage.read("languageData")["In ${currency}"] ?? "In ${currency}"}",
                                                                style: GoogleFonts.niramit(
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: AppColors
                                                                        .appBlackColor50),
                                                              ),
                                                              Text(
                                                                "${(double.parse(conversionRate) * (double.parse(depositController.amountController.text) + (double.parse(fixedCharge) + (double.parse(depositController.amountController.text) * double.parse(percentageCharge) / 100))))}",
                                                                style:
                                                                    GoogleFonts
                                                                        .niramit(
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: AppColors
                                                                      .appBlackColor50,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12),
                                                      child: Container(
                                                        child: Text(
                                                            "Conversion with $currency and final value will Show on next step",
                                                            style: GoogleFonts.niramit(
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .appBlackColor50)),
                                                      ),
                                                    ),

                                              // checkCrypto!=null?
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //     top: 12
                                              //   ),
                                              //   child: Text(
                                              //     "Conversion withBTC and final value will Show on next step",
                                              //     textAlign: TextAlign.center,
                                              //     style: GoogleFonts.niramit(
                                              //         fontSize: 16.sp,
                                              //         fontWeight:
                                              //         FontWeight.w400,
                                              //         color: AppColors.appBlackColor50),
                                              //   ),
                                              // ):
                                              // SizedBox.shrink(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          height: 48.h,
                        ),
                        InkWell(
                          onTap: _isLoading == true
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    if (selectedTabIndex == -1) {
                                      print("please select a index");
                                      final backgroundColor = Colors.red;
                                      final snackBar = SnackBar(
                                        content: Text(
                                          "Please select a gateway first",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp),
                                        ),
                                        backgroundColor: backgroundColor,
                                        duration: const Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
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
                                      if (double.parse(depositController
                                              .amountController.text) <
                                          double.parse(minAmount)) {
                                        final backgroundColor = Colors.red;
                                        final snackBar = SnackBar(
                                          content: Text(
                                            "Minimum amount is $minAmount",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp),
                                          ),
                                          backgroundColor: backgroundColor,
                                          duration: const Duration(seconds: 2),
                                          behavior: SnackBarBehavior.floating,
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
                                      } else if (double.parse(depositController
                                              .amountController.text) >
                                          double.parse(maxAmount)) {
                                        final backgroundColor = Colors.red;
                                        final snackBar = SnackBar(
                                          content: Text(
                                            "Maximum amount is $maxAmount",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp),
                                          ),
                                          backgroundColor: backgroundColor,
                                          duration: const Duration(seconds: 2),
                                          behavior: SnackBarBehavior.floating,
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
                                        ///Stripe
                                        if (selectedOptionCode == "stripe") {
                                          if (kDebugMode) {
                                            print("Stripe");
                                          }
                                          _startLoading();
                                          depositController
                                              .stripeDepositRequest(
                                                  widget.planID, context);
                                        }

                                        ///RazorPay
                                        else if (selectedOptionCode ==
                                            "razorpay") {
                                          if (kDebugMode) {
                                            print("razorpay");
                                          }
                                          depositController
                                              .razorPayPaymentRequest();
                                        }

                                        ///FlutterWave
                                        else if (selectedOptionCode ==
                                            "flutterwave") {
                                          if (kDebugMode) {
                                            print("flutterWave");
                                          }
                                          depositController
                                              .flutterWavePaymentRequest(
                                                  context, widget.planID);
                                        }

                                        ///Paypal
                                        else if (selectedOptionCode ==
                                            "paypal") {
                                          if (kDebugMode) {
                                            print("Paypal");
                                          }
                                          depositController
                                              .payPalPaymentRequest(
                                                  widget.planID, context);
                                        }

                                        ///PayStack
                                        else if (selectedOptionCode ==
                                            "paystack") {
                                          if (kDebugMode) {
                                            print("paystack");
                                          }
                                          depositController
                                              .payStackPaymentRequest(
                                                  context, widget.planID);
                                        }

                                        ///Paytm
                                        else if (selectedOptionCode ==
                                            "paytm") {
                                          if (kDebugMode) {
                                            print("paytm");
                                          }
                                          depositController.paytmPaymentRequest(
                                              widget.planID, context);
                                        }

                                        ///Monnify
                                        else if (selectedOptionCode ==
                                            "monnify") {
                                          if (kDebugMode) {
                                            print("monnify");
                                          }
                                          depositController
                                              .monnifyPaymentRequest(
                                                  widget.planID, context);
                                        }

                                        ///Authorize net
                                        else if (selectedOptionCode ==
                                            "authorizenet") {
                                          if (kDebugMode) {
                                            print("authorizenet");
                                          }
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SecurioPayAuthorizenetPayScreen(
                                                        gatewayName:
                                                            "authorizenet",
                                                      )));
                                        }

                                        ///SecurionPay
                                        else if (selectedOptionCode ==
                                            "securionpay") {
                                          if (kDebugMode) {
                                            print("securionpay");
                                          }
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SecurioPayAuthorizenetPayScreen(
                                                        gatewayName:
                                                            "securionpay",
                                                      )));
                                        }

                                        ///Bank Transfer
                                        else if (selectedOption.id >= 1000) {
                                          if (kDebugMode) {
                                            print("Check>>>${widget.planID}");
                                          }
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DepositPreviewScreen(
                                                        gateway:
                                                            selectedOption.id,
                                                        amount: ((double.parse(depositController
                                                                        .amountController
                                                                        .text) *
                                                                    double.parse(
                                                                        conversionRate)) +
                                                                ((double.parse(
                                                                            fixedCharge) +
                                                                        (double.parse(depositController.amountController.text.toString()) *
                                                                            double.parse(
                                                                                percentageCharge) /
                                                                            100)) *
                                                                    double.parse(
                                                                        conversionRate)))
                                                            .toStringAsFixed(8),
                                                        planId: widget.planID,
                                                        conversionRate:
                                                            selectedOption
                                                                .conventionRate,
                                                        charge: selectedOption
                                                            .fixedCharge,
                                                        percentageCharge:
                                                            selectedOption
                                                                .percentageCharge,
                                                        currency: selectedOption
                                                            .currency,
                                                        currencySymbol:
                                                            selectedOption
                                                                .symbol,
                                                        conventionRate:
                                                            selectedOption
                                                                .conventionRate,
                                                      )));
                                        } else {
                                          depositController
                                              .sendOtherPaymentRequest(
                                                  ((double.parse(depositController
                                                                  .amountController
                                                                  .text) *
                                                              double.parse(
                                                                  conversionRate)) +
                                                          ((double.parse(
                                                                      fixedCharge) +
                                                                  (double.parse(depositController
                                                                          .amountController
                                                                          .text
                                                                          .toString()) *
                                                                      double.parse(
                                                                          percentageCharge) /
                                                                      100)) *
                                                              double.parse(
                                                                  conversionRate)))
                                                      .toStringAsFixed(8),
                                                  selectedOption.id)
                                              .then((value) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CheckoutWebView(
                                                        url: depositController
                                                            .url),
                                              ),
                                            );
                                          });
                                        }
                                      }
                                    }
                                  }
                                },
                          child: _isLoading == false
                              ? Container(
                                  height: 52.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      color: AppColors.appPrimaryColor),
                                  child: Center(
                                    child: Text(
                                      "Pay Now",
                                      style: GoogleFonts.niramit(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20.sp,
                                          color: AppColors.appWhiteColor),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

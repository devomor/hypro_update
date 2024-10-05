import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/payout_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/view/widgets/app_custom_button.dart';
import 'package:flutter_hypro/view/widgets/app_custom_dropdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/model/response_model/payout_bank_form_model.dart';

// ignore: must_be_immutable
class PayoutPreviewScreen extends StatefulWidget {
  static const String routeName = "/payout_preview_screen";
  dynamic data;
  dynamic amount;
  dynamic selectedType;
  dynamic depositAmount;
  dynamic interestAmount;
  dynamic currencySymbol;
  dynamic percentageCharge;
  PayoutPreviewScreen(
      {super.key,
      this.data,
      this.amount,
      this.selectedType,
      this.depositAmount,
      this.interestAmount,
      this.currencySymbol,
      this.percentageCharge});

  @override
  State<PayoutPreviewScreen> createState() => _PayoutPreviewScreenState();
}

class _PayoutPreviewScreenState extends State<PayoutPreviewScreen> {
  // Define lists to store field names and values
  List<String> fieldNames = [];
  List<String> fieldValues = [];

  dynamic selectedBankCode;
  double charge = 0.0;
  double totalPayable = 0.0;
  double availableBalance = 0.0;

  @override
  Widget build(BuildContext context) {
    // Perform your calculations here
    charge = double.parse(widget.data.fixedCharge) +
        (double.parse(widget.amount) *
            double.parse(widget.percentageCharge) /
            100);
    totalPayable = double.parse(widget.amount) +
        double.parse(widget.data.fixedCharge) +
        (double.parse(widget.amount) *
            double.parse(widget.percentageCharge) /
            100);

    if (widget.selectedType == "balance") {
      availableBalance = widget.depositAmount - totalPayable;
    } else {
      availableBalance = widget.interestAmount - totalPayable;
    }

    if (kDebugMode) {
      print(charge);
      print(totalPayable);
      print(availableBalance);
    }

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
            "Payout Preview",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: AppColors.getTextDarkLight()),
          ),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Payment Details
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.getBackgroundDarkLight(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DottedBorder(
                          borderType: BorderType.RRect,
                          color: AppColors.appBlackColor30,
                          radius: Radius.circular(12),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColors.getBackgroundDarkLight(),
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.w, vertical: 20.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Payout by",
                                        style: GoogleFonts.niramit(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Get.isDarkMode
                                                ? AppColors.appWhiteColor
                                                : AppColors.appBlackColor50),
                                      ),
                                      Text(
                                        "${widget.data.name}",
                                        style: GoogleFonts.niramit(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Get.isDarkMode
                                                ? AppColors.appWhiteColor
                                                : AppColors.appBlackColor50),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Requested Amount",
                                        style: GoogleFonts.niramit(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Get.isDarkMode
                                                ? AppColors.appWhiteColor
                                                : AppColors.appBlackColor50),
                                      ),
                                      Text(
                                        "${widget.amount} ${widget.currencySymbol}",
                                        style: GoogleFonts.niramit(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Get.isDarkMode
                                                ? AppColors.appWhiteColor
                                                : AppColors.appBlackColor50),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Charge",
                                        style: GoogleFonts.niramit(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Get.isDarkMode
                                                ? AppColors.appWhiteColor
                                                : AppColors.appBlackColor50),
                                      ),
                                      Text(
                                        "${charge}",
                                        style: GoogleFonts.niramit(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Get.isDarkMode
                                                ? AppColors.appWhiteColor
                                                : AppColors.appBlackColor50),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Payable",
                                        style: GoogleFonts.niramit(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Get.isDarkMode
                                                ? AppColors.appWhiteColor
                                                : AppColors.appBlackColor50),
                                      ),
                                      Text(
                                        "${totalPayable.toStringAsFixed(2)} ${widget.currencySymbol}",
                                        style: GoogleFonts.niramit(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Get.isDarkMode
                                                ? AppColors.appWhiteColor
                                                : AppColors.appBlackColor50),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  /// Bank Account Payout Logic
                  if ("${widget.data.name}" == "Wire Transfer")
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * .65,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.getBackgroundDarkLight(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GetBuilder<PayoutController>(
                            builder: (controller) {
                              if (controller.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (controller.message != null) {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      controller.message!.gateways!.length,
                                  itemBuilder: (context, index) {
                                    final gateway =
                                        controller.message!.gateways![index];
                                    final gatewayFormFields = controller
                                        .gatewayFormFields[gateway.name];
                                    final supportedCurrencies =
                                        controller.gatewaySupportedCurrencies[
                                            gateway.name];

                                    // Check if the gateway name is "Wire Transfer"
                                    if (gateway.name == "Wire Transfer") {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8),
                                          if (supportedCurrencies != null)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              height: 45.h,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: DropdownButton<String>(
                                                underline: const SizedBox(),
                                                isExpanded: true,
                                                items: supportedCurrencies,
                                                hint: Text(
                                                  "Select a currency",
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                onChanged: (value) {
                                                  // Handle dropdown value change
                                                  setState(() {
                                                    controller
                                                            .selectedCurrency =
                                                        value;
                                                    controller
                                                            .selectedCurrencyController
                                                            .text =
                                                        value!; // Update the controller's value
                                                  });
                                                  if (kDebugMode) {
                                                    print(controller
                                                        .selectedCurrencyController
                                                        .text);
                                                  }
                                                },
                                                value:
                                                    controller.selectedCurrency,
                                              ),
                                            ),
                                          const SizedBox(height: 8),
                                          if (gatewayFormFields != null)
                                            Column(
                                              children: gatewayFormFields,
                                            ),
                                          SizedBox(height: 30.h),
                                          Center(
                                            child: payoutController
                                                        .isLoadingPayoutRequest ==
                                                    false
                                                ? AppCustomButton(
                                                    width: double.infinity,
                                                    height: 50.h,
                                                    borderRadius: 32.00,
                                                    titleColor: Colors.white,
                                                    title: "Confirm Now",
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                    onTap: () async {
                                                      payoutController
                                                          .payoutRequest(
                                                              context,
                                                              widget
                                                                  .selectedType,
                                                              widget.data.id,
                                                              totalPayable,
                                                              payoutController
                                                                  .fieldNames,
                                                              payoutController
                                                                  .fieldValues);
                                                    },
                                                  )
                                                : CircularProgressIndicator(
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                  ),
                                          )
                                        ],
                                      );
                                    } else {
                                      // Return an empty container for other gateways
                                      return Container();
                                    }
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text('No data available.'),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                  if ("${widget.data.name}" != "Wire Transfer" &&
                      "${widget.data.name}" != "Flutterwave" &&
                      "${widget.data.name}" != "Razorpay" &&
                      "${widget.data.name}" != "Paystack" &&
                      "${widget.data.name}" != "Coinbase" &&
                      "${widget.data.name}" != "Perfect Money" &&
                      "${widget.data.name}" != "Paypal" &&
                      "${widget.data.name}" != "Binance")
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: Container(
                        height: 500,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.getBackgroundDarkLight(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GetBuilder<PayoutController>(
                            builder: (controller) {
                              if (controller.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (controller.message != null) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      controller.message!.gateways!.length,
                                  itemBuilder: (context, index) {
                                    final gateway =
                                        controller.message!.gateways![index];
                                    final gatewayFormFields = controller
                                        .gatewayFormFields[gateway.name];
                                    final supportedCurrencies =
                                        controller.gatewaySupportedCurrencies[
                                            gateway.name];

                                    // Check if the gateway name is "Wire Transfer"
                                    if (gateway.name == widget.data.name)
                                    // if (gateway.name == "Bank Transfer" ||
                                    //     "${widget.data.name}" == "USDT" ||
                                    //     "${widget.data.name}" == "Semua Bank")
                                    {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8),
                                          if (supportedCurrencies != null)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              height: 45.h,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: DropdownButton<String>(
                                                underline: const SizedBox(),
                                                isExpanded: true,
                                                items: supportedCurrencies,
                                                hint: Text(
                                                  "Select a currency",
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                onChanged: (value) {
                                                  // Handle dropdown value change
                                                  setState(() {
                                                    controller
                                                            .selectedCurrency =
                                                        value;
                                                    controller
                                                            .selectedCurrencyController
                                                            .text =
                                                        value!; // Update the controller's value
                                                  });
                                                  if (kDebugMode) {
                                                    print(controller
                                                        .selectedCurrencyController
                                                        .text);
                                                  }
                                                },
                                                value:
                                                    controller.selectedCurrency,
                                              ),
                                            ),
                                          const SizedBox(height: 8),
                                          if (gatewayFormFields != null)
                                            GetBuilder<PayoutController>(
                                                builder: (payoutController) {
                                              return Column(
                                                children: gatewayFormFields,
                                              );
                                            }),
                                          SizedBox(height: 30.h),
                                          Center(
                                            child: payoutController
                                                        .isLoadingPayoutRequest ==
                                                    false
                                                ? AppCustomButton(
                                                    width: double.infinity,
                                                    height: 50.h,
                                                    borderRadius: 32.00,
                                                    titleColor: Colors.white,
                                                    title: "Confirm Now",
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                    onTap: () {
                                                      payoutController
                                                          .payoutRequest(
                                                        context,
                                                        widget.selectedType,
                                                        widget.data.id,
                                                        totalPayable,
                                                        payoutController
                                                            .fieldNames,
                                                        payoutController
                                                            .fieldValues,
                                                      );
                                                      // print(payoutController
                                                      //     .fieldNames);
                                                      // print(payoutController
                                                      //     .fieldValues);
                                                    },
                                                  )
                                                : CircularProgressIndicator(
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 40.h,
                                          )
                                        ],
                                      );
                                    } else {
                                      // Return an empty container for other gateways
                                      return Container();
                                    }
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text('No data available.'),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                  /// FlutterWave Payout Logic
                  if ("${widget.data.name}" == "Flutterwave")
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * .65,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.getBackgroundDarkLight(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GetBuilder<PayoutController>(
                            builder: (controller) {
                              if (controller.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (controller.message != null) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  // physics: AlwaysScrollableScrollPhysics(),
                                  itemCount:
                                      controller.message!.gateways!.length,
                                  itemBuilder: (context, index) {
                                    final gateway =
                                        controller.message!.gateways![index];

                                    // Check if the gateway name is "Wire Transfer"
                                    if (gateway.name == "Flutterwave") {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8),
                                          Text(
                                            "Select Bank",
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors
                                                    .getTextDarkLight()),
                                          ),
                                          const SizedBox(height: 8),
                                          if (controller.bankNameFlutterWave !=
                                              null)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              height: 60.h,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: AppColors
                                                      .getTextFieldDarkLight()),
                                              child: DropdownButton<String>(
                                                hint: Text(
                                                  "Select",
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .getTextDarkLight()),
                                                ),
                                                underline: const SizedBox(),
                                                isExpanded: true,
                                                value: controller
                                                    .selectedBankNameFlutterWave,
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: controller
                                                    .bankNameFlutterWave
                                                    .map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                  (dynamic items) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: items
                                                          .toString(), // Convert to String if not already
                                                      child: Text(
                                                        items.toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14.sp,
                                                            color: AppColors
                                                                .getTextDarkLight()),
                                                      ),
                                                    );
                                                  },
                                                ).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    controller
                                                            .selectedBankNameFlutterWave =
                                                        newValue!;
                                                    controller.selectedBank =
                                                        "";
                                                    //controller.messageBankData!.bank!.data!.clear();
                                                    controller.messageBankData
                                                            ?.inputForm ==
                                                        null;
                                                    if (kDebugMode) {
                                                      print(
                                                          "${controller.selectedBankNameFlutterWave}");
                                                    }
                                                    controller
                                                        .getPayoutBankFormData(
                                                            controller
                                                                .selectedBankNameFlutterWave
                                                                .toString());
                                                  });
                                                },
                                              ),
                                            ),
                                          const SizedBox(height: 16),
                                          Text(
                                            "Select Currency",
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors
                                                    .getTextDarkLight()),
                                          ),
                                          const SizedBox(height: 8),
                                          if (controller
                                                  .supportedCurrencyFlutterWave !=
                                              null)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              height: 60.h,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: AppColors
                                                      .getTextFieldDarkLight()),
                                              child: DropdownButton<String>(
                                                hint: Text(
                                                  "Select",
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .getTextDarkLight()),
                                                ),
                                                underline: const SizedBox(),
                                                isExpanded: true,
                                                value: controller
                                                    .selectedSupportedCurrencyFlutterWave,
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: controller
                                                    .supportedCurrencyFlutterWave
                                                    .keys
                                                    .map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                  (String key) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: key,
                                                      child: Text(
                                                        controller
                                                                .supportedCurrencyFlutterWave[
                                                            key]!,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14.sp,
                                                            color: AppColors
                                                                .getTextDarkLight()),
                                                      ),
                                                    );
                                                  },
                                                ).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    controller
                                                            .selectedSupportedCurrencyFlutterWave =
                                                        newValue!;
                                                  });
                                                },
                                              ),
                                            ),
                                          controller.isLoadingPayoutBank ==
                                                  false
                                              ? controller.messageBankData
                                                          ?.bank !=
                                                      null
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                            height: 16),
                                                        Text(
                                                          "Select Bank",
                                                          style: TextStyle(
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .getTextDarkLight()),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        if (controller
                                                                .messageBankData !=
                                                            null)
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12),
                                                            height: 50,
                                                            width:
                                                                double.infinity,
                                                            decoration: BoxDecoration(
                                                                color: AppColors
                                                                    .getTextFieldDarkLight()),
                                                            child:
                                                                DropdownButton<
                                                                    Data>(
                                                              hint: Text(
                                                                "Select a bank",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                              underline:
                                                                  const SizedBox(),
                                                              isExpanded: true,
                                                              value: controller
                                                                  .messageBankData
                                                                  ?.bank
                                                                  ?.data
                                                                  ?.firstWhere(
                                                                (bank) =>
                                                                    bank.name ==
                                                                    controller
                                                                        .selectedBank,
                                                                orElse: () =>
                                                                    controller
                                                                        .messageBankData!
                                                                        .bank!
                                                                        .data![0],
                                                              ),
                                                              icon: const Icon(Icons
                                                                  .keyboard_arrow_down),
                                                              items: controller
                                                                  .messageBankData!
                                                                  .bank!
                                                                  .data!
                                                                  .map<
                                                                      DropdownMenuItem<
                                                                          Data>>(
                                                                (Data bank) {
                                                                  return DropdownMenuItem<
                                                                      Data>(
                                                                    value: bank,
                                                                    child: Text(
                                                                      bank.name ??
                                                                          "",
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            14.sp,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ).toList(),
                                                              // After you have selected a bank in your DropdownButton, you can access its code like this:
                                                              onChanged:
                                                                  (newValue) {
                                                                setState(() {
                                                                  controller
                                                                          .selectedBank =
                                                                      newValue?.name ??
                                                                          "";
                                                                  if (kDebugMode) {
                                                                    print(controller
                                                                        .selectedBank);
                                                                  } // This will print the selected bank's name
                                                                  // To access the bank's code, you can use the controller.messageBankData
                                                                  // assuming that controller.messageBankData contains the code.
                                                                  if (controller
                                                                          .messageBankData !=
                                                                      null) {
                                                                    final selectedBankData = controller
                                                                        .messageBankData
                                                                        ?.bank
                                                                        ?.data
                                                                        ?.firstWhere(
                                                                      (bank) =>
                                                                          bank.name ==
                                                                          controller
                                                                              .selectedBank,
                                                                      orElse: () => controller
                                                                          .messageBankData!
                                                                          .bank!
                                                                          .data![0],
                                                                    );
                                                                    if (selectedBankData !=
                                                                        null) {
                                                                      selectedBankCode =
                                                                          selectedBankData
                                                                              .code; // Access the code here
                                                                      if (kDebugMode) {
                                                                        print(
                                                                            selectedBankCode);
                                                                      } // This will print the selected bank's code
                                                                    }
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ),

                                                        const SizedBox(
                                                            height: 6),
                                                        //Generate TextFields dynamically from input_form properties
                                                      ],
                                                    )
                                                  : const SizedBox.shrink()
                                              : const Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(25.0),
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          if (controller.inputFieldsData !=
                                              null)
                                            Container(
                                              height: 270,
                                              child: ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: controller
                                                    .inputFieldsData.length,
                                                itemBuilder: (context, index) {
                                                  final propertyName =
                                                      controller
                                                          .inputFieldsData.keys
                                                          .toList()[index];
                                                  final propertyValue = controller
                                                                  .inputFieldsData[
                                                              propertyName] !=
                                                          'meta'
                                                      ? controller
                                                              .inputFieldsData[
                                                          propertyName]
                                                      : ''; // Use default value if null

                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 0,
                                                        vertical: 10),
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 12,
                                                                top: 10,
                                                                bottom: 12),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8.0), // Set the border radius here
                                                          borderSide: BorderSide
                                                              .none, // Remove the default border
                                                        ),
                                                        fillColor: AppColors
                                                            .getTextFieldDarkLight(),
                                                        filled: true,
                                                        labelText: propertyName,
                                                      ),
                                                      controller:
                                                          TextEditingController(
                                                              text:
                                                                  propertyValue), // Set the default value here
                                                      onChanged: (value) {
                                                        // Update the corresponding property value in InputForm
                                                        controller.inputFieldsData[
                                                                propertyName] =
                                                            value;

                                                        // Rest of your onChanged logic
                                                        fieldNames
                                                            .add(propertyName);
                                                        fieldValues.add(value);

                                                        if (kDebugMode) {
                                                          print(fieldNames);
                                                          print(fieldValues);
                                                        }
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          SizedBox(height: 30.h),
                                          Center(
                                            child: payoutController
                                                        .isLoadingPayoutRequest ==
                                                    false
                                                ? AppCustomButton(
                                                    width: double.infinity,
                                                    height: 50.h,
                                                    borderRadius: 32.00,
                                                    titleColor: Colors.white,
                                                    title: "Confirm Now",
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                    onTap: () {
                                                      payoutController
                                                          .flutterWavePayoutRequest(
                                                        context,
                                                        widget.selectedType,
                                                        widget.data.id,
                                                        totalPayable,
                                                        fieldNames,
                                                        fieldValues,
                                                        transferName: controller
                                                            .selectedBankNameFlutterWave,
                                                        currencyCode: controller
                                                            .selectedSupportedCurrencyFlutterWave,
                                                        bank: selectedBankCode,
                                                      );
                                                    },
                                                  )
                                                : CircularProgressIndicator(
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 30.h,
                                          ),
                                        ],
                                      );
                                    } else {
                                      // Return an empty container for other gateways
                                      return Container();
                                    }
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text('No data available.'),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                  /// RazorPay Payout Logic
                  if ("${widget.data.name}" == "Razorpay")
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * .65,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.getBackgroundDarkLight(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GetBuilder<PayoutController>(
                            builder: (controller) {
                              if (controller.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (controller.message != null) {
                                return ListView.builder(
                                  //physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      controller.message!.gateways!.length,
                                  itemBuilder: (context, index) {
                                    final gateway =
                                        controller.message!.gateways![index];
                                    final gatewayFormFields = controller
                                        .gatewayFormFields[gateway.name];
                                    final supportedCurrencies =
                                        controller.gatewaySupportedCurrencies[
                                            gateway.name];

                                    // Check if the gateway name is "Razorpay"
                                    if (gateway.name == "Razorpay") {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8),
                                          if (supportedCurrencies != null)
                                            AppCustomDropDown(
                                              items: supportedCurrencies
                                                  .map((item) => item.value!)
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  controller.selectedCurrency =
                                                      value;
                                                  controller
                                                          .selectedCurrencyController
                                                          .text =
                                                      value!; // Update the controller's value
                                                });
                                                if (kDebugMode) {
                                                  print(controller
                                                      .selectedCurrencyController
                                                      .text);
                                                }
                                              },
                                              selectedValue:
                                                  controller.selectedCurrency,
                                              hint: "Select a currency",
                                              fontSize: 14.sp,
                                              hintStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors
                                                    .getTextDarkLight(),
                                              ),
                                              selectedStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors
                                                    .getTextDarkLight(),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppColors
                                                    .getTextFieldDarkLight(),
                                              ),
                                              dropdownDecoration: BoxDecoration(
                                                color: AppColors
                                                    .getContainerBgDarkLight(),
                                                border: Border.all(
                                                    color: Get.isDarkMode
                                                        ? Colors.white10
                                                        : Colors.black12),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              width: double.infinity,
                                              height: 60.h,
                                            ),
                                          const SizedBox(height: 12),
                                          if (gatewayFormFields != null)
                                            Column(
                                              children: gatewayFormFields,
                                            ),
                                          SizedBox(height: 30.h),
                                          Center(
                                            child: payoutController
                                                        .isLoadingPayoutRequest ==
                                                    false
                                                ? AppCustomButton(
                                                    width: double.infinity,
                                                    height: 50.h,
                                                    borderRadius: 32.00,
                                                    titleColor: Colors.white,
                                                    title: "Confirm Now",
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                    onTap: () {
                                                      payoutController
                                                          .payoutRequest(
                                                        context,
                                                        widget.selectedType,
                                                        widget.data.id,
                                                        totalPayable,
                                                        payoutController
                                                            .fieldNames,
                                                        payoutController
                                                            .fieldValues,
                                                        currencyCode: controller
                                                            .selectedCurrencyController
                                                            .text
                                                            .toString(),
                                                        selectBank: controller
                                                            .selectedPayStackBank,
                                                      );
                                                    },
                                                  )
                                                : CircularProgressIndicator(
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                  ),
                                          ),
                                          SizedBox(height: 30.h),
                                        ],
                                      );
                                    } else {
                                      // Return an empty container for other gateways
                                      return Container();
                                    }
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text('No data available.'),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                  /// PayStack Payout Logic
                  if ("${widget.data.name}" == "Paystack")
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * .65,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.getBackgroundDarkLight(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GetBuilder<PayoutController>(
                            builder: (controller) {
                              if (controller.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (controller.message != null) {
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      controller.message!.gateways!.length,
                                  itemBuilder: (context, index) {
                                    final gateway =
                                        controller.message!.gateways![index];
                                    final gatewayFormFields = controller
                                        .gatewayFormFields[gateway.name];
                                    final supportedCurrencies =
                                        controller.gatewaySupportedCurrencies[
                                            gateway.name];

                                    // Check if the gateway name is "Paystack"
                                    if (gateway.name == "Paystack") {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8),
                                          Text(
                                            "Select Currency",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppColors.getTextDarkLight(),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 6.h,
                                          ),
                                          if (supportedCurrencies != null)
                                            AppCustomDropDown(
                                              items: supportedCurrencies
                                                  .map((item) => item.value!)
                                                  .toSet()
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  controller.selectedCurrency =
                                                      value;
                                                  controller
                                                          .selectedCurrencyController
                                                          .text =
                                                      value!; // Update the controller's value
                                                  controller.getPayStackBankData(
                                                      controller
                                                          .selectedCurrencyController
                                                          .text
                                                          .toString());
                                                });
                                                if (kDebugMode) {
                                                  print(controller
                                                      .selectedCurrencyController
                                                      .text);
                                                }
                                              },
                                              selectedValue:
                                                  controller.selectedCurrency,
                                              hint: "Select a currency",
                                              fontSize: 14.sp,
                                              hintStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors
                                                    .getTextDarkLight(),
                                              ),
                                              selectedStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors
                                                    .getTextDarkLight(),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppColors
                                                    .getTextFieldDarkLight(),
                                              ),
                                              dropdownDecoration: BoxDecoration(
                                                color: AppColors
                                                    .getContainerBgDarkLight(),
                                                border: Border.all(
                                                    color: Get.isDarkMode
                                                        ? Colors.white10
                                                        : Colors.black12),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              width: double.infinity,
                                              height: 60.h,
                                            ),
                                          controller.isLoadingPayStack == false
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 16),
                                                    Text(
                                                      "Select Bank",
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 6.h,
                                                    ),
                                                    if (controller
                                                            .messagePayStackBankData !=
                                                        null)
                                                      AppCustomDropDown(
                                                        items: controller
                                                            .messagePayStackBankData!
                                                            .data!
                                                            .map((bank) =>
                                                                bank.name!)
                                                            .toSet()
                                                            .toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            if (kDebugMode) {
                                                              print(
                                                                  "Selected bank code: $value");
                                                            }
                                                            // Update the selected bank in the controller
                                                            controller
                                                                    .selectedPayStackBank =
                                                                value!;
                                                          });
                                                        },
                                                        selectedValue: controller
                                                            .selectedPayStackBank,
                                                        hint: "Select a bank",
                                                        fontSize: 14.sp,
                                                        hintStyle: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .getTextDarkLight(),
                                                        ),
                                                        selectedStyle:
                                                            TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .getTextDarkLight(),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: AppColors
                                                              .getTextFieldDarkLight(),
                                                        ),
                                                        dropdownDecoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .getContainerBgDarkLight(),
                                                          border: Border.all(
                                                              color: Get.isDarkMode
                                                                  ? Colors
                                                                      .white10
                                                                  : Colors
                                                                      .black12),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        width: double.infinity,
                                                        height: 60.h,
                                                      ),
                                                    const SizedBox(height: 12),
                                                  ],
                                                )
                                              : const Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(25.0),
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                          const SizedBox(height: 8),
                                          if (gatewayFormFields != null)
                                            Column(
                                              children: gatewayFormFields,
                                            ),
                                          SizedBox(height: 30.h),
                                          Center(
                                            child: payoutController
                                                        .isLoadingPayoutRequest ==
                                                    false
                                                ? AppCustomButton(
                                                    borderRadius: 32.00,
                                                    width: double.infinity,
                                                    height: 50.h,
                                                    titleColor: Colors.white,
                                                    title: "Confirm Now",
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                    onTap: () {
                                                      payoutController
                                                          .payoutRequest(
                                                        context,
                                                        widget.selectedType,
                                                        widget.data.id,
                                                        totalPayable,
                                                        payoutController
                                                            .fieldNames,
                                                        payoutController
                                                            .fieldValues,
                                                        currencyCode: controller
                                                            .selectedCurrencyController
                                                            .text
                                                            .toString(),
                                                        selectBank: controller
                                                            .selectedPayStackBank,
                                                      );
                                                    },
                                                  )
                                                : CircularProgressIndicator(
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                  ),
                                          )
                                        ],
                                      );
                                    } else {
                                      // Return an empty container for other gateways
                                      return Container();
                                    }
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text('No data available.'),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                  /// Coinbase Payout Logic
                  if ("${widget.data.name}" == "Coinbase")
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * .65,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.getBackgroundDarkLight(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GetBuilder<PayoutController>(
                            builder: (controller) {
                              if (controller.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (controller.message != null) {
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      controller.message!.gateways!.length,
                                  itemBuilder: (context, index) {
                                    final gateway =
                                        controller.message!.gateways![index];
                                    final gatewayFormFields = controller
                                        .gatewayFormFields[gateway.name];
                                    final supportedCurrencies =
                                        controller.gatewaySupportedCurrencies[
                                            gateway.name];

                                    // Check if the gateway name is "Coinbase"
                                    if (gateway.name == "Coinbase") {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8),
                                          if (supportedCurrencies != null)
                                            AppCustomDropDown(
                                              items: supportedCurrencies
                                                  .map((item) => item.value!)
                                                  .toSet()
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  controller.selectedCurrency =
                                                      value;
                                                  controller
                                                          .selectedCurrencyController
                                                          .text =
                                                      value!; // Update the controller's value
                                                });
                                                if (kDebugMode) {
                                                  print(controller
                                                      .selectedCurrencyController
                                                      .text);
                                                }
                                              },
                                              selectedValue:
                                                  controller.selectedCurrency,
                                              hint: "Select a currency",
                                              fontSize: 14.sp,
                                              hintStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors
                                                    .getTextDarkLight(),
                                              ),
                                              selectedStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors
                                                    .getTextDarkLight(),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppColors
                                                    .getTextFieldDarkLight(),
                                              ),
                                              dropdownDecoration: BoxDecoration(
                                                color: AppColors
                                                    .getContainerBgDarkLight(),
                                                border: Border.all(
                                                    color: Get.isDarkMode
                                                        ? Colors.white10
                                                        : Colors.black12),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              width: double.infinity,
                                              height: 60.h,
                                            ),
                                          const SizedBox(height: 12),
                                          if (gatewayFormFields != null)
                                            Column(
                                              children: gatewayFormFields,
                                            ),
                                          SizedBox(height: 30.h),
                                          Center(
                                            child: payoutController
                                                        .isLoadingPayoutRequest ==
                                                    false
                                                ? AppCustomButton(
                                                    width: double.infinity,
                                                    height: 50.h,
                                                    borderRadius: 32.00,
                                                    titleColor: Colors.white,
                                                    title: "Confirm Now",
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                    onTap: () {
                                                      payoutController
                                                          .payoutRequest(
                                                        context,
                                                        widget.selectedType,
                                                        widget.data.id,
                                                        totalPayable,
                                                        payoutController
                                                            .fieldNames,
                                                        payoutController
                                                            .fieldValues,
                                                        currencyCode: controller
                                                            .selectedCurrencyController
                                                            .text
                                                            .toString(),
                                                      );
                                                    },
                                                  )
                                                : CircularProgressIndicator(
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                  ),
                                          )
                                        ],
                                      );
                                    } else {
                                      // Return an empty container for other gateways
                                      return Container();
                                    }
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text('No data available.'),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                  ///  Perfect Money Logic
                  if ("${widget.data.name}" == "Perfect Money")
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * .65,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.getBackgroundDarkLight(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GetBuilder<PayoutController>(
                            builder: (controller) {
                              if (controller.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (controller.message != null) {
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      controller.message!.gateways!.length,
                                  itemBuilder: (context, index) {
                                    final gateway =
                                        controller.message!.gateways![index];
                                    final gatewayFormFields = controller
                                        .gatewayFormFields[gateway.name];
                                    final supportedCurrencies =
                                        controller.gatewaySupportedCurrencies[
                                            gateway.name];

                                    // Check if the gateway name is "Perfect Money"
                                    if (gateway.name == "Perfect Money") {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8),
                                          if (supportedCurrencies != null)
                                            AppCustomDropDown(
                                              items: supportedCurrencies
                                                  .map((item) => item.value!)
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  controller.selectedCurrency =
                                                      value;
                                                  controller
                                                          .selectedCurrencyController
                                                          .text =
                                                      value!; // Update the controller's value
                                                });
                                                if (kDebugMode) {
                                                  print(controller
                                                      .selectedCurrencyController
                                                      .text);
                                                }
                                              },
                                              selectedValue:
                                                  controller.selectedCurrency,
                                              hint: "Select a currency",
                                              fontSize: 14.sp,
                                              hintStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors
                                                    .getTextDarkLight(),
                                              ),
                                              selectedStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors
                                                    .getTextDarkLight(),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppColors
                                                    .getTextFieldDarkLight(),
                                              ),
                                              dropdownDecoration: BoxDecoration(
                                                color: AppColors
                                                    .getContainerBgDarkLight(),
                                                border: Border.all(
                                                    color: Get.isDarkMode
                                                        ? Colors.white10
                                                        : Colors.black12),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              width: double.infinity,
                                              height: 60.h,
                                            ),
                                          const SizedBox(height: 8),
                                          if (gatewayFormFields != null)
                                            Column(
                                              children: gatewayFormFields,
                                            ),
                                          SizedBox(height: 30.h),
                                          Center(
                                            child: payoutController
                                                        .isLoadingPayoutRequest ==
                                                    false
                                                ? AppCustomButton(
                                                    width: double.infinity,
                                                    height: 50.h,
                                                    borderRadius: 32.00,
                                                    titleColor: Colors.white,
                                                    title: "Confirm Now",
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                    onTap: () {
                                                      payoutController
                                                          .payoutRequest(
                                                        context,
                                                        widget.selectedType,
                                                        widget.data.id,
                                                        totalPayable,
                                                        payoutController
                                                            .fieldNames,
                                                        payoutController
                                                            .fieldValues,
                                                        currencyCode: controller
                                                            .selectedCurrencyController
                                                            .text
                                                            .toString(),
                                                      );
                                                    },
                                                  )
                                                : CircularProgressIndicator(
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                  ),
                                          )
                                        ],
                                      );
                                    } else {
                                      // Return an empty container for other gateways
                                      return Container();
                                    }
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text('No data available.'),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                  /// Paypal Payout Logic
                  if ("${widget.data.name}" == "Paypal")
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * .65,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.getBackgroundDarkLight(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GetBuilder<PayoutController>(
                            builder: (controller) {
                              if (controller.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (controller.message != null) {
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      controller.message!.gateways!.length,
                                  itemBuilder: (context, index) {
                                    final gateway =
                                        controller.message!.gateways![index];
                                    final gatewayFormFields = controller
                                        .gatewayFormFields[gateway.name];
                                    final supportedCurrencies =
                                        controller.gatewaySupportedCurrencies[
                                            gateway.name];

                                    // Check if the gateway name is "Paypal"
                                    if (gateway.name == "Paypal") {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Select Currency",
                                            style: GoogleFonts.niramit(
                                                color: AppColors
                                                    .getTextDarkLight(),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          const SizedBox(height: 8),
                                          if (supportedCurrencies != null)
                                            SizedBox(
                                              height: 60.h,
                                              child: AppCustomDropDown(
                                                items: supportedCurrencies
                                                    .map((item) => item.value!)
                                                    .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    controller
                                                            .selectedCurrency =
                                                        value;
                                                    controller
                                                            .selectedCurrencyController
                                                            .text =
                                                        value!; // Update the controller's value
                                                  });
                                                  if (kDebugMode) {
                                                    print(controller
                                                        .selectedCurrencyController
                                                        .text);
                                                  }
                                                },
                                                selectedValue:
                                                    controller.selectedCurrency,
                                                hint: "Select a currency",
                                                fontSize: 14.sp,
                                                hintStyle: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors
                                                      .getTextDarkLight(),
                                                ),
                                                selectedStyle: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors
                                                      .getTextDarkLight(),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors
                                                      .getTextFieldDarkLight(),
                                                ),
                                                dropdownDecoration:
                                                    BoxDecoration(
                                                  color: AppColors
                                                      .getContainerBgDarkLight(),
                                                  border: Border.all(
                                                      color: Get.isDarkMode
                                                          ? Colors.white10
                                                          : Colors.black12),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                width: double.infinity,
                                                paddingLeft: 12,
                                              ),
                                            ),
                                          const SizedBox(height: 16),
                                          Text(
                                            "Select Recipient Type",
                                            style: GoogleFonts.niramit(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppColors.getTextDarkLight(),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          SizedBox(
                                            height: 60.h,
                                            child: AppCustomDropDown(
                                              items: paypalItem,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedPaypalItem =
                                                      newValue!;
                                                  if (kDebugMode) {
                                                    print(selectedPaypalItem);
                                                  }
                                                });
                                              },
                                              selectedValue: selectedPaypalItem,
                                              hint: "Select",
                                              fontSize: 14.sp,
                                              hintStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors
                                                    .getTextDarkLight(),
                                              ),
                                              selectedStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors
                                                    .getTextDarkLight(),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppColors
                                                    .getTextFieldDarkLight(),
                                              ),
                                              dropdownDecoration: BoxDecoration(
                                                color: AppColors
                                                    .getContainerBgDarkLight(),
                                                border: Border.all(
                                                    color: Get.isDarkMode
                                                        ? Colors.white10
                                                        : Colors.black12),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              width: double.infinity,
                                              paddingLeft: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          if (gatewayFormFields != null)
                                            Column(
                                              children: gatewayFormFields,
                                            ),
                                          SizedBox(height: 30.h),
                                          Center(
                                            child: payoutController
                                                        .isLoadingPayoutRequest ==
                                                    false
                                                ? AppCustomButton(
                                                    borderRadius: 32.00,
                                                    width: double.infinity,
                                                    height: 50.h,
                                                    titleColor: Colors.white,
                                                    title: "Confirm Now",
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                    onTap: () {
                                                      payoutController
                                                          .payoutRequest(
                                                        context,
                                                        widget.selectedType,
                                                        widget.data.id,
                                                        totalPayable,
                                                        payoutController
                                                            .fieldNames,
                                                        payoutController
                                                            .fieldValues,
                                                        currencyCode: controller
                                                            .selectedCurrencyController
                                                            .text
                                                            .toString(),
                                                        recipientType:
                                                            selectedPaypalItem
                                                                .toString(),
                                                      );
                                                    },
                                                  )
                                                : CircularProgressIndicator(
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                  ),
                                          )
                                        ],
                                      );
                                    } else {
                                      // Return an empty container for other gateways
                                      return Container();
                                    }
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text('No data available.'),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                  /// Binance Payout Logic
                  if ("${widget.data.name}" == "Binance") ...{
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * .65,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.getBackgroundDarkLight(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GetBuilder<PayoutController>(
                            builder: (controller) {
                              if (controller.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (controller.message != null) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        controller.message!.gateways!.length,
                                    itemBuilder: (context, index) {
                                      final gateway =
                                          controller.message!.gateways![index];
                                      final gatewayFormFields = controller
                                          .gatewayFormFields[gateway.name];
                                      dynamic supportedCurrencies =
                                          controller.gatewaySupportedCurrencies[
                                              gateway.name];

                                      // Check if the gateway name is "Wire Transfer"
                                      if (gateway.name == "Binance") {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 8),
                                            if (supportedCurrencies != null)
                                              SizedBox(
                                                height: 60.h,
                                                child: AppCustomDropDown(
                                                  items: (supportedCurrencies
                                                          as List<
                                                              DropdownMenuItem<
                                                                  dynamic>>)
                                                      .map(
                                                          (item) => item.value!)
                                                      .toSet()
                                                      .toList(),
                                                  onChanged: (value) {
                                                    // Handle dropdown value change
                                                    setState(() {
                                                      controller
                                                              .selectedCurrency =
                                                          value;
                                                      controller
                                                              .selectedCurrencyController
                                                              .text =
                                                          value!; // Update the controller's value
                                                    });
                                                    if (kDebugMode) {
                                                      print(controller
                                                          .selectedCurrencyController
                                                          .text);
                                                    }
                                                  },
                                                  selectedValue: controller
                                                      .selectedCurrency,
                                                  hint: "Select a currency",
                                                  fontSize: 14.sp,
                                                  hintStyle: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .getTextDarkLight(),
                                                  ),
                                                  selectedStyle: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .getTextDarkLight(),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: AppColors
                                                        .getTextFieldDarkLight(),
                                                  ),
                                                  dropdownDecoration:
                                                      BoxDecoration(
                                                    color: AppColors
                                                        .getContainerBgDarkLight(),
                                                    border: Border.all(
                                                        color: Get.isDarkMode
                                                            ? Colors.white10
                                                            : Colors.black12),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  width: double.infinity,
                                                  paddingLeft: 12,
                                                ),
                                              ),
                                            const SizedBox(height: 8),
                                            if (gatewayFormFields != null)
                                              Column(
                                                children: gatewayFormFields,
                                              ),
                                            SizedBox(height: 30.h),
                                            Center(
                                              child: payoutController
                                                          .isLoadingPayoutRequest ==
                                                      false
                                                  ? AppCustomButton(
                                                      width: double.infinity,
                                                      height: 50.h,
                                                      borderRadius: 32.00,
                                                      titleColor: Colors.white,
                                                      title: "Confirm Now",
                                                      color: AppColors
                                                          .appPrimaryColor,
                                                      onTap: () {
                                                        payoutController.payoutRequest(
                                                            context,
                                                            widget.selectedType,
                                                            widget.data.id,
                                                            totalPayable,
                                                            payoutController
                                                                .fieldNames,
                                                            payoutController
                                                                .fieldValues,
                                                            currencyCode: controller
                                                                .selectedCurrencyController
                                                                .text
                                                                .toString());
                                                      },
                                                    )
                                                  : CircularProgressIndicator(
                                                      color: AppColors
                                                          .appPrimaryColor,
                                                    ),
                                            )
                                          ],
                                        );
                                      } else {
                                        // Return an empty container for other gateways
                                        return Container();
                                      }
                                    },
                                  );
                                });
                              } else {
                                return const Center(
                                  child: Text('No data available.'),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  }
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  List<String> paypalItem = ["Email", "Phone", "Paypal ID"];

  dynamic selectedPaypalItem;
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hypro/controller/deposit_controller.dart';
import 'package:flutter_hypro/controller/securion_authorizepay_controller.dart';
import 'package:flutter_hypro/view/screens/deposit/deposit_screen.dart';
import 'package:flutter_hypro/view/widgets/app_card_formatter.dart';
import 'package:flutter_hypro/view/widgets/app_card_month_formatter.dart';
import 'package:flutter_hypro/view/widgets/app_card_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/colors/app_colors.dart';

// ignore: must_be_immutable
class SecurioPayAuthorizenetPayScreen extends StatefulWidget {
  static const String routeName = "/securioPayAuthorizenetPayScreen";
  dynamic gatewayName;
  SecurioPayAuthorizenetPayScreen({super.key, this.gatewayName});

  @override
  State<SecurioPayAuthorizenetPayScreen> createState() =>
      _SecurioPayAuthorizenetPayScreenState();
}

class _SecurioPayAuthorizenetPayScreenState
    extends State<SecurioPayAuthorizenetPayScreen> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardNameController = TextEditingController();
  TextEditingController cardCVVController = TextEditingController();
  TextEditingController cardMMYYController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CardType cardType = CardType.Invalid;

  void getCardTypeFrmNumber() {
    if (cardNumberController.text.length <= 6) {
      String input = CardUtils.getCleanedNumber(cardNumberController.text);
      CardType type = CardUtils.getCardTypeFrmNumber(input);
      if (type != cardType) {
        setState(() {
          cardType = type;
        });
      }
    }
  }

  @override
  void initState() {
    cardNumberController.addListener(
      () {
        getCardTypeFrmNumber();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.getBackgroundDarkLight(),
      appBar: AppBar(
        backgroundColor: AppColors.getAppBarBgDarkLight(),
        centerTitle: true,
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
          widget.gatewayName == "securionpay"
              ? "Pay with SecurionPay"
              : "Pay with AuthorizeNet",
          style:
              TextStyle(fontSize: 16.sp, color: AppColors.getTextDarkLight()),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              widget.gatewayName == "securionpay"
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/securionPay.png"),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/authorizenet.png"),
                    ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: cardNumberController,
                        keyboardType: TextInputType.number,
                        validator: CardUtils.validateCardNum,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(19),
                          CardNumberInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 12, top: 10, bottom: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Set the border radius here
                            borderSide:
                                BorderSide.none, // Remove the default border
                          ),
                          fillColor: AppColors.getTextFieldDarkLight(),
                          filled: true,
                          hintStyle: const TextStyle(
                            color: AppColors.appBlackColor50,
                          ),
                          hintText: "Card number",
                          suffix: CardUtils.getCardIcon(cardType),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field is required';
                            }
                            return null; // Return null if the input is valid
                          },
                          controller: cardNameController,
                          decoration: InputDecoration(
                              suffixIcon: const Icon(
                                Icons.person,
                                color: AppColors.appBlackColor50,
                              ),
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
                              hintStyle: const TextStyle(
                                color: AppColors.appBlackColor50,
                              ),
                              hintText: "Full name"),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field is required';
                                }
                                return null; // Return null if the input is valid
                              },
                              controller: cardCVVController,
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                // Limit the input
                                LengthLimitingTextInputFormatter(4),
                              ],
                              decoration: InputDecoration(
                                  suffixIcon: const Icon(
                                    Icons.lock,
                                    color: AppColors.appBlackColor50,
                                  ),
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
                                  hintStyle: const TextStyle(
                                    color: AppColors.appBlackColor50,
                                  ),
                                  hintText: "CVV"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field is required';
                                }
                                return null; // Return null if the input is valid
                              },
                              controller: cardMMYYController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                CardMonthInputFormatter(),
                              ],
                              decoration: InputDecoration(
                                  suffixIcon: const Icon(
                                    Icons.date_range,
                                    color: AppColors.appBlackColor50,
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 12, top: 10, bottom: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Set the border radius here
                                    borderSide: BorderSide
                                        .none, // Remove the default border
                                  ),
                                  fillColor: AppColors.getTextFieldDarkLight(),
                                  filled: true,
                                  hintStyle: const TextStyle(
                                    color: AppColors.appBlackColor50,
                                  ),
                                  hintText: "MM/YY"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: MaterialButton(
                      minWidth: 320.w,
                      height: 45.h,
                      color: AppColors.appPrimaryColor,
                      child: Get.find<SecurionPayAuthorizenetController>()
                                  .isLoading
                                  .value ==
                              false
                          ? const Text(
                              "Submit",
                              style: TextStyle(
                                  color: AppColors.appWhiteColor, fontSize: 16),
                            )
                          : const CircularProgressIndicator(
                              color: AppColors.appWhiteColor,
                            ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Get.find<SecurionPayAuthorizenetController>()
                              .cardPaymentRequest(
                                  Get.find<DepositController>()
                                      .amountController
                                      .text
                                      .toString(),
                                  selectedOption.id,
                                  cardNumberController.text.toString(),
                                  cardNameController.text.toString(),
                                  month,
                                  year,
                                  cardCVVController.text.toString(),
                                  context);
                        }
                      },
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

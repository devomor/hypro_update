import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/transfer_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/view/widgets/app_custom_dropdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class TransferScreen extends StatelessWidget {
  static const String routeName = "/transferScreen";
  TransferScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransferScreenController>(
        builder: (transferScreenController) {
      return Scaffold(
        backgroundColor: AppColors.getBackgroundDarkLight(),
        resizeToAvoidBottomInset: false,
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
            ),
          ),
          title: Text(
            "${selectedLanguageStorage.read("languageData")["Transfer"] ?? "Transfer"}",
            style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: AppColors.getTextDarkLight(),
            ),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 28.h),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Image.asset(
                      "assets/images/transfer_header.png",
                      height: 169.h,
                      width: 286.w,
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${selectedLanguageStorage.read("languageData")["Receiver Email Address"] ?? "Receiver Email Address"}",
                          style: GoogleFonts.niramit(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: AppColors.getTextDarkLight()),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          controller: transferScreenController.emailCtrl,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email is required';
                            }

                            // Define a regular expression for email validation
                            RegExp emailRegex = RegExp(
                              r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
                            );

                            if (!emailRegex.hasMatch(value)) {
                              return 'Enter a valid email address';
                            }

                            return null;
                          },
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
                                  "${selectedLanguageStorage.read("languageData")["Receiver Email Address"] ?? "Receiver Email Address"}",
                              hintStyle: GoogleFonts.niramit(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: AppColors.appBlackColor30)),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Text(
                          "${selectedLanguageStorage.read("languageData")["Amount"] ?? "Amount"}",
                          style: GoogleFonts.niramit(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: AppColors.getTextDarkLight()),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          controller: transferScreenController.amountCtrl,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Amount is required';
                            }
                            return null;
                          },
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
                        SizedBox(
                          height: 16.h,
                        ),
                        Text(
                          "${selectedLanguageStorage.read("languageData")["Select Wallet"] ?? "Select Wallet"}",
                          style: GoogleFonts.niramit(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: AppColors.getTextDarkLight()),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Obx(
                          () => AppCustomDropDown(
                            height: 55.h,
                            width: double.infinity,
                            dropDownWidth: double.infinity,
                            fontSize: 16.sp,
                            items: ['Main Balance', 'Interest Balance'],
                            onChanged: (value) {
                              // Handle the selected value here
                              transferScreenController.onDropdownChanged(value);
                            },
                            selectedValue:
                                transferScreenController.selectedOption.value,
                            hint: 'Select an option',
                            decoration: BoxDecoration(
                                // Customize the button's decoration
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.getTextFieldDarkLight()),
                            dropdownDecoration: BoxDecoration(
                              // Customize the dropdown's decoration
                              color: Get.isDarkMode
                                  ? AppColors.appContainerBgColor
                                  : AppColors.appWhiteColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Text(
                          "${selectedLanguageStorage.read("languageData")["Password"] ?? "Password"}",
                          style: GoogleFonts.niramit(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: AppColors.getTextDarkLight()),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          obscureText:
                              !transferScreenController.isPasswordVisible.value,
                          controller: transferScreenController.passwordCtrl,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  transferScreenController
                                      .togglePasswordVisibility();
                                },
                                child: Icon(
                                  transferScreenController
                                          .isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
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
                              hintText:
                                  "${selectedLanguageStorage.read("languageData")["Enter Password"] ?? "Enter Password"}",
                              hintStyle: GoogleFonts.niramit(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: AppColors.appBlackColor30)),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              transferScreenController
                                  .sendBalanceTransferRequest(
                                      transferScreenController.emailCtrl.text
                                          .toString(),
                                      transferScreenController.amountCtrl.text
                                          .toString(),
                                      transferScreenController
                                                  .selectedOption.value ==
                                              "Main Balance"
                                          ? "balance"
                                          : "interest_balance",
                                      transferScreenController.passwordCtrl.text
                                          .toString(),
                                      context);
                            }
                          },
                          child: Container(
                            height: 52.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColors.appPrimaryColor,
                                borderRadius: BorderRadius.circular(32)),
                            child: Center(
                              child: transferScreenController.isLoading == false
                                  ? Text(
                                      "${selectedLanguageStorage.read("languageData")["Proceed"] ?? "Proceed"}",
                                      style: GoogleFonts.niramit(
                                          fontSize: 20.sp,
                                          color: AppColors.appWhiteColor,
                                          fontWeight: FontWeight.w500),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(
                                      color: AppColors.appWhiteColor,
                                    )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 180.h,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 100.h,
            ),
          ],
        ),
      );
    });
  }
}

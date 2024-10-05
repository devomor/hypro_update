import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/verify_required_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors/app_colors.dart';

class TwoFactorVerificationScreen extends StatelessWidget {
  static const String routeName = "/two_factor_verification_screen";
  TwoFactorVerificationScreen({super.key});

  final selectedLanguageStorage = GetStorage();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyRequiredController>(
        builder: (verifyRequiredController) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 150,
              left: 24,
              right: 24,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${selectedLanguageStorage.read("languageData")["Two Factor Verification"] ?? "Two Factor Verification"}",
                      style: GoogleFonts.publicSans(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.getTextDarkLight(),
                      ),
                    ),
                    SizedBox(
                      height: 100.h,
                    ),
                    Text(
                      "${selectedLanguageStorage.read("languageData")["Code"] ?? "Code"}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10.h),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Code is required';
                        }
                        return null;
                      },
                      controller:
                          verifyRequiredController.twoFactorCodeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText:
                            "${selectedLanguageStorage.read("languageData")["Enter Your Code"] ?? "Enter Your Code"}",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding:
                            EdgeInsets.only(left: 12, top: 10, bottom: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: AppColors.getTextFieldDarkLight(),
                        filled: true,
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          verifyRequiredController.twoFactorVerifySubmit(
                              verifyRequiredController
                                  .twoFactorCodeController.text
                                  .toString());
                        }
                      },
                      child: Container(
                        height: 52.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.appPrimaryColor,
                            borderRadius: BorderRadius.circular(32)),
                        child: Center(
                            child:
                                verifyRequiredController.isLoadingTwoFactor ==
                                        false
                                    ? Text(
                                        "${selectedLanguageStorage.read("languageData")["Submit"] ?? "Submit"}",
                                        style: GoogleFonts.niramit(
                                            fontSize: 20.sp,
                                            color: AppColors.appWhiteColor,
                                            fontWeight: FontWeight.w500,
                                            height: 0.9),
                                      )
                                    : CircularProgressIndicator(
                                        color: AppColors.appWhiteColor,
                                      )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

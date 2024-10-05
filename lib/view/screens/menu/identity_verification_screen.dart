import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/my_account_controller.dart';
import 'package:flutter_hypro/controller/verification_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class IdentityVerificationScreen extends StatefulWidget {
  static const String routeName = "/identityVerificationScreen";
  const IdentityVerificationScreen({super.key});

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends State<IdentityVerificationScreen> {
  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyAccountController>(builder: (myAccountController) {
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
              "${selectedLanguageStorage.read("languageData")["Identity Verification"] ?? "Identity Verification"}",
              style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: AppColors.getTextDarkLight(),
              ),
            ),
          ),
          body: myAccountController.isLoading == false &&
                  myAccountController.message != null
              ? ListView(
                  children: [
                    myAccountController.message!.userIdentityVerifyFromShow ==
                            true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Text(
                                  "${selectedLanguageStorage.read("languageData")["Select Identity Type"] ?? "Select Identity Type"}",
                                  style: GoogleFonts.publicSans(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.getTextDarkLight(),
                                      fontSize: 16.sp),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.getAppBarBgDarkLight(),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: myAccountController
                                              .message!
                                              .identityFormList!
                                              .length,
                                          itemBuilder: (context, index) {
                                            return buildRadioButton(
                                                myAccountController
                                                    .message!
                                                    .identityFormList![index]
                                                    .id,
                                                myAccountController
                                                    .message!
                                                    .identityFormList![index]
                                                    .name);
                                          })
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              GetBuilder<MyAccountController>(
                                builder: (myAccountController) {
                                  if (myAccountController.isLoading) {
                                    return SizedBox();
                                  } else if (myAccountController.message !=
                                      null) {
                                    return SingleChildScrollView(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: myAccountController
                                            .formFields, // Use the list of form fields here
                                      ),
                                    );
                                  } else {
                                    return Center(
                                        child: Text(
                                            "${selectedLanguageStorage.read("languageData")["No data available."] ?? "No data available."}"));
                                  }
                                },
                              ),
                              selectedOption != 0
                                  ? GetBuilder<MyAccountController>(
                                      builder: (myAccountController) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (myAccountController.fieldNames !=
                                                  null &&
                                              myAccountController.fieldValues !=
                                                  null &&
                                              myAccountController
                                                      .selectedFilePath !=
                                                  null) {
                                            Get.find<VerificationController>()
                                                .sendIdentityVerificationRequest(
                                                    selectedType(
                                                        selectedIdentityType),
                                                    myAccountController
                                                        .fieldNames,
                                                    myAccountController
                                                        .fieldValues);
                                          } else {
                                            final backgroundColor = Colors.red;
                                            ScaffoldMessenger.of(context)
                                                .removeCurrentSnackBar();
                                            final snackBar = SnackBar(
                                              content: Text(
                                                "Please select an image",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.sp),
                                              ),
                                              backgroundColor: backgroundColor,
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
                                                .showSnackBar(snackBar);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Container(
                                            height: 45.h,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color:
                                                    AppColors.appPrimaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(32)),
                                            child: Get.find<VerificationController>()
                                                        .isIdentityLoading ==
                                                    false
                                                ? Center(
                                                    child: Get.find<VerificationController>()
                                                                .isLoading ==
                                                            false
                                                        ? Text(
                                                            "${selectedLanguageStorage.read("languageData")["Submit"] ?? "Submit"}",
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .appWhiteColor,
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )
                                                        : const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                            color: AppColors
                                                                .appWhiteColor,
                                                          )))
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: AppColors
                                                          .appWhiteColor,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      );
                                    })
                                  : const SizedBox.shrink(),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.getContainerBgDarkLight(),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Container(
                                        //   decoration: BoxDecoration(
                                        //       borderRadius: BorderRadius.circular(16),
                                        //       border: Border.all(
                                        //         color: AppColors.getContainerBorderDarkLight(),
                                        //       )
                                        //   ),
                                        //   child: Image.asset("assets/images/identity_image.png",
                                        //     height: 310.h,width: 315.w,),
                                        // ),
                                        // SizedBox(height: 24.h,),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColors
                                                  .getTextFieldDarkLight()),
                                          child: Text(
                                            "${myAccountController.message!.userIdentityVerifyMsg}",
                                            style: GoogleFonts.publicSans(
                                                fontSize: 17.sp,
                                                color: AppColors
                                                    .getTextDarkLight(),
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25.h,
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: AppColors.appPrimaryColor,
                  ),
                ));
    });
  }

  int selectedOption = 0;
  String selectedIdentityType = "";

  selectedType(dynamic index) {
    if (index == "Driving License") {
      return "driving-license";
    } else if (index == "Passport") {
      return "passport";
    } else if (index == "National ID") {
      return "national-id";
    } else {
      return null;
    }
  }

  Widget buildRadioButton(dynamic value, dynamic text) {
    return ListTile(
      title: Text(text, style: GoogleFonts.publicSans(fontSize: 16.sp)),
      trailing: Radio<int>(
        value: value,
        groupValue: selectedOption,
        onChanged: (int? newValue) {
          setState(() {
            selectedOption = newValue!;
            selectedIdentityType = text;
            if (kDebugMode) {
              print(selectedIdentityType);
            }
            Get.find<MyAccountController>()
                .getAccountData(identityFormName: text);
          });
        },
      ),
    );
  }
}

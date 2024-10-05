import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/my_account_controller.dart';
import 'package:flutter_hypro/controller/verification_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/colors/app_colors.dart';

class AddressVerificationScreen extends StatefulWidget {
  static const String routeName = "/addressVerificationScreen";
  const AddressVerificationScreen({super.key});

  @override
  State<AddressVerificationScreen> createState() =>
      _AddressVerificationScreenState();
}

class _AddressVerificationScreenState extends State<AddressVerificationScreen> {
  dynamic pickedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        if (kDebugMode) {
          print("Image Path${pickedImage.path}");
        }
      });
    }
    // Refresh the widget to show the selected image
  }

  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerificationController>(
        builder: (verificationController) {
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
            "${selectedLanguageStorage.read("languageData")["Address Verification"] ?? "Address Verification"}",
            style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: AppColors.getTextDarkLight(),
            ),
          ),
        ),
        body: ListView(
          children: [
            GetBuilder<MyAccountController>(builder: (myAccountController) {
              return myAccountController.isLoading == false &&
                      myAccountController.message != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                      ),
                      child: myAccountController
                                  .message!.userAddressVerifyFromShow ==
                              true
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 12.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${selectedLanguageStorage.read("languageData")["Address Proof"] ?? "Address Proof"}",
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    Text(
                                      "*",
                                      style: TextStyle(
                                          fontSize: 16.sp, color: Colors.red),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                Container(
                                  height: 60.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColors.getTextFieldDarkLight(),
                                  ),
                                  child: Row(
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          pickImage();
                                        },
                                        child: Text("Choose Files",
                                            style: GoogleFonts.publicSans(
                                              fontSize: 13.sp,
                                            )),
                                      ),
                                      SizedBox(width: 5.w),
                                      Container(
                                        height: 60,
                                        width: 1,
                                        color: AppColors.appBg3,
                                      ),
                                      SizedBox(width: 13.w),
                                      pickedImage != null
                                          ? Text(
                                              "1 File Selected",
                                              style: GoogleFonts.publicSans(
                                                  color: AppColors
                                                      .appDashBoardTransactionGreen,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          : Text(
                                              "No File Selected",
                                              style: GoogleFonts.publicSans(
                                                  fontSize: 13.sp),
                                            ),
                                    ],
                                  ),
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     pickImage();
                                //   },
                                //   child:
                                //   pickedImage ==null?
                                //   Image.asset(
                                //     "assets/images/default_img.png", height: 120.h,
                                //     width: 120.w,) :
                                //   Image.file(
                                //     File(pickedImage.path),
                                //     height: 120.0,
                                //     width: 120.0,
                                //     fit: BoxFit.cover,
                                //   ),
                                //
                                // ),

                                SizedBox(
                                  height: 25.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (pickedImage != null) {
                                      verificationController
                                          .sendAddressVerificationRequest(
                                              pickedImage.path)
                                          .then((value) {
                                        pickedImage = null;
                                        Get.find<MyAccountController>()
                                            .getAccountData();
                                      });
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
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: Container(
                                    height: 45.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: AppColors.appPrimaryColor,
                                        borderRadius:
                                            BorderRadius.circular(32)),
                                    child: verificationController.isLoading ==
                                            false
                                        ? Center(
                                            child: verificationController
                                                        .isLoading ==
                                                    false
                                                ? Text(
                                                    "${selectedLanguageStorage.read("languageData")["Submit"] ?? "Submit"}",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .appWhiteColor,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                : const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                    color:
                                                        AppColors.appWhiteColor,
                                                  )))
                                        : Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.appWhiteColor,
                                            ),
                                          ),
                                  ),
                                ),

                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 6),
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
                                          // SizedBox(height: 10.h,),
                                          // Container(
                                          //     decoration: BoxDecoration(
                                          //       borderRadius: BorderRadius.circular(16),
                                          //       border: Border.all(
                                          //         color: AppColors.getContainerBorderDarkLight(),
                                          //       )
                                          //     ),
                                          //     child: Image.asset("assets/images/address_image.png",height: 300.h,width: 300.w,)),
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
                                                "${myAccountController.message!.userAddressVerifyMsg}",
                                                style: GoogleFonts.publicSans(
                                                    fontSize: 17.sp,
                                                    color: AppColors
                                                        .getTextDarkLight(),
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ),
                                          SizedBox(
                                            height: 25.h,
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                    )
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: CircularProgressIndicator(),
                      ),
                    );
            })
          ],
        ),
      );
    });
  }
}

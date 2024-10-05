import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hypro/controller/two_factor_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/view/widgets/app_custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TwoFaScreen extends StatelessWidget {
  static const String routeName = "/twoFaScreen";
  TwoFaScreen({super.key});

  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwoFaSecurityController>(
        builder: (twoFaSecurityController) {
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
            ),
          ),
          title: Text(
            "${selectedLanguageStorage.read("languageData")["2Fa Security"] ?? "2Fa Security"}",
            style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: AppColors.getTextDarkLight(),
            ),
          ),
        ),
        body: twoFaSecurityController.isLoading == false &&
                twoFaSecurityController.message != null
            ? ListView(
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.getContainerBgDarkLight(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/two_fa_image.png",
                            height: 148.h,
                            width: 148.w,
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          Text(
                            "${selectedLanguageStorage.read("languageData")["Two Factor Authentication"] ?? "Two Factor Authentication"}",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            height: 41.h,
                                            width: 41.w,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: AppColors
                                                        .getContainerBorderDarkLight())),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10.h,
                                                  bottom: 10.h,
                                                  left: 10.w),
                                              child: SelectableText(
                                                "${twoFaSecurityController.message!.secret}",
                                                style:
                                                    TextStyle(fontSize: 14.sp),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                                text:
                                                    "${twoFaSecurityController.message!.secret}"));
                                            ScaffoldMessenger.of(context)
                                                .removeCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  backgroundColor: Colors.green,
                                                  content: Text(
                                                    'Text copied to clipboard',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            );
                                          },
                                          child: Container(
                                            height: 41.h,
                                            width: 41.w,
                                            color: AppColors.appPrimaryColor,
                                            child: Icon(
                                              Icons.copy_sharp,
                                              color: AppColors.appWhiteColor,
                                              size: 18.h,
                                            ),
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          QrImageView(
                            eyeStyle: QrEyeStyle(
                              color: Get.isDarkMode
                                  ? AppColors.appWhiteColor
                                  : AppColors.appBlackColor,
                            ),
                            data:
                                '${twoFaSecurityController.message!.qrCodeUrl}',
                            version: QrVersions.auto,
                            size: 150.0,
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          AppCustomButton(
                            height: 48.h,
                            width: 382.w,
                            borderRadius: 32.00,
                            titleColor: AppColors.appWhiteColor,
                            title: twoFaSecurityController
                                        .message!.twoFactorEnable !=
                                    true
                                ? "${selectedLanguageStorage.read("languageData")["Enable Two Factor Authenticator"] ?? "Enable Two Factor Authenticator"}"
                                : "${selectedLanguageStorage.read("languageData")["Disable Two Factor Authenticator"] ?? "Disable Two Factor Authenticator"}",
                            onTap: () {
                              twoFaSecurityController
                                          .message!.twoFactorEnable !=
                                      true
                                  ? Get.defaultDialog(
                                      barrierDismissible: false,
                                      titlePadding: EdgeInsets.only(top: 10.h),
                                      title:
                                          "${selectedLanguageStorage.read("languageData")["2 Step Security"] ?? "2 Step Security"}",
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "${selectedLanguageStorage.read("languageData")["Verify your OTP"] ?? "Verify your OTP"}",
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 10.h),
                                            TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  twoFaSecurityController
                                                      .googleAuthEnableCode,
                                              decoration: InputDecoration(
                                                hintText:
                                                    "${selectedLanguageStorage.read("languageData")["Enter Google Authenticator Code"] ?? "Enter Google Authenticator Code"}",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                contentPadding: EdgeInsets.only(
                                                    left: 12,
                                                    top: 10,
                                                    bottom: 12),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0), // Set the border radius here
                                                  borderSide: BorderSide
                                                      .none, // Remove the default border
                                                ),
                                                fillColor:
                                                    AppColors.appFillColor,
                                                filled: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      cancel: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors
                                              .red, // Customize the button color
                                        ),
                                        onPressed: () {
                                          Get.back(); // Close the dialog
                                        },
                                        child: Text(
                                          "${selectedLanguageStorage.read("languageData")["Cancel"] ?? "Cancel"}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                      confirm: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors
                                                .appPrimaryColor // Customize the button color
                                            ),
                                        onPressed: () {
                                          twoFaSecurityController
                                              .enableTwoFactorSecurity(
                                                  twoFaSecurityController
                                                      .googleAuthEnableCode.text
                                                      .toString(),
                                                  twoFaSecurityController
                                                      .message!.secret
                                                      .toString())
                                              .then((value) {
                                            twoFaSecurityController
                                                .googleAuthEnableCode.text = "";
                                            twoFaSecurityController
                                                .getTwoFaSecurityData();
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text(
                                          "${selectedLanguageStorage.read("languageData")["Verify"] ?? "Verify"}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                    )
                                  : Get.defaultDialog(
                                      barrierDismissible: false,
                                      titlePadding: EdgeInsets.only(top: 10.h),
                                      title:
                                          "${selectedLanguageStorage.read("2 Step Security")["2 Step Security"] ?? "2 Step Security"}",
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "${selectedLanguageStorage.read("languageData")["Code"] ?? "Code"}",
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 10.h),
                                            TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  twoFaSecurityController
                                                      .googleAuthDisableCode,
                                              decoration: InputDecoration(
                                                hintText:
                                                    "${selectedLanguageStorage.read("languageData")["Enter Google Authenticator Code"] ?? "Enter Google Authenticator Code"}",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                contentPadding: EdgeInsets.only(
                                                    left: 12,
                                                    top: 10,
                                                    bottom: 12),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0), // Set the border radius here
                                                  borderSide: BorderSide
                                                      .none, // Remove the default border
                                                ),
                                                fillColor:
                                                    AppColors.appFillColor,
                                                filled: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      cancel: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors
                                              .red, // Customize the button color
                                        ),
                                        onPressed: () {
                                          Get.back(); // Close the dialog
                                        },
                                        child: Text(
                                          "${selectedLanguageStorage.read("languageData")["Cancel"] ?? "Cancel"}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                      confirm: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors
                                                .appPrimaryColor // Customize the button color
                                            ),
                                        onPressed: () {
                                          twoFaSecurityController
                                              .disableTwoFactorSecurity(
                                            twoFaSecurityController
                                                .googleAuthDisableCode.text
                                                .toString(),
                                          )
                                              .then((value) {
                                            twoFaSecurityController
                                                .googleAuthDisableCode
                                                .text = "";
                                            twoFaSecurityController
                                                .getTwoFaSecurityData();
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text(
                                          "${selectedLanguageStorage.read("languageData")["Disable"] ?? "Disable"}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                    );
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.getContainerBgDarkLight(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "${selectedLanguageStorage.read("languageData")["Google Authenticator"] ?? "Google Authenticator"}",
                              style: TextStyle(
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Center(
                            child: Text(
                              "${selectedLanguageStorage.read("languageData")["USE GOOGLE AUTHENTICATOR TO SCAN THE QR CODE OR USE THE CODE"] ?? "USE GOOGLE AUTHENTICATOR TO SCAN THE QR CODE OR USE THE CODE"}",
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Center(
                            child: Text(
                              "${selectedLanguageStorage.read("languageData")["Google Authenticator is a multifactor app for mobile devices. It generates timed codes used during the 2-step verification process. To use Google Authenticator, install the Google Authenticator application on your mobile device."] ?? "Google Authenticator is a multifactor app for mobile devices. It generates timed codes used during the 2-step verification process. To use Google Authenticator, install the Google Authenticator application on your mobile device."}",
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppCustomButton(
                                titleColor: AppColors.appWhiteColor,
                                title:
                                    "${selectedLanguageStorage.read("languageData")["Download App"] ?? "Download App"}",
                                height: 50.h,
                                borderRadius: 32.00,
                                width: double.infinity,
                                onTap: () {
                                  launchPlayStore();
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: CircularProgressIndicator(),
                ),
              ),
      );
    });
  }

  Future<void> launchPlayStore() async {
    final url =
        'https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en&gl=US';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

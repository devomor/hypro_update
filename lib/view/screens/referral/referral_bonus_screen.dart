import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/referral_bonus_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class ReferralBonusScreen extends StatelessWidget {
  static const String routeName = "/referralBonusScreen";
  ReferralBonusScreen({super.key});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Format the selected date to "mm/dd/yyyy" format
      String formattedDate = "${picked.year}-${picked.month}-${picked.day}";
      Get.find<ReferralBonusController>().setDate(formattedDate);
    }
  }

  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReferralBonusController>(
        builder: (referralBonusController) {
      return RefreshIndicator(
        onRefresh: () async {
          Get.find<ReferralBonusController>()
              .getReferralBonusSearchData("", "", page: 1);
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
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      "assets/images/arrow_back_btn.png",
                      height: 20.h,
                      width: 20.w,
                      color: AppColors.getTextDarkLight(),
                    )),
                Text(
                  "${selectedLanguageStorage.read("languageData")["Referral Bonus"] ?? "Referral Bonus"}",
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
                          elevation: 5,
                          type: MaterialType.transparency,
                          child: GetBuilder<ReferralBonusController>(
                              builder: (referralBonusController) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Get.isDarkMode
                                          ? AppColors.appContainerBgColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
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
                                                  color:
                                                      AppColors.appBlackColor50,
                                                ))),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        TextFormField(
                                          controller: Get.find<
                                                  ReferralBonusController>()
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
                                                  "${selectedLanguageStorage.read("languageData")["Search User"] ?? "Search User"}",
                                              hintStyle: GoogleFonts.niramit(
                                                color:
                                                    AppColors.appBlackColor50,
                                                fontSize: 15.sp,
                                              )),
                                        ),
                                        SizedBox(
                                          height: 16.h,
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          onTap: () => _selectDate(context),
                                          controller: TextEditingController(
                                              text: Get.find<
                                                      ReferralBonusController>()
                                                  .selectedDate
                                                  .value),
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      top: 15, left: 10),
                                              filled: true,
                                              fillColor: AppColors
                                                  .getTextFieldDarkLight(),
                                              border: InputBorder.none,
                                              hintText:
                                                  "${selectedLanguageStorage.read("languageData")["Select Date"] ?? "Select Date"}",
                                              suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    referralBonusController
                                                        .setDate("");
                                                  },
                                                  child: referralBonusController
                                                          .selectedDate
                                                          .isNotEmpty
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  16.0.h),
                                                          child: Text(
                                                            "${selectedLanguageStorage.read("languageData")["Clear"] ?? "Clear"}",
                                                            style: GoogleFonts
                                                                .niramit(
                                                              color: AppColors
                                                                  .appBlackColor50,
                                                              fontSize: 15.sp,
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox
                                                          .shrink()),
                                              hintStyle: GoogleFonts.niramit(
                                                color:
                                                    AppColors.appBlackColor50,
                                                fontSize: 15.sp,
                                              )),
                                        ),
                                        SizedBox(
                                          height: 24.h,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            Get.find<ReferralBonusController>()
                                                .referralBonusItems
                                                .clear();
                                            Get.find<ReferralBonusController>()
                                                .getReferralBonusSearchData(
                                              Get.find<
                                                      ReferralBonusController>()
                                                  .name
                                                  .text
                                                  .toString(),
                                              Get.find<
                                                      ReferralBonusController>()
                                                  .selectedDate
                                                  .value,
                                            );
                                          },
                                          child: Container(
                                            height: 45.h,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color:
                                                    AppColors.appPrimaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Center(
                                                child: Text(
                                              "${selectedLanguageStorage.read("languageData")["Search"] ?? "Search"}",
                                              style: GoogleFonts.niramit(
                                                  fontSize: 20.sp,
                                                  color:
                                                      AppColors.appWhiteColor,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        );
                      },
                    );
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
            children: [
              SizedBox(
                height: 12.h,
              ),
              GetBuilder<ReferralBonusController>(
                builder: (referralBonusController) {
                  final historyItems =
                      referralBonusController.referralBonusItems;

                  if (referralBonusController.isLoading == true &&
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
                    );
                  } else {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          referralBonusController.referralBonusItems.length +
                              (referralBonusController.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index <
                            referralBonusController.referralBonusItems.length) {
                          final item =
                              referralBonusController.referralBonusItems[index];
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: 12.h, left: 24.w, right: 24.w),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Get.isDarkMode
                                      ? AppColors.appContainerBgColor
                                      : AppColors.appFillColor,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: 48.h,
                                        width: 48.w,
                                        decoration: BoxDecoration(
                                            color: Get.isDarkMode
                                                ? AppColors.appDefaultDarkMode
                                                : AppColors.appWhiteColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Image.asset(
                                            "assets/images/refer_bonus_img.png",
                                            height: 16.h,
                                            width: 16.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16.w,
                                    ),
                                    Expanded(
                                      flex: 20,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${item.bonusFrom}",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.publicSans(
                                                    fontSize: 16.sp,
                                                    color: AppColors
                                                        .getTextDarkLight(),
                                                    height: 1.5,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                "${item.amount}",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.publicSans(
                                                    fontSize: 16.sp,
                                                    color: AppColors
                                                        .getTextDarkLight(),
                                                    height: 1.5,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 6.h,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Text(
                                              "${item.remarks}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: GoogleFonts.publicSans(
                                                  fontSize: 14.sp,
                                                  color:
                                                      AppColors.appBlackColor50,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4.h,
                                          ),
                                          Text(
                                            "${item.time}",
                                            style: GoogleFonts.publicSans(
                                                fontSize: 14.sp,
                                                color:
                                                    AppColors.appBlackColor50,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          // Display loading indicator only if isLoading is true
                          if (referralBonusController.isLoading) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: CircularProgressIndicator(
                                  color: AppColors.appPrimaryColor,
                                ),
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
      );
    });
  }
}

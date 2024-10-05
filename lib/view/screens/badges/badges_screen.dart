import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/badges_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class BadgesScreen extends StatelessWidget {
  static const String routeName = "/badgesScreen";
  BadgesScreen({super.key});

  List<Color> colors = [
    Color(0xffF3FAFC),
    Color(0xffECF8F7),
    Color(0xffF9E3FF),
    Color(0xffE1ECFA),
  ];

  List<Color> circleColors = [
    Color(0xffF9E3FF),
    Color(0xffE1ECFA),
    Color(0xffECF8F7),
    Color(0xffFFF0DD),
  ];

  // Function to get a random color from the remaining colors in the list
  Color getRandomColor(int index) {
    if (index < colors.length) {
      return colors[index];
    } else {
      return Color((index * 10).hashCode);
    }
  }

  Color getRandomCircleColor(int index) {
    if (index < circleColors.length) {
      return circleColors[index];
    } else {
      return Color((index * 10).hashCode);
    }
  }

  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BadgesController>(
      builder: (badgesController) {
        return RefreshIndicator(
          onRefresh: () async {
            badgesController.getBadgesData();
          },
          child: Scaffold(
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
                "${selectedLanguageStorage.read("languageData")["All Badges"] ?? "All Badges"}",
                style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  color: AppColors.getTextDarkLight(),
                ),
              ),
            ),
            body: badgesController.isLoading == false &&
                    badgesController.message != null
                ? ListView(
                    children: [
                      SizedBox(height: 24.h),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: badgesController.message!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: 20,
                              left: 24,
                              right: 24,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 165.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: badgesController.message![index]
                                                .isCurrentRank !=
                                            true
                                        ? Get.isDarkMode
                                            ? AppColors.appContainerBgColor
                                            : AppColors.appFillColor
                                        : AppColors.appPrimaryColor,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: 20.h,
                                      left: 20.w,
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          right: -41,
                                          bottom: -50,
                                          child: Container(
                                            height: 175.h,
                                            width: 175.w,
                                            decoration: BoxDecoration(
                                              color: index < 4
                                                  ? colors[index]
                                                  : getRandomColor(index - 4),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: index < 4
                                                    ? circleColors[index]
                                                    : getRandomCircleColor(
                                                        index - 4),
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: -45,
                                          bottom: -45,
                                          child: Container(
                                            height: 168.h,
                                            width: 168.w,
                                            decoration: BoxDecoration(
                                              color: index < 4
                                                  ? circleColors[index]
                                                  : getRandomCircleColor(
                                                      index - 4),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 20.w,
                                          top: 52.h,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                "${badgesController.message![index].rankIcon}",
                                                height: 60.h,
                                                width: 60.w,
                                              ),
                                              Text(
                                                  "${badgesController.message![index].rankLavel}",
                                                  style: GoogleFonts.niramit(
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .appBlackColor60)),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${badgesController.message![index].description}",
                                              style: GoogleFonts.niramit(
                                                fontSize: 18.sp,
                                                color: badgesController
                                                            .message![index]
                                                            .isCurrentRank !=
                                                        true
                                                    ? AppColors
                                                        .getTextDarkLight()
                                                    : AppColors.appWhiteColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: 16.h),
                                            Row(
                                              children: [
                                                Text(
                                                  "${selectedLanguageStorage.read("languageData")["Minimum Invest:"] ?? "Minimum Invest:"}",
                                                  style: GoogleFonts.niramit(
                                                    fontSize: 16.sp,
                                                    color: badgesController
                                                                .message![index]
                                                                .isCurrentRank !=
                                                            true
                                                        ? AppColors
                                                            .appBlackColor50
                                                        : AppColors
                                                            .appWhiteColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  "${badgesController.message![index].minInvest}",
                                                  style: GoogleFonts.niramit(
                                                    fontSize: 16.sp,
                                                    color: badgesController
                                                                .message![index]
                                                                .isCurrentRank !=
                                                            true
                                                        ? AppColors
                                                            .appBlackColor50
                                                        : AppColors
                                                            .appWhiteColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6.h),
                                            Row(
                                              children: [
                                                Text(
                                                  "${selectedLanguageStorage.read("languageData")["Minimum Deposit:"] ?? "Minimum Deposit:"}",
                                                  style: GoogleFonts.niramit(
                                                    fontSize: 16.sp,
                                                    color: badgesController
                                                                .message![index]
                                                                .isCurrentRank !=
                                                            true
                                                        ? AppColors
                                                            .appBlackColor50
                                                        : AppColors
                                                            .appWhiteColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  "${badgesController.message![index].minDeposit}",
                                                  style: GoogleFonts.niramit(
                                                    fontSize: 16.sp,
                                                    color: badgesController
                                                                .message![index]
                                                                .isCurrentRank !=
                                                            true
                                                        ? AppColors
                                                            .appBlackColor50
                                                        : AppColors
                                                            .appWhiteColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6.h),
                                            Row(
                                              children: [
                                                Text(
                                                  "${selectedLanguageStorage.read("languageData")["Minimum Earning:"] ?? "Minimum Earning:"}",
                                                  style: GoogleFonts.niramit(
                                                    fontSize: 16.sp,
                                                    color: badgesController
                                                                .message![index]
                                                                .isCurrentRank !=
                                                            true
                                                        ? AppColors
                                                            .appBlackColor50
                                                        : AppColors
                                                            .appWhiteColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  "${badgesController.message![index].minEarning}",
                                                  style: GoogleFonts.niramit(
                                                    fontSize: 16.sp,
                                                    color: badgesController
                                                                .message![index]
                                                                .isCurrentRank !=
                                                            true
                                                        ? AppColors
                                                            .appBlackColor50
                                                        : AppColors
                                                            .appWhiteColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: AppColors.appPrimaryColor,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

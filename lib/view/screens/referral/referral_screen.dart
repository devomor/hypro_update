import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hypro/controller/referral_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReferralScreen extends StatefulWidget {
  static const String routeName = "/referralScreen";
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final PageController _pageController = PageController();
  int selectedIndex = 0;

  List<bool> selectedIndexColor = List.generate(7, (index) => false);
  int selectedButtonIndex = -1;

  String formatApiDate(String apiDate) {
    // Parse the API response date
    DateTime dateTime = DateTime.parse(apiDate);

    // Format it as 'dd MMM, yyyy h.mm a'
    String formattedDate = DateFormat('dd MMM, yyyy h.mm a').format(dateTime);

    return formattedDate;
  }

  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReferralController>(builder: (referralController) {
      return RefreshIndicator(
        onRefresh: () async {
          Get.find<ReferralController>().getReferralData();
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
                "${selectedLanguageStorage.read("languageData")["My Referral"] ?? "My Referral"}",
                style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  color: AppColors.getTextDarkLight(),
                ),
              ),
            ),
            body: referralController.isLoading == false &&
                    referralController.message != null
                ? ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.getContainerBgDarkLight(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "${selectedLanguageStorage.read("languageData")["Referral Link"] ?? "Referral Link"}",
                                    style: GoogleFonts.niramit(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp,
                                        color: AppColors.getTextDarkLight()),
                                  ),
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                Container(
                                  height: 72.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Get.isDarkMode
                                        ? AppColors.appContainerBgColor
                                        : AppColors.appFillColor,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Get.isDarkMode
                                                ? AppColors.appContainerBgColor
                                                : AppColors.appFillColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 16.h,
                                                bottom: 16.w,
                                                left: 16.w),
                                            child: Text(
                                              "${referralController.message!.referralLink}",
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                              text:
                                                  "${referralController.message!.referralLink}"));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                backgroundColor: AppColors
                                                    .appDashBoardTransactionGreen,
                                                content: Text(
                                                  'Text copied to clipboard',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 16,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: AppColors.appWhiteColor,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(8),
                                                )),
                                            child: Icon(
                                              Icons.copy_sharp,
                                              color: AppColors.appPrimaryColor,
                                              size: 20.h,
                                            ),
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 56.h,
                        width: double.infinity,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                referralController.message!.referrals!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return referralController
                                      .message!.referrals!["1"]!.isEmpty
                                  ? SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (selectedButtonIndex == index) {
                                              // Deselect the button
                                              selectedButtonIndex = -1;
                                            } else {
                                              // Select the button at the tapped index
                                              selectedButtonIndex = index;
                                            }
                                            selectedIndex = index;
                                            _pageController.jumpToPage(index);
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          child: Container(
                                              height: 35,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Get.isDarkMode
                                                          ? AppColors
                                                              .appPrimaryColor
                                                              .withOpacity(0.1)
                                                          : AppColors
                                                              .appPrimaryColor
                                                              .withOpacity(0.1),
                                                      offset:
                                                          const Offset(0, 4),
                                                      blurRadius: 0,
                                                      spreadRadius: 0,
                                                    ),
                                                  ],
                                                  border: Border.all(
                                                    color: selectedIndex !=
                                                            index
                                                        ? AppColors
                                                            .appPrimaryColor
                                                        : AppColors
                                                            .appPrimaryColor,
                                                  ),
                                                  color: selectedIndex != index
                                                      ? AppColors.appWhiteColor
                                                      : AppColors
                                                          .appPrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                  child: Text(
                                                "${selectedLanguageStorage.read("languageData")["Level"] ?? "Level"} ${index + 1}",
                                                style: GoogleFonts.niramit(
                                                    color:
                                                        selectedIndex != index
                                                            ? Colors.black
                                                            : Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15.sp),
                                              ))),
                                        ),
                                      ),
                                    );
                            }),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      referralController.isLoading == false &&
                              referralController.message != null
                          ? referralController.message!.referrals!["1"]!.isEmpty
                              ? Center(
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Get.isDarkMode
                                            ? Image.asset(
                                                "assets/images/dark_no_data_found.png",
                                                height: 200.h,
                                                width: 200.w,
                                              )
                                            : Image.asset(
                                                "assets/images/no_data_found.png",
                                                height: 200.h,
                                                width: 200.w,
                                              ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 24),
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
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .8,
                                  width: 360.w,
                                  child: PageView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: _pageController,
                                    itemCount: referralController
                                        .message!.referrals!.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, referralIndex) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 6),
                                        child: SizedBox(
                                          width: 360,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: referralController
                                                .message!
                                                .referrals![
                                                    "${referralIndex + 1}"]!
                                                .length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 16.h),
                                                child: Container(
                                                  width: 360,
                                                  decoration: BoxDecoration(
                                                    color: Get.isDarkMode
                                                        ? AppColors
                                                            .appContainerBgColor
                                                        : AppColors
                                                            .appBrandColor3,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16,
                                                            top: 10,
                                                            bottom: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Container(
                                                                height: 52.h,
                                                                width: 50.w,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors
                                                                      .appWhiteColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Center(
                                                                    child:
                                                                        Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "${referralIndex + 1}",
                                                                      style: GoogleFonts.publicSans(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          fontWeight: FontWeight
                                                                              .w800,
                                                                          color:
                                                                              AppColors.appBlackColor50),
                                                                    ),
                                                                    Text(
                                                                      "${selectedLanguageStorage.read("languageData")["Level"] ?? "Level"}",
                                                                      style: GoogleFonts.publicSans(
                                                                          fontSize: 12
                                                                              .sp,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              AppColors.appBlackColor50),
                                                                    ),
                                                                  ],
                                                                )),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 12.w,
                                                            ),
                                                            Expanded(
                                                              flex: 7,
                                                              child: Container(
                                                                height: 70,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              12,
                                                                          left:
                                                                              4),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "${referralController.message!.referrals!["${referralIndex + 1}"]![index].email}",
                                                                            style: GoogleFonts.niramit(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 16.sp,
                                                                                color: AppColors.getTextDarkLight()),
                                                                          ),
                                                                          Text(
                                                                            "${selectedLanguageStorage.read("languageData")["Joined At"] ?? "Joined At"}",
                                                                            style: GoogleFonts.niramit(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 16.sp,
                                                                                color: AppColors.appBlackColor50),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          6.h,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              12,
                                                                          left:
                                                                              4),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "${referralController.message!.referrals!["${referralIndex + 1}"]![index].username}",
                                                                            style: GoogleFonts.niramit(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 16.sp,
                                                                                color: AppColors.appBlackColor50),
                                                                          ),
                                                                          Text(
                                                                            "${formatApiDate(referralController.message!.referrals!["${referralIndex + 1}"]![index].createdAt.toString())}",
                                                                            style: GoogleFonts.niramit(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 14.sp,
                                                                                color: AppColors.getTextDarkLight()),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                          : const SizedBox()
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: AppColors.appPrimaryColor,
                    ),
                  )),
      );
    });
  }
}

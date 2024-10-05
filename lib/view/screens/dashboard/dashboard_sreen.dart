import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/dashboard_controller.dart';
import 'package:flutter_hypro/controller/notification_controller.dart';
import 'package:flutter_hypro/game/aviator_game.dart';
import 'package:flutter_hypro/game/circle_and_aviator_controller.dart';
import 'package:flutter_hypro/game/game_controller.dart';
import 'package:flutter_hypro/game/spine_screen.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/view/screens/notification/notification_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../widgets/app_drawer_widget.dart';

class DashBoardScreen extends StatefulWidget {
  static const String routeName = "/dashBoardScreen";
  DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String formatApiDate(String apiDate) {
    // Parse the API response date
    DateTime dateTime = DateTime.parse(apiDate);

    // Format it as 'dd MMM, yyyy h.mm a'
    String formattedDate = DateFormat('dd MMM, yyyy h.mm a').format(dateTime);

    return formattedDate;
  }

  final selectedLanguageStorage = GetStorage();

  final controller = Get.put(RouletteControllers());
  final gameController = Get.put(CirleAndAviatorContoller());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getSpinData();
    gameController.initSharedPreferences();
    gameController.getBalance();
    gameController.fetchGameSettings();
    gameController.fetchGameSettingsAviator();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(builder: (dashBoardController) {
      return RefreshIndicator(
        onRefresh: () async {
          dashBoardController.getDashBoardData();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: AppColors.getAppBarBgDarkLight(),
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Image.asset(
                      "assets/images/menu.png",
                      height: 28.h,
                      width: 28.w,
                    )),
                InkWell(onTap: () {
                  Get.toNamed(NotificationScreen.routeName);
                }, child: GetBuilder<NotificationController>(
                    builder: (notificationController) {
                  return Stack(
                    children: [
                      Image.asset(
                        "assets/images/notification_icon.png",
                        height: 26.h,
                        width: 26.w,
                      ),
                      notificationController.eventCount.value > 1
                          ? Positioned(
                              top: 0,
                              right: 5,
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 4,
                              ))
                          : const SizedBox.shrink(),
                    ],
                  );
                }))
              ],
            ),
          ),
          key: _scaffoldKey,
          drawer: appDrawer(),
          backgroundColor: AppColors.getBackgroundDarkLight(),
          body: ListView(
            children: [
              Container(
                height: 90,
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // showSnackBar
                     Obx(() {
                        if (gameController.gameActiveA.value == 1.0) {
                          return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AviatorGameScreen()));
                      },
                      child: Container(
                        height: 85.h,
                        width: 182.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Get.isDarkMode
                                ? AppColors.appContainerBgColor
                                : AppColors.appBg3),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/aviator_game.png",
                                height: 44.h,
                                width: 44.w,
                              ),
                              SizedBox(
                                width: 16.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Aviator \nGame",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.publicSans(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.getTextDarkLight()),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                        }else if(gameController.gameActive.value == 0.0)
                        {
                          return InkWell(
                      onTap: () {
                        showSnackBar(
                                context, 'current game is not available');
                      },
                      child: Container(
                        height: 85.h,
                        width: 182.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Get.isDarkMode
                                ? AppColors.appContainerBgColor
                                : AppColors.appBg3),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/aviator_game.png",
                                height: 44.h,
                                width: 44.w,
                              ),
                              SizedBox(
                                width: 16.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Aviator \nGame",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.publicSans(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.getTextDarkLight()),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                        }else{
                          return Container(
                        height: 85.h,
                        width: 182.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Get.isDarkMode
                                ? AppColors.appContainerBgColor
                                : AppColors.appBg3),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/aviator_game.png",
                                height: 44.h,
                                width: 44.w,
                              ),
                              SizedBox(
                                width: 16.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Aviator \nGame",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.publicSans(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.getTextDarkLight()),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                        }

                     }),




                    
                    SizedBox(
                      width: 12,
                    ),
                    Obx(() {
                      if (gameController.gameActive.value == 1.0) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => SpineScreen()),
                            );
                          },
                          child: Container(
                            height: 85.h,
                            width: 182.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Get.isDarkMode
                                  ? AppColors.appContainerBgColor
                                  : AppColors.appBg3,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/Spin-the-Wheel.png",
                                    height: 44.h,
                                    width: 44.w,
                                  ),
                                  SizedBox(width: 16.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Spin \nGame",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.publicSans(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.getTextDarkLight(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (gameController.gameActive.value == 0.0) 
                      {
                        return InkWell(
                          onTap: () {
                            showSnackBar(
                                context, 'current game is not available');
                          },
                          child: Container(
                            height: 85.h,
                            width: 182.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Get.isDarkMode
                                  ? AppColors.appContainerBgColor
                                  : AppColors.appBg3,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/Spin-the-Wheel.png",
                                    height: 44.h,
                                    width: 44.w,
                                  ),
                                  SizedBox(width: 16.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Spin \nGame",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.publicSans(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.getTextDarkLight(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ); // Empty space to avoid UI glitch
                      } else {
                        return Container(
                          height: 85.h,
                          width: 182.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Get.isDarkMode
                                ? AppColors.appContainerBgColor
                                : AppColors.appBg3,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/Spin-the-Wheel.png",
                                  height: 44.h,
                                  width: 44.w,
                                ),
                                SizedBox(width: 16.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Spin \nGame",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.publicSans(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.getTextDarkLight(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ); // Empty space or loading state
                      }
                    })
                  ],
                ),
              ),

              // Container(
              //   child:
              //   Stack(
              //     alignment: Alignment.center,
              //     children: [CustomSpinWheel()],
              //   ),
              // ),
              // SizedBox(height: 20,),
              //
              // OutlinedButton(onPressed: (){
              //   controller.play();
              // }, child: Text("button")),

              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: dashBoardController.isLoading == false &&
                          dashBoardController.message != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 16, left: 10, right: 16, bottom: 16),
                              decoration: BoxDecoration(
                                  color: Get.isDarkMode
                                      ? AppColors.appContainerBgColor
                                      : AppColors.appBrandColor3,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: CircularPercentIndicator(
                                      reverse: true,
                                      radius: 45.0,
                                      lineWidth: 10.0,
                                      percent: dashBoardController
                                              .message!.investComplete /
                                          100.toInt(),
                                      center: Text(
                                          "${dashBoardController.message!.investComplete}%",
                                          style: GoogleFonts.publicSans(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors
                                                  .getTextDarkLight())),
                                      progressColor: AppColors.appBrandDeep,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  Expanded(
                                      flex: 9,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${selectedLanguageStorage.read("languageData")["Invest Completed"] ?? "Invest Completed"}",
                                            style: GoogleFonts.publicSans(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20.sp,
                                                color: AppColors
                                                    .getTextDarkLight()),
                                          ),
                                          SizedBox(
                                            height: 4.h,
                                          ),
                                          Text(
                                            "${selectedLanguageStorage.read("languageData")["Investment banking is a special segment of banking operation."] ?? "Investment banking is a special segment of banking operation."}",
                                            style: GoogleFonts.niramit(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16.sp,
                                                height: 1.2,
                                                color:
                                                    AppColors.appBlackColor50),
                                          ),
                                          SizedBox(
                                            height: 4.h,
                                          ),
                                          Text(
                                            "${selectedLanguageStorage.read("languageData")["Investment Platform"] ?? "Investment Platform"}",
                                            style: GoogleFonts.niramit(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16.sp,
                                                color: AppColors
                                                    .getTextDarkLight()),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 117.w,
                                  decoration: BoxDecoration(
                                      color: Get.isDarkMode
                                          ? AppColors.appContainerBgColor
                                          : AppColors.appBrandColor3,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 22.h, left: 16.w, bottom: 22.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          height: 44.h,
                                          width: 44.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: AppColors
                                                  .appMainBalanceIconColor),
                                          child: Image.asset(
                                            "assets/images/main_balance.png",
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Text(
                                          "${dashBoardController.dashBoardModel.message!.currency}${dashBoardController.dashBoardModel.message!.mainBalance!.toStringAsFixed(2)}",
                                          style: GoogleFonts.publicSans(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  AppColors.getTextDarkLight()),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Text(
                                          "${selectedLanguageStorage.read("languageData")["Main Balance"] ?? "Main Balance"}",
                                          style: GoogleFonts.niramit(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.appBlackColor50),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 117.w,
                                  decoration: BoxDecoration(
                                      color: Get.isDarkMode
                                          ? AppColors.appContainerBgColor
                                          : AppColors.appBrandColor2,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 22.h, left: 16.w, bottom: 22.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          height: 44.h,
                                          width: 44.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: AppColors
                                                  .appTotalDepositIconColor),
                                          child: Image.asset(
                                            "assets/images/total_deposit.png",
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Text(
                                          "${dashBoardController.dashBoardModel.message!.currency}${dashBoardController.dashBoardModel.message!.totalDeposit!.toStringAsFixed(2)}",
                                          style: GoogleFonts.publicSans(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  AppColors.getTextDarkLight()),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Text(
                                          "${selectedLanguageStorage.read("languageData")["Total Deposit"] ?? "Total Deposit"}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.niramit(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.appBlackColor50),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 117.w,
                                  decoration: BoxDecoration(
                                      color: Get.isDarkMode
                                          ? AppColors.appContainerBgColor
                                          : AppColors.appBg2,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 22.h, left: 16.w, bottom: 22.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          height: 44.h,
                                          width: 44.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: AppColors
                                                  .appTotalEarnIconColor),
                                          child: Image.asset(
                                            "assets/images/total_earn.png",
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Text(
                                          "${dashBoardController.dashBoardModel.message!.currency}${dashBoardController.dashBoardModel.message!.totalEarn!.toStringAsFixed(2)}",
                                          style: GoogleFonts.publicSans(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  AppColors.getTextDarkLight()),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Text(
                                          "${selectedLanguageStorage.read("languageData")["Total Earn"] ?? "Total Earn"}",
                                          style: GoogleFonts.niramit(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.appBlackColor50),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 181.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Get.isDarkMode
                                          ? AppColors.appContainerBgColor
                                          : AppColors.appBg3),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 24.h, left: 16.w, bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 68.h,
                                          width: 68.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: AppColors
                                                  .appTotalInvestIconColor),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Image.asset(
                                              "assets/images/total_invest_bg.png",
                                              height: 18.h,
                                              width: 18.w,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 24.h,
                                        ),
                                        Text(
                                          dashBoardController
                                                      .dashBoardModel
                                                      .message!
                                                      .roi!
                                                      .totalInvestAmount !=
                                                  null
                                              ? "${dashBoardController.dashBoardModel.message!.currency}${dashBoardController.dashBoardModel.message!.roi!.totalInvestAmount!}"
                                              : "${dashBoardController.dashBoardModel.message!.currency}0.00",
                                          style: GoogleFonts.publicSans(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  AppColors.getTextDarkLight()),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Text(
                                          "${selectedLanguageStorage.read("languageData")["Total Invest"] ?? "Total Invest"}",
                                          style: GoogleFonts.niramit(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.appBlackColor50),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 85.h,
                                      width: 182.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Get.isDarkMode
                                            ? AppColors.appContainerBgColor
                                            : AppColors.appBrandColor2,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              height: 44.h,
                                              width: 44.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: AppColors
                                                      .appTotalPayoutIconColor),
                                              child: Image.asset(
                                                "assets/images/total_payout.png",
                                              ),
                                            ),
                                            SizedBox(
                                              width: 16.w,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${dashBoardController.dashBoardModel.message!.totalPayout}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.publicSans(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors
                                                          .getTextDarkLight()),
                                                ),
                                                SizedBox(
                                                  height: 4.h,
                                                ),
                                                Text(
                                                  "${selectedLanguageStorage.read("languageData")["Total Payout"] ?? "Total Payout"}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.niramit(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .appBlackColor50),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 14.h,
                                    ),
                                    Container(
                                      height: 85.h,
                                      width: 182.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Get.isDarkMode
                                              ? AppColors.appContainerBgColor
                                              : AppColors.appBrandColor3),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              height: 44.h,
                                              width: 44.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: AppColors
                                                      .appTotalTicketIconColor),
                                              child: Image.asset(
                                                "assets/images/total_ticket.png",
                                              ),
                                            ),
                                            SizedBox(
                                              width: 16.w,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${dashBoardController.dashBoardModel.message!.ticket}",
                                                  style: GoogleFonts.publicSans(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors
                                                          .getTextDarkLight()),
                                                ),
                                                SizedBox(
                                                  height: 4.h,
                                                ),
                                                Text(
                                                  "${selectedLanguageStorage.read("languageData")["Total Ticket"] ?? "Total Ticket"}",
                                                  style: GoogleFonts.niramit(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .appBlackColor50),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${selectedLanguageStorage.read("languageData")["Recent Transaction"] ?? "Recent Transaction"}",
                                  style: GoogleFonts.publicSans(
                                      color: AppColors.getTextDarkLight(),
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600),
                                ),

                                // Text("${selectedLanguageStorage.read("languageData")["See All"]??"See All"}",style: GoogleFonts.publicSans(
                                //   color: AppColors.getTextDarkLight(),
                                //   fontSize: 16.sp,
                                //   fontWeight: FontWeight.w400
                                // ),),
                              ],
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            dashBoardController.dashBoardModel.message!
                                    .transaction!.isNotEmpty
                                ? ListView.builder(
                                    itemCount: dashBoardController
                                        .dashBoardModel
                                        .message!
                                        .transaction!
                                        .length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 12.h),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Get.isDarkMode
                                                  ? AppColors
                                                      .appContainerBgColor
                                                  : AppColors
                                                      .appTransactionCardColor,
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 40.h,
                                                        width: 40.w,
                                                        decoration: BoxDecoration(
                                                            color: dashBoardController
                                                                        .dashBoardModel
                                                                        .message!
                                                                        .transaction![
                                                                            index]
                                                                        .trxType ==
                                                                    "+"
                                                                ? AppColors
                                                                    .appDashBoardTransactionGreen
                                                                : AppColors
                                                                    .appDashBoardTransactionRed,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: dashBoardController
                                                                      .dashBoardModel
                                                                      .message!
                                                                      .transaction![
                                                                          index]
                                                                      .trxType ==
                                                                  "+"
                                                              ? Image.asset(
                                                                  "assets/images/transaction_down.png",
                                                                  height: 16.h,
                                                                  width: 16.w,
                                                                )
                                                              : Image.asset(
                                                                  "assets/images/transaction_up.png",
                                                                  height: 16.h,
                                                                  width: 16.w,
                                                                ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 12.w,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 16.h,
                                                                  bottom: 16.h),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "${dashBoardController.dashBoardModel.message!.transaction![index].remarks}",
                                                                style: GoogleFonts.publicSans(
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: AppColors
                                                                        .getTextDarkLight(),
                                                                    height: 1.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                height: 6.h,
                                                              ),
                                                              Text(
                                                                "${formatApiDate(dashBoardController!.dashBoardModel.message!.transaction![index].time.toString())}",
                                                                style: GoogleFonts.publicSans(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: AppColors
                                                                        .appBlackColor50,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Center(
                                                  child: dashBoardController
                                                              .dashBoardModel
                                                              .message!
                                                              .transaction![
                                                                  index]
                                                              .trxType ==
                                                          "+"
                                                      ? Text(
                                                          "${dashBoardController.dashBoardModel.message!.transaction![index].trxType} ${dashBoardController.dashBoardModel.message!.currency}${dashBoardController.dashBoardModel.message!.transaction![index].amount}",
                                                          style: GoogleFonts
                                                              .publicSans(
                                                                  fontSize:
                                                                      18.sp,
                                                                  color: AppColors
                                                                      .appDashBoardTransactionGreen,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        )
                                                      : Text(
                                                          "${dashBoardController.dashBoardModel.message!.transaction![index].trxType} ${dashBoardController.dashBoardModel.message!.currency}${dashBoardController.dashBoardModel.message!.transaction![index].amount}",
                                                          style: GoogleFonts
                                                              .publicSans(
                                                                  fontSize:
                                                                      18.sp,
                                                                  color: AppColors
                                                                      .appDashBoardTransactionRed,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Get.isDarkMode
                                              ? Image.asset(
                                                  "assets/images/dark_no_data_found.png",
                                                  height: 150.h,
                                                  width: 150.w,
                                                )
                                              : Image.asset(
                                                  "assets/images/no_data_found.png",
                                                  height: 150.h,
                                                  width: 150.w,
                                                ),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: Text(
                                              "${selectedLanguageStorage.read("languageData")["No data found."] ?? "No data found."}",
                                              style: GoogleFonts.publicSans(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18.sp,
                                                color:
                                                    AppColors.appBlackColor50,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: 30.h,
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.appPrimaryColor,
                            ),
                          ),
                        ))
            ],
          ),
        ),
      );
    });
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration:
          Duration(seconds: 3), // Set how long the Snackbar will be visible
      action: SnackBarAction(
        label: 'Undo', // Optional action button
        onPressed: () {
          // Perform some action when "Undo" is pressed
        },
      ),
    );

    // Show the Snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

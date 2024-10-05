import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/app_steps_controller.dart';
import 'package:flutter_hypro/data/model/response_model/app_steps_model.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = "/onboardingScreen";
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _controller = PageController();

  List<Steps> _steps = [];

  @override
  void initState() {
    Get.find<AppStepsController>().getAppStepsData().then((value) {
      setState(() {
        _steps = Get.find<AppStepsController>().message?.steps ?? [];
      });
    });
    super.initState();
  }

  _onChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppStepsController>(builder: (appStepsController) {
      return Scaffold(
        backgroundColor: AppColors.getBackgroundDarkLight(),
        body: appStepsController.isLoading == false
            ? Stack(
                children: <Widget>[
                  PageView.builder(
                    scrollDirection: Axis.horizontal,
                    onPageChanged: _onChanged,
                    controller: _controller,
                    itemCount: _steps.length,
                    itemBuilder: (context, int index) {
                      return Padding(
                        padding:
                            EdgeInsets.only(top: 50.h, left: 20.w, right: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 90.h),
                              child: Center(
                                child: Image.network(
                                  _steps[index].image.toString(),
                                  height: 332.h,
                                  width: 332.w,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 60.h),
                              child: Center(
                                child: Text(
                                  _steps[index].title.toString(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.publicSans(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.getTextDarkLight(),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16.h),
                              child: Center(
                                child: Text(
                                  _steps[index].description.toString(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.niramit(
                                    fontSize: 16.sp,
                                    height: 1.2,
                                    color: AppColors.appBlackColor50,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  _currentPage != (_steps.length - 1)
                      ? Positioned(
                          top: 60.h,
                          right: 30.w,
                          child: InkWell(
                              onTap: () {
                                Get.toNamed(LoginScreen.routeName);
                              },
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "Skip",
                                    style: GoogleFonts.publicSans(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.appPrimaryColor,
                                    ),
                                  ))),
                        )
                      : const SizedBox.shrink(),
                  Positioned(
                    bottom: 60.h,
                    left: 0.w,
                    right: 0.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<Widget>.generate(_steps.length,
                                (int index) {
                              return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: 10.h,
                                  width: (index == _currentPage) ? 30.w : 16.w,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 24.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: (index == _currentPage)
                                          ? AppColors.appPrimaryColor
                                          : AppColors.appBg1));
                            })),
                        SizedBox(
                          height: 10.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            (_currentPage == (_steps.length - 1))
                                ? Get.offAllNamed(LoginScreen.routeName)
                                : _controller.nextPage(
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.easeInOutQuint);
                          },
                          child: AnimatedContainer(
                              alignment: Alignment.center,
                              duration: const Duration(milliseconds: 300),
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.appBg1,
                              ),
                              child: Image.asset(
                                "assets/images/arrow_right.png",
                                height: 22.h,
                                width: 22.w,
                              )),
                        ),
                        SizedBox(
                          height: 20.h,
                        )
                      ],
                    ),
                  ),
                ],
              )
            : SizedBox.shrink(),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/notification_controller.dart';
import 'package:flutter_hypro/controller/pusher_config_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = "/notificationScreen";
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (notificationController) {
        return Scaffold(
          backgroundColor: AppColors.getBackgroundDarkLight(),
          appBar: AppBar(
            backgroundColor: AppColors.getAppBarBgDarkLight(),
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "${selectedLanguageStorage.read("languageData")["Notifications"] ?? "Notifications"}",
                  style: GoogleFonts.publicSans(
                      color: AppColors.getTextDarkLight(), fontSize: 18.sp),
                ),
                SizedBox(
                  width: 24.w,
                ),
                Row(
                  children: [
                    notificationController.logList.isNotEmpty
                        ? Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                notificationController.clearAllData();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 70.w,
                                ),
                                child: Container(
                                  height: 25,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "${selectedLanguageStorage.read("languageData")["Clear All"] ?? "Clear All"}",
                                      style: GoogleFonts.nunito(
                                        color: AppColors.getTextDarkLight(),
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: AppColors.getBackgroundDarkLight(),
              width: double.infinity,
              height: MediaQuery.of(context).size.height *
                  0.9, // Set the height to half of the screen
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: notificationController.logList.isEmpty
                        ? Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Get.isDarkMode
                                    ? Image.asset(
                                        "assets/images/dark_no_notification.png",
                                        height: 250.h,
                                        width: 250.w,
                                      )
                                    : Image.asset(
                                        "assets/images/no_notification.png",
                                        height: 258,
                                        width: 226.w,
                                      ),
                                SizedBox(
                                  height: 40.h,
                                ),
                                Text(
                                  "No Notifications Yet",
                                  style: GoogleFonts.niramit(
                                      fontSize: 20.sp,
                                      color: AppColors.getTextDarkLight(),
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: Text(
                                    "You have no notification right now.Come back later",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.niramit(
                                        fontSize: 15.sp,
                                        height: 1.4,
                                        color: AppColors.appBlackColor50,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: notificationController.logList.length,
                            itemBuilder: (context, index) {
                              final reversedIndex =
                                  notificationController.logList.length -
                                      1 -
                                      index;
                              final logEntry =
                                  notificationController.logList[reversedIndex];
                              return Dismissible(
                                key: Key(logEntry), // Unique key for each item
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  color: Colors.red,
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                onDismissed: (direction) {
                                  // Remove the item from the list and GetStorage
                                  notificationController.logList
                                      .removeAt(index);
                                  GetStorage().write(
                                      '${Get.find<PusherConfigController>().message!.channel}',
                                      notificationController.logList.toList());
                                },
                                child: ListTile(
                                  title: Container(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {
                                          // Handle the card tap action
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8),
                                                child: Image.asset(
                                                  "assets/images/notification_icon_new.png",
                                                  height: 25.h,
                                                  width: 25.w,
                                                ),
                                              ),
                                              SizedBox(width: 16.w),
                                              Expanded(
                                                child: Text(logEntry,
                                                    style: GoogleFonts.niramit(
                                                        color: AppColors
                                                            .getTextDarkLight(),
                                                        fontSize: 15.sp)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

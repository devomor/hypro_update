import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/ticket_list_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/view/screens/support/create_ticket_screen.dart';
import 'package:flutter_hypro/view/screens/support/ticket_view_reply_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportTicketScreen extends StatelessWidget {
  static const String routeName = "/supportTicketScreen";
  SupportTicketScreen({super.key});

  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Get.find<TicketListController>().getTicketListData(1);
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.appPrimaryColor,
          onPressed: () {
            Get.toNamed(CreateNewTicketScreen.routeName);
          },
          label: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(
                  Icons.add,
                  color: AppColors.appWhiteColor,
                  size: 20.h,
                ),
              ),
              Text(
                "${selectedLanguageStorage.read("languageData")["Create Ticket"] ?? "Create Ticket"}",
                style:
                    TextStyle(color: AppColors.appWhiteColor, fontSize: 14.sp),
              )
            ],
          ),
        ),
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
            "${selectedLanguageStorage.read("languageData")["Support Ticket"] ?? "Support Ticket"}",
            style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: AppColors.getTextDarkLight(),
            ),
          ),
        ),
        body: ListView(
          controller: Get.find<TicketListController>().scrollController,
          children: [
            SizedBox(
              height: 8.h,
            ),
            GetBuilder<TicketListController>(
              builder: (ticketListController) {
                final historyItems = ticketListController.ticketListItems;

                if (ticketListController.isLoading == true &&
                    historyItems.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.appPrimaryColor,
                    ),
                  );
                } else if (historyItems.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 180.h),
                      child: Center(
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
                    ),
                  );
                } else {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: ticketListController.ticketListItems.length +
                        (ticketListController.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < ticketListController.ticketListItems.length) {
                        final item =
                            ticketListController.ticketListItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          child: GestureDetector(
                              onTap: () {
                                Get.to(() => TicketViewReplyScreen(),
                                    arguments: [item.ticket, item.status]);
                              },
                              child: Container(
                                height: 108.h,
                                decoration: Get.isDarkMode
                                    ? BoxDecoration(
                                        color: AppColors.appContainerBgColor)
                                    : BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                "assets/images/ticket_list_bg.png"))),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 16,
                                      top: 0,
                                      bottom: 0,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 58.h,
                                            width: 58.w,
                                            decoration: BoxDecoration(
                                                color: checkStatusColor(
                                                    item.status),
                                                shape: BoxShape.circle),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: Image.asset(
                                                "${checkStatusImage(item.status)}",
                                                height: 28.h,
                                                width: 28.w,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 32.w,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(
                                                  truncateText(
                                                      item.subject, 20),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: GoogleFonts.niramit(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16.sp,
                                                      color: AppColors
                                                          .getTextDarkLight()),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 16.h,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "${selectedLanguageStorage.read("languageData")["Last reply"] ?? "Last reply"} ",
                                                    style: GoogleFonts.niramit(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16.sp,
                                                        color: AppColors
                                                            .appBlackColor50),
                                                  ),
                                                  Text(
                                                    "${item.lastReply}",
                                                    style: GoogleFonts.niramit(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16.sp,
                                                        color: AppColors
                                                            .getTextDarkLight()),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      } else {
                        // Display loading indicator only if isLoading is true
                        if (ticketListController.isLoading) {
                          return SizedBox();
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
  }

  checkStatusColor(dynamic status) {
    if (status == "Open") {
      return AppColors.appTicketOpenColor;
    } else if (status == "Answered") {
      return AppColors.appTicketReplyColor;
    } else if (status == "Replied") {
      return AppColors.appTicketReplyColor;
    } else {
      return AppColors.appTicketCloseColor;
    }
  }

  checkStatusCircleColor(dynamic status) {
    if (status == "Open") {
      return Color(0xff93C3C0);
    } else if (status == "Answered") {
      return AppColors.appPrimaryColor;
    } else if (status == "Replied") {
      return AppColors.appPrimaryColor;
    } else {
      return Color(0xffF87474);
    }
  }

  checkStatusImage(dynamic status) {
    if (status == "Open") {
      return "assets/images/open_ticket.png";
    } else if (status == "Answered") {
      return "assets/images/replied_ticket.png";
    } else if (status == "Replied") {
      return "assets/images/replied_ticket.png";
    } else {
      return "assets/images/close_ticket.png";
    }
  }

  String truncateText(String text, int maxWords) {
    List<String> words = text.split(' ');

    if (words.length <= maxWords) {
      return text;
    }

    // Join the first `maxWords` words and add '...' at the end
    return '${words.take(maxWords).join(' ')}...';
  }
}

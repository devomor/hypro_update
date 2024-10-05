import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/reply_ticket_controller.dart';
import 'package:flutter_hypro/controller/view_ticket_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TicketViewReplyScreen extends StatefulWidget {
  static const String routeName = "/ticketViewReplyScreen";
  const TicketViewReplyScreen({super.key});

  @override
  State<TicketViewReplyScreen> createState() => _TicketViewReplyScreenState();
}

class _TicketViewReplyScreenState extends State<TicketViewReplyScreen> {
  // final List<ChatMessage> messages = [];

  // Receive the passed data using Get.arguments
  String ticketId = Get.arguments[0];
  String ticketStatus = Get.arguments[1];

  final TextEditingController _textController = TextEditingController();

  final selectedLanguageStorage = GetStorage();

  // void _handleSubmitted(String text) {
  //   if (text.isNotEmpty) {
  //     _textController.clear();
  //     setState(() {
  //       messages.add(ChatMessage(text: text, isUser: true));
  //     });
  //   }
  // }

  void _downloadFile(String fileUrl, String fileName) async {
    Dio dio = Dio();
    try {
      var tempDir = await getTemporaryDirectory();
      String savePath = tempDir.path + '/' + fileName;

      await dio.download(fileUrl, savePath);

      if (kDebugMode) {
        print('File downloaded to: $savePath');
      }

      // Open the downloaded file with its associated application
      OpenFile.open(savePath);
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading file: $e');
      }
    }
  }

  final List<String> _fileNames = [];

  FilePickerResult? result;
  List<dynamic> selectedFilePaths = []; // Store all selected file paths

  Future<void> _pickFiles() async {
    // Request storage permission
    final storageStatus = await Permission.storage.request();

    if (storageStatus.isGranted) {
      try {
        result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
        );

        if (result != null) {
          setState(() {
            if (kDebugMode) {
              print(result!.paths);
            }
            _fileNames.addAll(result!.paths.map((path) => path!));
            selectedFilePaths.addAll(result!.paths
                .whereType<String>()); // Add selected paths to the list
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error while picking files: $e");
        }
      }
    }
  }

  @override
  void initState() {
    Get.find<ViewTicketController>().getViewTicketData(ticketId);
    super.initState();
  }

  bool timeVisible = false;

  int selectedIndex = -1;

  changeDateFormat(dynamic time) {
    DateTime dateTime = DateTime.parse(time);
    return DateFormat('d MMM, yy hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ViewTicketController>(builder: (viewTicketController) {
      return RefreshIndicator(
        onRefresh: () async {
          Get.find<ViewTicketController>().getViewTicketData(ticketId);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.getAppBarBgDarkLight(),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColors.getTextDarkLight(),
              ),
            ),
            automaticallyImplyLeading: false,
            titleSpacing: 5,
            elevation: 1,
            title: viewTicketController.isLoading == false &&
                    viewTicketController.message != null
                ? Text(
                    "${viewTicketController.message!.pageTitle ?? ""}",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.getTextDarkLight()),
                  )
                : SizedBox.shrink(),
            actions: [
              ticketStatus != "Closed"
                  ? GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                          titlePadding: EdgeInsets.symmetric(vertical: 10),
                          radius: 10,
                          backgroundColor: AppColors.getContainerBgDarkLight(),
                          titleStyle: GoogleFonts.publicSans(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.appPrimaryColor,
                          ),
                          title:
                              "${selectedLanguageStorage.read("languageData")["Alert!"] ?? "Alert!"}",
                          content: Column(
                            children: [
                              Container(
                                height: 1.h,
                                width: 350.w,
                                color: Get.isDarkMode
                                    ? Colors.white12
                                    : Colors.black12,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Text(
                                "${selectedLanguageStorage.read("languageData")["Do you want to close ticket?"] ?? "Do you want to close ticket?"}",
                                style: GoogleFonts.publicSans(
                                  fontSize: 16.sp,
                                  color: AppColors.getTextDarkLight(),
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                            ],
                          ),
                          actions: [
                            SizedBox(
                              height: 10.h,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Get.back(); // Close the dialog
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.appDashBoardTransactionRed,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "${selectedLanguageStorage.read("languageData")["No"] ?? "No"}",
                                style:
                                    TextStyle(color: AppColors.appWhiteColor),
                              ),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Get.find<ReplyTicketController>()
                                    .ticketReplyRequest(
                                  context,
                                  viewTicketController.message!.id.toString(),
                                  "",
                                  2,
                                );
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.appDashBoardTransactionGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "${selectedLanguageStorage.read("languageData")["Yes"] ?? "Yes"}",
                                style:
                                    TextStyle(color: AppColors.appWhiteColor),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.cancel),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
          body:
              GetBuilder<ViewTicketController>(builder: (viewTicketController) {
            return viewTicketController.isLoading == false &&
                    viewTicketController.message != null
                ? Stack(
                    children: [
                      Positioned.fill(
                        child: Get.isDarkMode
                            ? Image.asset(
                                // Set your background image asset here
                                'assets/images/chat_dark.jpg', // Replace with your image path
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                // Set your background image asset here
                                'assets/images/chat_bg.jpg', // Replace with your image path
                                fit: BoxFit.cover,
                              ),
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Color(
                                    0x80F0F8FF), // Semi-transparent WhatsApp-like chat background color
                              ),
                              child:
                                  viewTicketController.isLoading == false &&
                                          viewTicketController.message != null
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          reverse:
                                              true, // To make the chat messages scroll from bottom to top
                                          itemCount: viewTicketController
                                              .message!.messages!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ListTile(
                                              title: Align(
                                                alignment: viewTicketController
                                                            .message!
                                                            .messages![index]
                                                            .adminId ==
                                                        null
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      viewTicketController
                                                                  .message!
                                                                  .messages![
                                                                      index]
                                                                  .adminId ==
                                                              null
                                                          ? CrossAxisAlignment
                                                              .end
                                                          : CrossAxisAlignment
                                                              .start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          timeVisible =
                                                              !timeVisible;
                                                          selectedIndex = index;
                                                        });
                                                      },
                                                      child: viewTicketController
                                                                  .message!
                                                                  .messages![
                                                                      index]
                                                                  .attachments ==
                                                              null
                                                          ? Container(
                                                              width: 200.w,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: viewTicketController
                                                                            .message!
                                                                            .messages![
                                                                                index]
                                                                            .adminId ==
                                                                        null
                                                                    ? AppColors
                                                                        .appPrimaryColor
                                                                    : Colors
                                                                        .white, // User and admin message bubble color
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              child:
                                                                  SelectableText(
                                                                viewTicketController
                                                                    .message!
                                                                    .messages![
                                                                        index]
                                                                    .message
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: viewTicketController
                                                                              .message!
                                                                              .messages![
                                                                                  index]
                                                                              .adminId ==
                                                                          null
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black, // User and admin message text color
                                                                ),
                                                              ),
                                                            )
                                                          : Column(
                                                              crossAxisAlignment: viewTicketController
                                                                          .message!
                                                                          .messages![
                                                                              index]
                                                                          .adminId ==
                                                                      null
                                                                  ? CrossAxisAlignment
                                                                      .end
                                                                  : CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: viewTicketController.message!.messages![index].adminId ==
                                                                            null
                                                                        ? AppColors
                                                                            .appBrandColor3
                                                                        : AppColors
                                                                            .appBg1, // User and admin message bubble color
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  child:
                                                                      SelectableText(
                                                                    viewTicketController
                                                                        .message!
                                                                        .messages![
                                                                            index]
                                                                        .message
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: viewTicketController.message!.messages![index].adminId ==
                                                                              null
                                                                          ? Colors
                                                                              .black
                                                                          : Colors
                                                                              .black, // User and admin message text color
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4.0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: viewTicketController
                                                                          .message!
                                                                          .messages![
                                                                              index]
                                                                          .attachments!
                                                                          .map<Widget>(
                                                                              (attachment) {
                                                                        return Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              if (kDebugMode) {
                                                                                print('Prepare for Download');
                                                                              }
                                                                              _downloadFile(
                                                                                attachment.attachmentPath.toString(), // Replace with the actual URL of the file
                                                                                attachment.attachmentName.toString(),
                                                                              );
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: Get.isDarkMode ? AppColors.appBlackColor : AppColors.appWhiteColor, border: Border.all(color: Get.isDarkMode ? Colors.white10 : Colors.black12), borderRadius: BorderRadius.circular(10)),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.download_outlined, // You can use a different icon as needed
                                                                                      color: Get.isDarkMode ? Colors.white : Colors.blue, // You can adjust the color as needed
                                                                                      size: 18.h,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 4.w,
                                                                                    ),
                                                                                    Text(
                                                                                      attachment.attachmentName.toString(),
                                                                                      style: TextStyle(
                                                                                        color: AppColors.getTextDarkLight(),
                                                                                        // You can adjust the style as needed
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }).toList(),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                    ),
                                                    Visibility(
                                                        visible:
                                                            selectedIndex ==
                                                                index,
                                                        child: Text(
                                                          selectedIndex == index
                                                              ? '${changeDateFormat(viewTicketController.message!.messages![index].createdAt.toString())}'
                                                              : '',
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .appBlackColor,
                                                              fontSize: 14.sp),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(
                                          color: AppColors.appPrimaryColor,
                                        )),
                            ),
                          ),
                          _fileNames.isNotEmpty
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 4),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.purple.shade500),
                                      child: Text(
                                        "${_fileNames.length} File Selected",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                      )))
                              : const SizedBox.shrink(),
                          const Divider(height: 1.0),
                          ticketStatus != "Closed"
                              ? GetBuilder<ReplyTicketController>(
                                  builder: (replyTicketController) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color:
                                            AppColors.getBackgroundDarkLight()),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.attachment),
                                          onPressed: () {
                                            _pickFiles();
                                          },
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: _textController,
                                            decoration:
                                                const InputDecoration.collapsed(
                                                    hintText: 'Send a message'),
                                          ),
                                        ),
                                        replyTicketController.isLoading == false
                                            ? IconButton(
                                                icon: const Icon(Icons.send),
                                                onPressed: () {
                                                  setState(() {});
                                                  if (_textController
                                                      .text.isNotEmpty) {
                                                    if (_fileNames.isEmpty) {
                                                      replyTicketController
                                                          .ticketReplyRequest(
                                                        context,
                                                        viewTicketController
                                                            .message!.id
                                                            .toString(),
                                                        _textController.text
                                                            .toString(),
                                                        1,
                                                      )
                                                          .then((value) {
                                                        _textController.text =
                                                            "";
                                                        viewTicketController
                                                            .getViewTicketData(
                                                                ticketId);
                                                      });
                                                    } else {
                                                      replyTicketController
                                                          .ticketReplyRequest(
                                                              context,
                                                              viewTicketController
                                                                  .message!.id
                                                                  .toString(),
                                                              _textController
                                                                  .text
                                                                  .toString(),
                                                              1,
                                                              result:
                                                                  selectedFilePaths)
                                                          .then((value) {
                                                        _textController.text =
                                                            "";
                                                        _fileNames.clear();
                                                        viewTicketController
                                                            .getViewTicketData(
                                                                ticketId);
                                                      });
                                                    }
                                                  } else {
                                                    Get.snackbar(
                                                      "Message",
                                                      "Message field is required",
                                                      backgroundColor:
                                                          Colors.red,
                                                      colorText: Colors.white,
                                                      duration: const Duration(
                                                          seconds: 1),
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      borderRadius: 8,
                                                      shouldIconPulse: true,
                                                      barBlur: 10,
                                                    );
                                                  }
                                                },
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                      ],
                                    ),
                                  );
                                })
                              : SizedBox.shrink(),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: AppColors.appPrimaryColor,
                    ),
                  );
          }),
        ),
      );
    });
  }
}

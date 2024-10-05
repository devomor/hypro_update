import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/create_ticket_controller.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateNewTicketScreen extends StatefulWidget {
  static const String routeName = "/createNewTicketScreen";
  const CreateNewTicketScreen({super.key});

  @override
  State<CreateNewTicketScreen> createState() => _CreateNewTicketScreenState();
}

class _CreateNewTicketScreenState extends State<CreateNewTicketScreen> {
  final List<String> _fileNames = [];

  final selectedLanguageStorage = GetStorage();

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
  Widget build(BuildContext context) {
    return GetBuilder<CreateTicketController>(
        builder: (createTicketController) {
      return Scaffold(
        backgroundColor: AppColors.getBackgroundDarkLight(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.getAppBarBgDarkLight(),
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
            "${selectedLanguageStorage.read("languageData")["Create Ticket"] ?? "Create Ticket"}",
            style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: AppColors.getTextDarkLight(),
            ),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.getBackgroundDarkLight(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.r),
                        child: Text(
                          "${selectedLanguageStorage.read("languageData")["Subject"] ?? "Subject"}",
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        controller: createTicketController.subject,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                left: 12, top: 8, bottom: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set the border radius here
                              borderSide:
                                  BorderSide.none, // Remove the default border
                            ),
                            fillColor: AppColors.getTextFieldDarkLight(),
                            filled: true,
                            hintText:
                                "${selectedLanguageStorage.read("languageData")["Enter Subject"] ?? "Enter Subject"}",
                            hintStyle: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w400)),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.r),
                        child: Text(
                          "${selectedLanguageStorage.read("languageData")["Message"] ?? "Message"}",
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        controller: createTicketController.message,
                        textInputAction: TextInputAction.done,
                        minLines: 5,
                        maxLines: null,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                left: 12, top: 8, bottom: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set the border radius here
                              borderSide:
                                  BorderSide.none, // Remove the default border
                            ),
                            fillColor: AppColors.getTextFieldDarkLight(),
                            filled: true,
                            hintText:
                                "${selectedLanguageStorage.read("languageData")["Enter Message"] ?? "Enter Message"}",
                            hintStyle: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w400)),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.r),
                        child: Text(
                          "${selectedLanguageStorage.read("languageData")["Upload File"] ?? "Upload File"}",
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
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
                                _pickFiles();
                              },
                              child: Text(
                                "${selectedLanguageStorage.read("languageData")["Choose Files"] ?? "Choose Files"}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Container(
                              height: 60,
                              width: 1,
                              color: AppColors.appBg3,
                            ),
                            SizedBox(width: 15.w),
                            _fileNames.isNotEmpty
                                ? Text(
                                    "${_fileNames.length} File Selected",
                                    style: TextStyle(
                                        color: AppColors
                                            .appDashBoardTransactionGreen),
                                  )
                                : Text(
                                    "No File Selected",
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 48.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (kDebugMode) {
                            print(
                                createTicketController.subject.text.toString());
                          }
                          if (kDebugMode) {
                            print(
                                createTicketController.message.text.toString());
                          }
                          if (kDebugMode) {
                            print(selectedFilePaths);
                          }
                          createTicketController.createTicketRequest(
                              createTicketController.subject.text.toString(),
                              createTicketController.message.text.toString(),
                              selectedFilePaths,
                              context);
                        },
                        child: Center(
                          child: Container(
                            height: 52.h,
                            width: 382.w,
                            decoration: BoxDecoration(
                                color: AppColors.appPrimaryColor,
                                borderRadius: BorderRadius.circular(24)),
                            child: Center(
                                child: createTicketController.isLoading == false
                                    ? Text(
                                        "${selectedLanguageStorage.read("languageData")["Submit"] ?? "Submit"}",
                                        style: GoogleFonts.niramit(
                                            fontSize: 16.sp,
                                            color: AppColors.appFillColor,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator(
                                        color: AppColors.appWhiteColor,
                                      ))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

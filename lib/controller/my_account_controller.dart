import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/auth_controller.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/model/response_model/my_account_model.dart';
import 'package:flutter_hypro/data/repository/my_account_repo.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:flutter_hypro/view/verify_required/mail_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/sms_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/two_factor_verification_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MyAccountController extends GetxController {
  final MyAccountRepo myAccountRepo;

  MyAccountController({required this.myAccountRepo});

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final address = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();

  dynamic _status;
  dynamic get status => _status;
  MyAccountData? _message;
  MyAccountData? get message => _message;

  bool _isLoadingImage = false;
  bool get isLoadingImage => _isLoadingImage;

  bool _isLoadingInformation = false;
  bool get isLoadingInformation => _isLoadingInformation;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Observable variable for pickedImage
  dynamic pickedImage;

  Future<void> pickImage() async {
    // Request storage permission
    final storageStatus = await Permission.storage.request();

    if (storageStatus.isGranted) {
      final picker = ImagePicker();
      pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        update();
        if (kDebugMode) {
          print("Image Path${pickedImage!.path}");
        }
      }
      // Refresh the widget to show the selected image
    }
  }

  MyAccountModel myAccountModel = MyAccountModel();

  List<Widget> formFields = [];

  dynamic fieldNames = [];
  dynamic fieldValues = [];

  dynamic selectedFilePath;

  Future<void> getAccountData({dynamic identityFormName}) async {
    _isLoading = true;
    update();

    ApiResponse apiResponse = await myAccountRepo.getAccountData();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();

      if (apiResponse.response!.data != null) {
        _message = null;
        update();

        if (apiResponse.response!.data["message"] ==
            "Email Verification Required") {
          Get.offAllNamed(MailVerificationScreen.routeName);
        } else if (apiResponse.response!.data["message"] ==
            "Mobile Verification Required") {
          Get.offAllNamed(SmsVerificationScreen.routeName);
        } else if (apiResponse.response!.data["message"] ==
            "Two FA Verification Required") {
          Get.offAllNamed(TwoFactorVerificationScreen.routeName);
        } else if (apiResponse.response!.data["message"] ==
            "Your account has been suspend") {
          Get.find<AuthController>().removeUserToken();
          await Get.offNamedUntil(LoginScreen.routeName, (route) => false);
        } else {
          myAccountModel = MyAccountModel.fromJson(apiResponse.response!.data!);
          _message = myAccountModel.message;

          formFields.clear(); // Clear existing form fields
          selectedFilePath = null;
          var selectedIdentityForm = _message!.identityFormList?.firstWhere(
            (identityForm) => identityForm.name == identityFormName,
            orElse: () => IdentityFormList(),
          );

          if (selectedIdentityForm!.servicesForm != null) {
            for (var fieldData in selectedIdentityForm.servicesForm!.values) {
              if (fieldData is Map<String, dynamic>) {
                final fieldLevel = fieldData['field_level'];
                final fieldName = fieldData['field_name'];
                final fieldType = fieldData['type'];
                final validation = fieldData['validation'];

                // Outside the function, declare a map to store text editing controllers
                Map<dynamic, TextEditingController> textControllers = {};
                dynamic fieldValue;

                Map<dynamic, TextEditingController> textAreaControllers = {};
                dynamic textAreaFieldValue;

                if (kDebugMode) {
                  print(fieldType);
                  print(fieldName);
                  print(validation);
                }

                if (fieldType == 'text') {
                  textControllers[fieldName] = TextEditingController();
                  formFields.add(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        Text("${fieldLevel} ",
                            style: TextStyle(fontSize: 16.sp)),
                        SizedBox(height: 10.h),
                        TextFormField(
                          controller: textControllers[fieldName],
                          onChanged: (value) {
                            for (var fieldName in textControllers.keys) {
                              fieldValue = textControllers[fieldName]!.text;
                              fieldNames.add(fieldName);
                              fieldValues.add(fieldValue);
                              // print("Field $fieldName: $fieldValue");
                              update();
                            }
                            if (kDebugMode) {
                              print(fieldNames);
                              print(fieldValues);
                            }
                          },
                          decoration: InputDecoration(
                            hintText:
                                validation != "required" ? "$validation" : "",
                            hintStyle: GoogleFonts.publicSans(
                                color: AppColors.appBlackColor50,
                                fontSize: 13.sp),
                            contentPadding: const EdgeInsets.only(
                                left: 12, top: 10, bottom: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set the border radius here
                              borderSide:
                                  BorderSide.none, // Remove the default border
                            ),
                            fillColor: AppColors.getTextFieldDarkLight(),
                            filled: true,
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  );
                } else if (fieldType == 'textarea') {
                  textAreaControllers[fieldName] = TextEditingController();
                  formFields.add(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        Text(fieldLevel, style: TextStyle(fontSize: 16.sp)),
                        SizedBox(height: 10.h),
                        TextFormField(
                          controller: textAreaControllers[fieldName],
                          onChanged: (value) {
                            for (var fieldName in textAreaControllers.keys) {
                              textAreaFieldValue =
                                  textAreaControllers[fieldName]!.text;
                              fieldNames.add(fieldName);
                              fieldValues.add(textAreaFieldValue);
                              // print("Field $fieldName: $fieldValue");
                              update();
                            }
                            if (kDebugMode) {
                              print(fieldNames);
                              print(fieldValues);
                            }
                          },
                          minLines: 3,
                          maxLines: null,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText:
                                validation != "required" ? "$validation" : "",
                            hintStyle: GoogleFonts.publicSans(
                                color: AppColors.appBlackColor50,
                                fontSize: 13.sp),
                            contentPadding: const EdgeInsets.only(
                                left: 12, top: 10, bottom: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set the border radius here
                              borderSide:
                                  BorderSide.none, // Remove the default border
                            ),
                            fillColor: AppColors.getTextFieldDarkLight(),
                            filled: true,
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  );
                } else if (fieldType == "file") {
                  formFields.add(
                    StatefulBuilder(builder: (context, setState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          // Replace this with your file picker widget
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${fieldData["field_level"]}",
                                style: TextStyle(fontSize: 16.sp),
                              )),
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
                                    pickImage().then((values) {
                                      if (pickedImage != null) {
                                        selectedFilePath = pickedImage.path;
                                        fieldNames.add(fieldName);
                                        fieldValues.add(selectedFilePath);
                                      }
                                      setState(() {});
                                      update();
                                    });
                                  },
                                  child: Text("Choose Files",
                                      style: GoogleFonts.publicSans(
                                        fontSize: 13.sp,
                                      )),
                                ),
                                SizedBox(width: 5.w),
                                Container(
                                  height: 60,
                                  width: 1,
                                  color: AppColors.appBg3,
                                ),
                                SizedBox(width: 13.w),
                                selectedFilePath != null
                                    ? Text(
                                        "1 File Selected",
                                        style: GoogleFonts.publicSans(
                                            color: AppColors
                                                .appDashBoardTransactionGreen,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : Text(
                                        "No File Selected",
                                        style: GoogleFonts.publicSans(
                                            fontSize: 13.sp),
                                      ),
                              ],
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     pickImage().then((values) {
                          //       if (pickedImage != null) {
                          //         selectedFilePath = pickedImage.path;
                          //         fieldNames.add(fieldName);
                          //         fieldValues.add(selectedFilePath);
                          //       }
                          //       setState(() {});
                          //       update();
                          //     });
                          //   },
                          //   child: selectedFilePath == null
                          //       ? Image.asset(
                          //     "assets/images/default_img.png",
                          //     height: 100.h,
                          //     width: 100.w,
                          //   )
                          //       : Image.file(
                          //     File(selectedFilePath),
                          //     height: 100.0,
                          //     width: 100.0,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          // Add spacing or additional widgets if needed
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      );
                    }),
                  );
                }
              }
            }
          }
        }
      }
    } else {
      _isLoading = false;
      update();
    }
  }

  /// Update profile Information
  Future<dynamic> updateAccountInformation(
    dynamic firstName,
    dynamic lastName,
    dynamic userName,
    dynamic address,
  ) async {
    _isLoadingInformation = true;
    update();
    ApiResponse apiResponse = await myAccountRepo.updateAccountInformation(
        firstName, lastName, userName, address);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoadingInformation = false;
      update();
      if (apiResponse.response!.data != null) {
        if (apiResponse.response!.data["message"] ==
            "Email Verification Required") {
          Get.offAllNamed(MailVerificationScreen.routeName);
        } else if (apiResponse.response!.data["message"] ==
            "Mobile Verification Required") {
          Get.offAllNamed(SmsVerificationScreen.routeName);
        } else if (apiResponse.response!.data["message"] ==
            "Two FA Verification Required") {
          Get.offAllNamed(TwoFactorVerificationScreen.routeName);
        } else if (apiResponse.response!.data["message"] ==
            "Your account has been suspend") {
          Get.find<AuthController>().removeUserToken();
          await Get.offNamedUntil(LoginScreen.routeName, (route) => false);
        } else {
          dynamic status = apiResponse.response!.data['status'];
          dynamic msg = apiResponse.response!.data['message'];
          Get.snackbar(
            'Message',
            '${msg}',
            backgroundColor: status == "success" ? Colors.green : Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(10),
            borderRadius: 8,
            shouldIconPulse: true,
            icon: Icon(status == "success" ? Icons.check : Icons.cancel,
                color: Colors.white),
            barBlur: 10,
          );
          update();
        }
      }
    } else {
      _isLoadingInformation = false;
      update();
    }
  }

  /// Update profile Image
  Future<dynamic> updateAccountImage(
    dynamic path,
  ) async {
    _isLoadingImage = true;
    update();
    ApiResponse apiResponse = await myAccountRepo.updateAccountImage(path);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoadingImage = false;
      update();
      if (apiResponse.response!.data != null) {
        if (apiResponse.response!.data["message"] ==
            "Email Verification Required") {
          Get.offAllNamed(MailVerificationScreen.routeName);
        } else if (apiResponse.response!.data["message"] ==
            "Mobile Verification Required") {
          Get.offAllNamed(SmsVerificationScreen.routeName);
        } else if (apiResponse.response!.data["message"] ==
            "Two FA Verification Required") {
          Get.offAllNamed(TwoFactorVerificationScreen.routeName);
        } else if (apiResponse.response!.data["message"] ==
            "Your account has been suspend") {
          Get.find<AuthController>().removeUserToken();
          await Get.offNamedUntil(LoginScreen.routeName, (route) => false);
        } else {
          dynamic status = apiResponse.response!.data['status'];
          dynamic msg = apiResponse.response!.data['message'];
          Get.snackbar(
            'Message',
            '${msg}',
            backgroundColor: status == "success" ? Colors.green : Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(10),
            borderRadius: 8,
            shouldIconPulse: true,
            icon: Icon(status == "success" ? Icons.check : Icons.cancel,
                color: Colors.white),
            barBlur: 10,
          );
          update();
        }
      }
    } else {
      _isLoadingImage = false;
      update();
    }
  }

  @override
  void onInit() {
    getAccountData();
    super.onInit();
  }
}

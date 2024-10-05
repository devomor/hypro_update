import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/model/response_model/payout_model.dart';
import 'package:flutter_hypro/data/model/response_model/paystack_bank_data_model.dart';
import 'package:flutter_hypro/data/repository/payout_repo.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/view/screens/history/payout_history_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/model/response_model/payout_bank_form_model.dart';
import '../view/screens/auth/login_screen.dart';
import '../view/verify_required/mail_verification_screen.dart';
import '../view/verify_required/sms_verification_screen.dart';
import '../view/verify_required/two_factor_verification_screen.dart';
import 'auth_controller.dart';

class PayoutController extends GetxController {
  final PayoutRepo payoutRepo;

  PayoutController({required this.payoutRepo});

  dynamic _status;

  dynamic get status => _status;
  PayoutData? _message;

  PayoutData? get message => _message;

  PayoutBankFormData? _messageBankData;

  PayoutBankFormData? get messageBankData => _messageBankData;

  PayStackBankData? _messagePayStackBankData;

  PayStackBankData? get messagePayStackBankData => _messagePayStackBankData;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isLoadingPayoutBank = false;

  bool get isLoadingPayoutBank => _isLoadingPayoutBank;

  bool _isLoadingPayStack = false;

  bool get isLoadingPayStack => _isLoadingPayStack;

  bool _isLoadingPayoutRequest = false;

  bool get isLoadingPayoutRequest => _isLoadingPayoutRequest;

  PayoutModel payoutModel = PayoutModel();
  PayoutBankFormModel payoutBankFormModel = PayoutBankFormModel();
  PayStackBankDataModel payStackBankDataModel = PayStackBankDataModel();

  var selectedCurrencyController = TextEditingController();
  dynamic selectedCurrency;

  dynamic bankNameFlutterWave;
  dynamic supportedCurrencyFlutterWave;
  dynamic convertRateFlutterWave;

  dynamic selectedBank;
  dynamic selectedPayStackBank;
  dynamic inputFieldsData;

  dynamic selectedBankNameFlutterWave;
  dynamic selectedSupportedCurrencyFlutterWave;

  dynamic selectedPayStackBankData;

  // Declare a map to store the form fields for each gateway
  final Map<String, RxList<Widget>> gatewayFormFields = {};
  final Map<String, List<DropdownMenuItem<String>>> gatewaySupportedCurrencies =
      {};

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

  selectionClear() {
    selectedCurrency = null;
    update();
  }

  dynamic fieldNames = [].toSet().toList();
  dynamic fieldValues = [].toSet().toList();

  dynamic selectedFilePath;

  ///Get Payout Data
  Future<void> getPayoutData() async {
    _isLoading = true;
    update();
    ApiResponse apiResponse = await payoutRepo.getPayoutData();

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
          payoutModel = PayoutModel.fromJson(apiResponse.response!.data!);
          _message = payoutModel.message;
          if (_message!.gateways!.isNotEmpty) {
            for (var i in _message!.gateways!) {
              if (i.name == "Flutterwave") {
                bankNameFlutterWave = i.bankName;
                supportedCurrencyFlutterWave = i.supportedCurrency;
              }
            }
          }

          // Clear the existing form fields for each gateway
          gatewayFormFields.clear();
          selectedCurrency = null;

          for (var gateway in payoutModel.message!.gateways!) {
            final dynamicForm = gateway.dynamicForm;

            if (dynamicForm != null && dynamicForm is Map<String, dynamic>) {
              RxList<Widget> formFields = <Widget>[].obs;

              dynamicForm.forEach((fieldName, fieldData) {
                final fieldType = fieldData["type"] as String;
                final validation = fieldData["validation"] as String;
                // Outside the function, declare a map to store text editing controllers
                Map<dynamic, TextEditingController> textControllers = {};
                dynamic fieldValue;

                Map<dynamic, TextEditingController> textAreaControllers = {};
                dynamic textAreaFieldValue;

                if (fieldType == "text") {
                  textControllers[fieldName] = TextEditingController();
                  update();
                  formFields.add(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                            fieldData["field_level"] ?? "${fieldData["label"]}",
                            style: GoogleFonts.niramit(
                                fontSize: 14.sp,
                                color: AppColors.getTextDarkLight(),
                                fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 8.h,
                        ),
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
                          },
                          decoration: InputDecoration(
                            hintText:
                                validation == "required" ? "" : "optional",
                            hintStyle: GoogleFonts.publicSans(
                              fontSize: 13.sp,
                            ),
                            contentPadding:
                                EdgeInsets.only(left: 12, top: 10, bottom: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set the border radius here
                              borderSide:
                                  BorderSide.none, // Remove the default border
                            ),
                            fillColor: AppColors.getTextFieldDarkLight(),
                            filled: true,
                          ),
                          // Add validation logic here based on fieldData["validation"]
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
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
                                  child: Text(
                                    "Choose Files",
                                    style: GoogleFonts.publicSans(
                                      fontSize: 13.sp,
                                    ),
                                  ),
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
                                          fontSize: 13.sp,
                                        ),
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
                          //       ? Stack(
                          //         children: [
                          //           Image.asset(
                          //     "assets/images/default_img.png",
                          //     height: 100.h,
                          //     width: 100.w,
                          //   ),
                          //           Positioned(
                          //               bottom: 0,
                          //               left: 5,
                          //               right: 5,
                          //               child: Container(
                          //                 height: 20.h,
                          //             color: AppColors.appPrimaryColor,
                          //             child: Center(
                          //               child: Text(
                          //                 "Upload Image",
                          //                 style: GoogleFonts.niramit(
                          //                   fontWeight: FontWeight.w500,
                          //                   fontSize: 12.sp,
                          //                   color: AppColors.appWhiteColor
                          //                 ),
                          //               ),
                          //             ),
                          //           ))
                          //         ],
                          //       )
                          //       : Image.file(
                          //     File(selectedFilePath),
                          //     height: 180.0,
                          //     width: 180.0,
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
                } else if (fieldType == "textarea") {
                  textAreaControllers[fieldName] = TextEditingController();
                  formFields.add(
                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 6.h,
                          ),
                          Text(
                              fieldData["field_level"] ??
                                  "${fieldData["label"]}",
                              style: GoogleFonts.niramit(
                                  fontSize: 14.sp,
                                  color: AppColors.getTextDarkLight(),
                                  fontWeight: FontWeight.w400)),
                          SizedBox(
                            height: 8.h,
                          ),
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
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.done,
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText:
                                  validation == "required" ? "" : "optional",
                              hintStyle: GoogleFonts.publicSans(
                                fontSize: 13.sp,
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 12, top: 10, bottom: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Set the border radius here
                                borderSide: BorderSide
                                    .none, // Remove the default border
                              ),
                              fillColor: AppColors.getTextFieldDarkLight(),
                              filled: true,
                            ),
                            // Add validation logic here based on fieldData["validation"]
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              });

              // Store the form fields for the current gateway
              gatewayFormFields[gateway.name.toString()] = formFields;

              // Add dropdown logic if supportedCurrency is not null
              if (gateway.supportedCurrency != null) {
                List<DropdownMenuItem<String>> currencyDropdownItems = [];

                gateway.supportedCurrency!.keys.forEach((currency) {
                  currencyDropdownItems.add(
                    DropdownMenuItem<String>(
                      value: currency,
                      child: Text(
                        currency,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  );
                });

                // Assign the dropdown items to the controller's value
                selectedCurrencyController.text =
                    gateway.supportedCurrency!.keys.first;

                // Assign the controller to the field you want to bind the selected value to
                gatewaySupportedCurrencies[gateway.name.toString()] =
                    currencyDropdownItems;
              }

              update();
            }
          }
        }
      } else {
        _isLoading = false;
        update();
      }
    }
  }

  ///Get Bank Data
  Future<dynamic> getPayoutBankFormData(dynamic bankName) async {
    _isLoadingPayoutBank = true;
    update();
    ApiResponse apiResponse = await payoutRepo.getPayoutBankFormData(bankName);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoadingPayoutBank = false;
      update();
      if (apiResponse.response!.data != null) {
        _messageBankData = null;
        inputFieldsData = null;
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
          inputFieldsData = apiResponse.response!.data["message"]["input_form"];
          if (kDebugMode) {
            print(inputFieldsData);
          }
          payoutBankFormModel =
              PayoutBankFormModel.fromJson(apiResponse.response!.data!);
          _messageBankData = payoutBankFormModel.message;
        }
      }
    } else {
      _isLoadingPayoutBank = false;
      update();
    }
  }

  ///Get PayStack Dropdown Data
  Future<dynamic> getPayStackBankData(dynamic currencyCode) async {
    _isLoadingPayStack = true;
    update();
    ApiResponse apiResponse =
        await payoutRepo.getPayStackDropDownData(currencyCode);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoadingPayStack = false;
      update();
      if (apiResponse.response!.data != null) {
        _messagePayStackBankData = null;
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
          update();
          if (kDebugMode) {
            print(inputFieldsData);
          }
          payStackBankDataModel =
              PayStackBankDataModel.fromJson(apiResponse.response!.data!);
          _messagePayStackBankData = payStackBankDataModel.message;
        }
      }
    } else {
      _isLoadingPayStack = false;
      update();
    }
  }

  /// Payout Request
  Future<dynamic> payoutRequest(
      BuildContext context,
      dynamic walletType,
      dynamic gateway,
      dynamic amount,
      List<dynamic> fieldNames,
      List<dynamic> fieldValues,
      {dynamic currencyCode,
      dynamic recipientType,
      dynamic selectBank}) async {
    _isLoadingPayoutRequest = true;
    update();
    ApiResponse apiResponse = await payoutRepo.payoutRequest(
        walletType, gateway, amount, fieldNames, fieldValues,
        currencyCode: currencyCode,
        recipientType: recipientType,
        selectBank: selectBank);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoadingPayoutRequest = false;
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
          Map map = apiResponse.response!.data;
          dynamic msg;
          msg = map["message"];
          dynamic status;
          status = map["status"];

          if (status == "success") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => PayoutHistoryScreen(
                          status: "true",
                        )),
                (route) => false);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  content: Container(
                    height: 260.h,
                    width: 260.w,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Lottie.asset("assets/images/success.json"),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            "Payout request send",
                            style: GoogleFonts.publicSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.getTextDarkLight(),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        AppColors.appDashBoardTransactionGreen,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: Center(
                                      child: Text(
                                        "Ok",
                                        style: GoogleFonts.publicSans(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.appWhiteColor,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            Get.snackbar(
              'Message',
              '${msg}',
              backgroundColor: status != "success" ? Colors.red : Colors.green,
              colorText: Colors.white,
              duration: Duration(seconds: 2),
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.all(10),
              borderRadius: 8,
              barBlur: 10,
            );
          }

          update();
          if (kDebugMode) {
            print(inputFieldsData);
          }
        }
      }
    } else {
      _isLoadingPayoutRequest = false;
      update();
    }
  }

  /// FlutterWave Payout Request
  Future<dynamic> flutterWavePayoutRequest(
    BuildContext context,
    dynamic walletType,
    dynamic gateway,
    dynamic amount,
    List<dynamic> fieldNames,
    List<dynamic> fieldValues, {
    dynamic currencyCode,
    dynamic bank,
    dynamic transferName,
  }) async {
    _isLoadingPayoutRequest = true;
    update();
    ApiResponse apiResponse = await payoutRepo.flutterWavePayoutRequest(
        walletType, gateway, amount, fieldNames, fieldValues,
        currencyCode: currencyCode, transferName: transferName, bank: bank);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoadingPayoutRequest = false;
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
          Map map = apiResponse.response!.data;
          dynamic msg;
          msg = map["message"];
          dynamic status;
          status = map["status"];

          if (status == "success") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => PayoutHistoryScreen(
                          status: "true",
                        )),
                (route) => false);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  content: Container(
                    height: 260.h,
                    width: 260.w,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Lottie.asset("assets/images/success.json"),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            "Payout request send",
                            style: GoogleFonts.publicSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.getTextDarkLight(),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        AppColors.appDashBoardTransactionGreen,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: Center(
                                      child: Text(
                                        "Ok",
                                        style: GoogleFonts.publicSans(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.appWhiteColor,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            Get.snackbar(
              'Message',
              '${msg}',
              backgroundColor: status != "success" ? Colors.red : Colors.green,
              colorText: Colors.white,
              duration: Duration(seconds: 2),
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.all(10),
              borderRadius: 8,
              barBlur: 10,
            );
          }

          update();
          if (kDebugMode) {
            print(inputFieldsData);
          }
        }
      }
    } else {
      _isLoadingPayoutRequest = false;
      update();
    }
  }

  @override
  void onInit() {
    getPayoutData();
    super.onInit();
  }
}

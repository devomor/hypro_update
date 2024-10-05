import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/my_account_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/colors/app_colors.dart';

class EditAccountScreen extends StatefulWidget {
  static const String routeName = "/editAccountScreen";
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  XFile? pickedImage;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImageFile = await picker.pickImage(source: source);

    setState(() {
      pickedImage = pickedImageFile;
      Navigator.pop(context);
    });
  }

  final account = Get.find<MyAccountController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      account.getAccountData().then((value) {
        account.firstName.text =
            "${Get.find<MyAccountController>().message!.userFirstName ?? ""}";
        account.lastName.text =
            "${Get.find<MyAccountController>().message!.userLastName ?? ""}";
        account.userName.text =
            "${Get.find<MyAccountController>().message!.username ?? ""}";
        account.address.text =
            "${Get.find<MyAccountController>().message!.userAddress ?? ""}";
        account.phone.text =
            "${Get.find<MyAccountController>().message!.userPhone ?? ""}";
        account.email.text =
            "${Get.find<MyAccountController>().message!.userEmail ?? ""}";
      });
    });

    super.initState();
  }

  final selectedLanguageStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyAccountController>(builder: (myAccountController) {
      return Scaffold(
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
              )),
          title: Text(
            "${selectedLanguageStorage.read("languageData")["Edit Profile"] ?? "Edit Profile"}",
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.getContainerFillBgDarkLight(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.r),
                        child: Center(
                          child: Text(
                            "${selectedLanguageStorage.read("languageData")["Upload Profile Image"] ?? "Upload Profile Image"}",
                            style: GoogleFonts.niramit(
                              fontWeight: FontWeight.w500,
                              color: AppColors.getTextDarkLight(),
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  // ClipOval(
                                  //   child: pickedImage != null
                                  //       ? Image.file(
                                  //     File(pickedImage!.path),
                                  //     height: 180.0,
                                  //     width: 180.0,
                                  //     fit: BoxFit.cover,
                                  //   )
                                  //       : (account.message?.userImage != null)
                                  //       ? Image.network(
                                  //     "${account.message!.userImage}",
                                  //     height: 180.0,
                                  //     width: 180.0,
                                  //     fit: BoxFit.cover,
                                  //   )
                                  //       : const Icon(Icons.account_circle, size: 180.0),
                                  // ),
                                  ClipOval(
                                    child: pickedImage != null
                                        ? Image.file(
                                            File(pickedImage!.path),
                                            height: 180.0,
                                            width: 180.0,
                                            fit: BoxFit.cover,
                                          )
                                        : (account.message?.userImage != null)
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    "${account.message!.userImage}",
                                                height: 180.0,
                                                width: 180.0,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(), // Placeholder while loading
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Icon(Icons
                                                        .error), // Error widget if loading fails
                                              )
                                            : const Icon(Icons.account_circle,
                                                size: 180.0),
                                  ),

                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.appPrimaryColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.grey.shade100)),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.add_a_photo,
                                          color: AppColors.appWhiteColor,
                                        ),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(height: 10.h),
                                                    GestureDetector(
                                                      onTap: () {
                                                        pickImage(
                                                            ImageSource.camera);
                                                      },
                                                      child: Container(
                                                        height: 80.h,
                                                        width: 150.w,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: AppColors
                                                                    .getContainerBgDarkLight(),
                                                                border:
                                                                    Border.all(
                                                                  color: AppColors
                                                                      .appBlackColor50,
                                                                )),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.camera_alt,
                                                              size: 35.h,
                                                              color: AppColors
                                                                  .appBlackColor50,
                                                            ),
                                                            SizedBox(
                                                              height: 2.h,
                                                            ),
                                                            Text(
                                                              'Pick from Camera',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.sp),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        pickImage(ImageSource
                                                            .gallery);
                                                      },
                                                      child: Container(
                                                        height: 80.h,
                                                        width: 150.w,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: AppColors
                                                                    .getContainerBgDarkLight(),
                                                                border:
                                                                    Border.all(
                                                                  color: AppColors
                                                                      .appBlackColor50,
                                                                )),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.camera,
                                                              size: 35.h,
                                                              color: AppColors
                                                                  .appBlackColor50,
                                                            ),
                                                            SizedBox(
                                                              height: 2.h,
                                                            ),
                                                            Text(
                                                              'Pick from Gallery',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.sp),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          myAccountController
                              .updateAccountImage(pickedImage!.path)
                              .then((value) {
                            myAccountController.getAccountData();
                          });
                        },
                        child: Center(
                          child: Container(
                            height: 40.h,
                            width: 200.w,
                            decoration: BoxDecoration(
                                color: AppColors.appPrimaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child:
                                    myAccountController.isLoadingImage == false
                                        ? Text(
                                            "${selectedLanguageStorage.read("languageData")["Update Image"] ?? "Update Image"}",
                                            style: TextStyle(
                                                color: AppColors.appWhiteColor,
                                                fontSize: 16.sp,
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
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.getBackgroundDarkLight(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "${selectedLanguageStorage.read("languageData")["Upload Profile Information"] ?? "Upload Profile Information"}",
                          style: GoogleFonts.niramit(
                              fontSize: 17.sp,
                              color: AppColors.getTextDarkLight(),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Text(
                          "${selectedLanguageStorage.read("languageData")["Firstname"] ?? "Firstname"}",
                          style: GoogleFonts.niramit(
                              fontSize: 16.sp,
                              color: AppColors.getTextDarkLight(),
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        style: TextStyle(color: AppColors.getTextDarkLight()),
                        controller: myAccountController.firstName,
                        decoration: InputDecoration(
                          hintText:
                              "${selectedLanguageStorage.read("languageData")["firstname"] ?? "firstname"}",
                          hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.appBlackColor50),
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
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Text(
                          "${selectedLanguageStorage.read("languageData")["Lastname"] ?? "Lastname"}",
                          style: GoogleFonts.niramit(
                              fontSize: 16.sp,
                              color: AppColors.getTextDarkLight(),
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        style: TextStyle(color: AppColors.getTextDarkLight()),
                        controller: myAccountController.lastName,
                        decoration: InputDecoration(
                          hintText:
                              "${selectedLanguageStorage.read("languageData")["lastname"] ?? "lastname"}",
                          hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.appBlackColor50),
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
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Text(
                          "${selectedLanguageStorage.read("languageData")["Email"] ?? "Email"}",
                          style: GoogleFonts.niramit(
                              fontSize: 16.sp,
                              color: AppColors.getTextDarkLight(),
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        readOnly: true,
                        style: TextStyle(color: AppColors.getTextDarkLight()),
                        controller: myAccountController.email,
                        decoration: InputDecoration(
                          hintText:
                              "${selectedLanguageStorage.read("languageData")["Email"] ?? "Email"}",
                          hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.appBlackColor50),
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
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Text(
                          "${selectedLanguageStorage.read("languageData")["Phone"] ?? "Phone"}",
                          style: GoogleFonts.niramit(
                              fontSize: 16.sp,
                              color: AppColors.getTextDarkLight(),
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        style: TextStyle(color: AppColors.getTextDarkLight()),
                        controller: myAccountController.phone,
                        decoration: InputDecoration(
                          hintText:
                              "${selectedLanguageStorage.read("languageData")["address"] ?? "address"}",
                          hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.appBlackColor50),
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
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Text(
                          "${selectedLanguageStorage.read("languageData")["Username"] ?? "Username"}",
                          style: GoogleFonts.niramit(
                              fontSize: 16.sp,
                              color: AppColors.getTextDarkLight(),
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        style: TextStyle(color: AppColors.getTextDarkLight()),
                        controller: myAccountController.userName,
                        decoration: InputDecoration(
                          hintText:
                              "${selectedLanguageStorage.read("languageData")["userName"] ?? "userName"}",
                          hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.appBlackColor50),
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
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Text(
                          "${selectedLanguageStorage.read("languageData")["Address"] ?? "Address"}",
                          style: GoogleFonts.niramit(
                              fontSize: 16.sp,
                              color: AppColors.getTextDarkLight(),
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        style: TextStyle(color: AppColors.getTextDarkLight()),
                        controller: myAccountController.address,
                        decoration: InputDecoration(
                          hintText:
                              "${selectedLanguageStorage.read("languageData")["address"] ?? "address"}",
                          hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.appBlackColor50),
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
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          myAccountController
                              .updateAccountInformation(
                                  myAccountController.firstName.text.toString(),
                                  myAccountController.lastName.text.toString(),
                                  myAccountController.userName.text.toString(),
                                  myAccountController.address.text.toString())
                              .then((value) {
                            myAccountController.getAccountData();
                          });
                        },
                        child: Center(
                          child: Container(
                            height: 50.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColors.appPrimaryColor,
                                borderRadius: BorderRadius.circular(32)),
                            child: Center(
                                child:
                                    myAccountController.isLoadingInformation ==
                                            false
                                        ? Text(
                                            "${selectedLanguageStorage.read("languageData")["Update Information"] ?? "Update Information"}",
                                            style: TextStyle(
                                                color: AppColors.appWhiteColor,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          )
                                        : Center(
                                            child: CircularProgressIndicator(
                                            color: AppColors.appWhiteColor,
                                          ))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
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

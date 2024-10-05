import 'package:flutter/material.dart';
import 'package:flutter_hypro/controller/language_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors/app_colors.dart';

class LanguageScreen extends StatefulWidget {
  static const String routeName = "/languageScreen";
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  dynamic selectedLanguage;

  final selectedLanguageStorage = GetStorage(); // Initialize getStorage

  @override
  void initState() {
    super.initState();
    // Retrieve the selected language from getStorage
    selectedLanguage = selectedLanguageStorage.read('selectedLanguage');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(builder: (languageController) {
      return Scaffold(
        backgroundColor: AppColors.getBackgroundDarkLight(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.getAppBarBgDarkLight(),
          titleSpacing: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,
                size: 25.h, color: AppColors.getTextDarkLight()),
          ),
          automaticallyImplyLeading: false,
          title: Text(
            "${selectedLanguageStorage.read("languageData")["Select Language"] ?? "Select Language"}",
            style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: AppColors.getTextDarkLight(),
            ),
          ),
        ),
        body: languageController.isLoading == false
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ListView.builder(
                  itemCount: languageController.message!.languages!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final language =
                        languageController.message!.languages![index];
                    final isSelected = language.name == selectedLanguage;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.getTextFieldDarkLight(),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                                dense: true,
                                title: Text(
                                  languageController
                                      .message!.languages![index].name
                                      .toString(),
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                trailing: isSelected
                                    ? const Icon(Icons.check,
                                        color: Colors.green)
                                    : null,
                                onTap: () {
                                  setState(() {
                                    selectedLanguage = language
                                        .name; // Update selectedLanguage
                                    selectedLanguageStorage.write(
                                        'selectedLanguage', selectedLanguage);
                                    languageController
                                        .getLanguageDataById(language.id)
                                        .then((value) {
                                      languageController.getLanguageData();
                                    });
                                  });
                                }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      );
    });
  }
}

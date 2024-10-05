import 'package:flutter/material.dart';
import 'package:flutter_hypro/language/storage_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleController extends GetxController {
  final storage = Get.find<StorageService>();
  final RxString local = Get.locale.toString().obs;
  final RxString selectedCurrency = ''.obs;
  final box = GetStorage();

  final Map<String, dynamic> optionsLocales = {
    'en_US': {
      'languageCode': 'en',
      'countryCode': 'US',
      'description': 'English',
    },
    'bn_BD': {
      'languageCode': 'bn',
      'countryCode': 'BD',
      'description': 'বাংলা',
    },
    'hi_IN': {
      'languageCode': 'hi',
      'countryCode': 'IN',
      'description': 'हिंदी',
    },
  };

  void updateLocale(String key) {
    final String languageCode = optionsLocales[key]['languageCode'];
    final String countryCode = optionsLocales[key]['countryCode'];
    Get.updateLocale(Locale(languageCode, countryCode));
    local.value = Get.locale.toString();
    storage.write("languageCode", languageCode);
    storage.write("countryCode", countryCode);
  }
}

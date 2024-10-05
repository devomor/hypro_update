import 'package:flutter/foundation.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/model/response_model/language_data_model.dart';
import '../data/model/response_model/language_model.dart';
import '../data/repository/language_repo.dart';

class LanguageController extends GetxController {
  final LanguageRepo languageRepo;

  LanguageController({required this.languageRepo});

  dynamic _status;

  dynamic get status => _status;
  langaugeData? _message;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingId = false;
  bool get isLoadingId => _isLoadingId;

  langaugeData? get message => _message;

  Map<dynamic, dynamic>? language;

  LanguageModel languageModel = LanguageModel();
  LanguageDataModel languageDataModel = LanguageDataModel();

  Future<dynamic> getLanguageData() async {
    _isLoading = true;
    update();
    ApiResponse apiResponse = await languageRepo.getLanguageData();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        _message = null;
        update();
        languageModel = LanguageModel.fromJson(apiResponse.response!.data!);
        _message = languageModel.message;
        update();
      }
    } else {
      _isLoading = false;
      update();
    }
  }

  Future<dynamic> getLanguageDataById(dynamic id) async {
    _isLoadingId = true;
    update();
    ApiResponse apiResponse = await languageRepo.getLanguageDataById(id);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoadingId = false;
      update();
      if (apiResponse.response!.data != null) {
        _message = null;
        update();
        languageDataModel =
            LanguageDataModel.fromJson(apiResponse.response!.data!);
        language = languageDataModel.language;

        final selectedLanguageStorage = GetStorage();
        selectedLanguageStorage.write("languageData", language);

        if (kDebugMode) {
          print(
              "This is from Storage ${selectedLanguageStorage.read("languageData")["Dashboard"]}");
        }

        update();
      }
    } else {
      _isLoadingId = false;
      update();
    }
  }

  @override
  void onInit() {
    getLanguageData();
    super.onInit();
  }
}

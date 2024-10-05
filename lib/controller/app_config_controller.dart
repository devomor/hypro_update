import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:get/get.dart';

import '../data/model/response_model/app_config_model.dart';
import '../data/repository/app_config_repo.dart';

class AppConfigController extends GetxController {
  final AppConfigRepo appConfigRepo;

  AppConfigController({required this.appConfigRepo});

  dynamic _status;

  dynamic get status => _status;
  ConfigData? _message;
  ConfigData? get message => _message;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AppConfigModel appConfigModel = AppConfigModel();

  Future<dynamic> getConfigData() async {
    _isLoading = true;
    update();
    ApiResponse apiResponse = await appConfigRepo.getConfigData();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        _message = null;
        update();
        appConfigModel = AppConfigModel.fromJson(apiResponse.response!.data!);
        _message = appConfigModel.message;
        update();
      }
    } else {
      _isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    getConfigData();
    super.onInit();
  }
}

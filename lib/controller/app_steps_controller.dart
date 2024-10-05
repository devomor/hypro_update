import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/repository/app_steps_repo.dart';
import 'package:get/get.dart';

import '../data/model/response_model/app_steps_model.dart';

class AppStepsController extends GetxController {
  final AppStepsRepo appStepsRepo;

  AppStepsController({required this.appStepsRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  dynamic _status;

  dynamic get status => _status;
  Message? get message => _message;
  Message? _message;

  AppStepsModel appStepsModel = AppStepsModel();

  Future<dynamic> getAppStepsData() async {
    _isLoading = true;
    update();
    ApiResponse apiResponse = await appStepsRepo.getAppStepsData();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        _message = null;
        update();
        appStepsModel = AppStepsModel.fromJson(apiResponse.response!.data!);
        _message = appStepsModel.message;
        update();
      }
    } else {
      _isLoading = false;
      update();
    }
  }
}

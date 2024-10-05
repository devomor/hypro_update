import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:flutter_hypro/data/repository/pusher_config_repo.dart';
import 'package:get/get.dart';

import '../data/model/response_model/pusher_config_model.dart';

class PusherConfigController extends GetxController {
  final PusherConfigRepo pusherConfigRepo;

  PusherConfigController({required this.pusherConfigRepo});

  dynamic _status;

  dynamic get status => _status;
  PusherConfigData? _message;
  PusherConfigData? get message => _message;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PusherConfigModel pusherConfigModel = PusherConfigModel();

  Future<dynamic> getPusherConfig() async {
    _isLoading = true;
    update();
    ApiResponse apiResponse = await pusherConfigRepo.getPusherConfigData();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        _message = null;
        update();
        pusherConfigModel =
            PusherConfigModel.fromJson(apiResponse.response!.data!);
        _message = pusherConfigModel.message;
        update();
      }
    } else {
      _isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    getPusherConfig();
    super.onInit();
  }
}

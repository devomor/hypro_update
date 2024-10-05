import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter_hypro/utils/strings/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class MyAccountRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  MyAccountRepo({required this.dioClient, required this.sharedPreferences});

  /// Get AccountData
  Future<ApiResponse> getAccountData() async {
    try {
      Response response = await dioClient.get(
        "${AppConstants.myAccountUri}",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${sharedPreferences.getString(AppConstants.token)}",
        }),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  ///Profile Information Update
  Future<ApiResponse> updateAccountInformation(
    dynamic firstName,
    dynamic lastName,
    dynamic userName,
    dynamic address,
  ) async {
    try {
      Response response = await dioClient.post(
        "${AppConstants.accountInformationUpdate}",
        queryParameters: {
          "firstname": firstName,
          "lastname": lastName,
          "username": userName,
          "address": address
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${sharedPreferences.getString(AppConstants.token)}",
        }),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// Update Profile Image
  Future<ApiResponse> updateAccountImage(dynamic path) async {
    dio.FormData formData = dio.FormData.fromMap({
      'image': await dio.MultipartFile.fromFile(path),
    });
    try {
      Response response = await dioClient.post(
        "${AppConstants.accountImageUpload}",
        data: formData,
        options: Options(headers: {
          'Content-Type': 'multipart/form-data',
          "Authorization":
              "Bearer ${sharedPreferences.getString(AppConstants.token)}",
        }),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}

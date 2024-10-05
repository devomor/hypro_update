import 'package:dio/dio.dart';
import 'package:flutter_hypro/utils/strings/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class TwoFaSecurityRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  TwoFaSecurityRepo({required this.dioClient, required this.sharedPreferences});

  ///Two Factor Data
  Future<ApiResponse> getTwoFaSecurityData() async {
    try {
      Response response = await dioClient.get(
        "${AppConstants.twoFactorUri}",
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

  ///Enable Two Factor
  Future<ApiResponse> enableTwoFactorSecurity(
    dynamic code,
    dynamic key,
  ) async {
    try {
      Response response = await dioClient.post(
        "${AppConstants.enableTwoFactorUri}",
        queryParameters: {
          "code": code,
          "key": key,
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

  ///disable Two Factor
  Future<ApiResponse> disableTwoFactorSecurity(dynamic code) async {
    try {
      Response response = await dioClient.post(
        "${AppConstants.disableTwoFactorUri}",
        queryParameters: {
          "code": code,
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
}

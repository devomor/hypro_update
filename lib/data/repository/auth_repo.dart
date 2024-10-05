import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hypro/data/model/base_model/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/strings/app_constants.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> register(
    BuildContext context,
    dynamic firstName,
    dynamic lastName,
    dynamic userName,
    dynamic emailAddress,
    dynamic countryCode,
    dynamic phoneCode,
    dynamic phone,
    dynamic password,
    dynamic confirmPassword,
    dynamic sponsor,
  ) async {
    try {
      Response response = await dioClient.post(
        AppConstants.registerUri,
        queryParameters: {
          "firstname": firstName,
          "lastname": lastName,
          "username": userName,
          "email": emailAddress,
          "country_code": countryCode,
          "phone_code": phoneCode,
          "phone": phone,
          "password": password,
          "password_confirmation": confirmPassword,
          "sponsor": sponsor,
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> login(
      BuildContext context, dynamic userName, dynamic password) async {
    try {
      Response response = await dioClient.post(
        AppConstants.loginUri,
        queryParameters: {"username": userName, "password": password},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> forgetPasswordRequest(
    BuildContext context,
    dynamic email,
  ) async {
    try {
      Response response = await dioClient.post(
        AppConstants.recoveryPasswordGetEmailUri,
        queryParameters: {
          "email": email,
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> recoveryPassCodeRequest(
    BuildContext context,
    dynamic email,
    dynamic code,
  ) async {
    try {
      Response response = await dioClient.post(
        AppConstants.recoveryPassCodeUri,
        queryParameters: {
          "email": email,
          "code": code,
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> forgetPasswordSubmitRequest(
    BuildContext context,
    dynamic pass,
    dynamic passConfirm,
    dynamic email,
  ) async {
    try {
      Response response = await dioClient.post(
        AppConstants.recoveryUpdatePassCodeUri,
        queryParameters: {
          "password": pass,
          "password_confirmation": passConfirm,
          "email": email,
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient.updateHeader(token, "");

    try {
      await sharedPreferences.setString(AppConstants.token, token);
      print("========>Token Stored<=======");
      print(await sharedPreferences.getString(AppConstants.token));
    } catch (e) {
      throw e;
    }
  }

  //save user token in local storage
  getUserToken() {
    SharedPreferences.getInstance();
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  // remove user token from local storage
  removeUserToken() async {
    await SharedPreferences.getInstance();
    return sharedPreferences.remove(AppConstants.token);
  }

  //auth token
  // for  user token
  Future<void> saveAuthToken(String token) async {
    dioClient.token = token;
    dioClient.dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      await sharedPreferences.setString(AppConstants.token, token);
    } catch (e) {
      throw e;
    }
  }

  String getAuthToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }
}

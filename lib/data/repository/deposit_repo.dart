import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter_hypro/utils/strings/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class DepositRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  DepositRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getPaymentMethodData() async {
    try {
      Response response = await dioClient.get(
        "${AppConstants.paymentMethodUri}",
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

  Response? response;

  /// manualPayment
  Future<ApiResponse> manualPaymentRepo(
    dynamic gateway,
    dynamic amount,
    dynamic planId,
    List<dynamic> fieldNames,
    List<dynamic> fieldValues,
  ) async {
    try {
      dio.FormData formData =
          dio.FormData(); // Create FormData for file uploads

      formData.fields.add(MapEntry("gateway", gateway.toString()));
      formData.fields.add(MapEntry("amount", amount.toString()));
      formData.fields.add(MapEntry("plan_id", planId.toString()));

      for (int i = 0; i < fieldNames.length; i++) {
        String fieldName = fieldNames[i];
        dynamic fieldValue = fieldValues[i];

        if (fieldValue is dio.MultipartFile) {
          // If the fieldValue is already a MultipartFile, add it as is
          formData.files.add(
            MapEntry(fieldName, fieldValue),
          );
        } else if (fieldValue is File) {
          // If the fieldValue is a File, create a MultipartFile from it and add it
          formData.files.add(
            MapEntry(
              fieldName,
              await dio.MultipartFile.fromFile(fieldValue.path),
            ),
          );
        } else if (fieldValue is String && _isImageFile(fieldValue)) {
          // If the fieldValue is a String and it represents an image file path, add it as a MultipartFile
          formData.files.add(
            MapEntry(
              fieldName,
              await dio.MultipartFile.fromFile(fieldValue),
            ),
          );
        } else {
          // If it's not an image file or MultipartFile, add it as a regular field
          formData.fields.add(
            MapEntry(fieldName, fieldValue.toString()),
          );
        }
      }

      Response response = await dioClient.post(
        AppConstants.manualPaymentSubmitUri,
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

  bool _isImageFile(String filePath) {
    // Add your logic here to determine if the filePath represents an image file.
    // You can check the file extension, MIME type, or any other method that suits your needs.
    // For simplicity, this example assumes that any string ending with ".jpg" or ".png" is an image file.
    return filePath.endsWith(".jpg") ||
        filePath.endsWith(".png") ||
        filePath.endsWith(".jpeg");
  }

  Future<ApiResponse> sendOtherPaymentRequest(
      dynamic amount, dynamic gatewayId) async {
    try {
      Response response = await dioClient.post(
        AppConstants.otherPayments,
        queryParameters: {
          "amount": amount,
          "gateway": gatewayId,
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

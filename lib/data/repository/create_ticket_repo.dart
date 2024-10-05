import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter_hypro/utils/strings/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class CreateTicketRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  CreateTicketRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> createTicketRequest(
    dynamic subject,
    dynamic message,
    dynamic result,
  ) async {
    List<dio.MultipartFile> files = [];

    for (var path in result) {
      files.addAll([
        dio.MultipartFile.fromFileSync(path,
            filename: path.split('/').last), // Set the desired filename
      ]);
    }

    dio.FormData formData = dio.FormData.fromMap(
      {
        'subject': subject,
        'message': message,
        'attachments[]': files,
      },
    );

    try {
      Response response = await dioClient.post(
        "${AppConstants.createTicketUri}",
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

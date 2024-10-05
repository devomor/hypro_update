import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter_hypro/utils/strings/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class ReplyTicketRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  ReplyTicketRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> replyTicketRequest(
      dynamic id, dynamic message, dynamic replyTicket,
      {dynamic result}) async {
    List<dio.MultipartFile> files = [];

    if (result != null) {
      for (var path in result) {
        files.addAll([
          dio.MultipartFile.fromFileSync(path,
              filename: path.split('/').last), // Set the desired filename
        ]);
      }
    }

    dio.FormData formData;
    dio.FormData formDataCloseTicket;

    if (result != null) {
      formData = dio.FormData.fromMap(
        {
          'id': id ?? '',
          'message': message ?? '',
          'replayTicket': replyTicket ?? '',
          'attachments[]': files,
        },
      );
    } else {
      formData = dio.FormData.fromMap(
        {
          'id': id ?? '',
          'message': message ?? '',
          'replayTicket': replyTicket ?? '',
        },
      );
    }

    formDataCloseTicket = dio.FormData.fromMap(
      {
        'id': id ?? '',
        'replayTicket': replyTicket ?? '',
      },
    );

    try {
      Response response = await dioClient.post(
        "${AppConstants.replyTicketUri}",
        data: message != null ? formData : formDataCloseTicket,
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

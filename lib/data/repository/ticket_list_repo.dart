import 'package:dio/dio.dart';
import 'package:flutter_hypro/utils/strings/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class TicketListRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  TicketListRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getTicketListData(
    dynamic page,
  ) async {
    try {
      Response response = await dioClient.get(
        "${AppConstants.ticketListUri}page=${page}",
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

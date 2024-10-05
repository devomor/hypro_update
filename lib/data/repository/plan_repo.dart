import 'package:dio/dio.dart';
import 'package:flutter_hypro/utils/strings/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class PlanRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  PlanRepo({required this.dioClient, required this.sharedPreferences});

  /// Get Plan Data
  Future<ApiResponse> getPlanData() async {
    try {
      Response response = await dioClient.get(
        "${AppConstants.planUri}",
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

  /// Buy Plan Wallet
  Future<ApiResponse> buyInvestmentPlan(
    dynamic balanceType,
    dynamic amount,
    dynamic planId,
  ) async {
    try {
      Response response = await dioClient.post(
        "${AppConstants.buyPlanWalletUri}",
        queryParameters: {
          "balance_type": balanceType,
          "amount": amount,
          "plan_id": planId,
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

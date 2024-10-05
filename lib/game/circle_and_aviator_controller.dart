import 'dart:convert';

import 'package:flutter_hypro/game/model/chorki_stting_model.dart';
import 'package:flutter_hypro/utils/strings/app_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CirleAndAviatorContoller extends GetxController {
  late SharedPreferences sharedPreferences;
  RxDouble min_amount = RxDouble(0);
  RxDouble max_amount = RxDouble(0);
  RxDouble gameActive = RxDouble(1);

  RxDouble min_amountA = RxDouble(0);
  RxDouble max_amountA = RxDouble(0);
  RxDouble gameActiveA = RxDouble(1);
    var userGameData = [].obs;
  var isLoadingss = false.obs;
  var gameSettings = Rx<GameData?>(null);
  var balance = ''.obs;
  var isLoadings = false.obs;
  var isLoading = false.obs;
  var responseData = {}.obs;
  var errorMessage = ''.obs;
  RxInt gameId = RxInt(0);

  void incrimentAmount() {
    if (max_amount.value >= min_amount.value) {
      min_amount.value += 1.0;
      update();
    }
  }

  void drecrimentAmount() {
    if (min_amount.value > 1.0) {
      min_amount.value -= 1.0;
    } else {
      min_amount.value = 1.0;
    }
    update();
  }

  void incrimentAmountA() {
    if (max_amountA.value >= min_amount.value) {
      min_amountA.value += 1.0;
      update();
    }
  }

  void drecrimentAmountA() {
    if (min_amountA.value > 1.0) {
      min_amountA.value -= 1.0;
    } else {
      min_amountA.value = 1.0;
    }
    update();
  }






  @override
  void onInit() async {
    super.onInit();
    await initSharedPreferences();
    fetchGameSettings();
    fetchGameSettingsAviator();
    fetchUserGameData();
  }

  // Asynchronous method to initialize SharedPreferences
  Future<void> initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print("SharedPreferences initialized.");
  }

  void getBalance() async {
    final url = Uri.parse('https://apps.gulfbdf.xyz/api/user-info');
    isLoadings.value = true;
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${sharedPreferences.getString(AppConstants.token)}",
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = jsonDecode(response.body);
        balance.value = data['balance'];
        update();
        print('Balance: ${data['balance']}');
        isLoadings.value = false;
      } else {
        isLoadings.value = false;
        print('Failed to load balance. Status code: ${response.statusCode}');
      }
    } catch (e) {
      isLoadings.value = false;
      print('Error fetching balance: $e');
    }
  }

  Future<void> initChorkiGame({
    required String spin1,
    required String spin2,
    required String amount,
  }) async {
    Map<String, String> body = {
      "bet_numbers": "${spin1}",
      "bet_amounts": "${amount}",
      "win_numbers": "${spin2}"
    };
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("https://apps.gulfbdf.xyz/api/chorki-game/init"),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${sharedPreferences.getString(AppConstants.token)}",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        responseData.value = jsonDecode(response.body);
        errorMessage.value = '';
        print("Response data: ${responseData.value}");
      } else {
        errorMessage.value = "Error: ${response.statusCode} - ${response.body}";
        print(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  ///aviator game
  Future<void> initAviatorGame({
    required double amount,
  }) async {
    Map<String, dynamic> body = {
      "box": 1,
      "bet_amount": amount,
    };
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("https://apps.gulfbdf.xyz/api/aviator-game/init"),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${sharedPreferences.getString(AppConstants.token)}",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var Data = jsonDecode(response.body);
        responseData.value = jsonDecode(response.body);
        errorMessage.value = '';
        gameId.value = Data['data']['game_id'];
        print('game id ${gameId.value}');
        print("Response data: ${responseData.value}");
      } else {
        errorMessage.value = "Error: ${response.statusCode} - ${response.body}";
        print(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initAviatorGameCancel() async {
    Map<String, dynamic> body = {"box": 1, "game_id": gameId.value};
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("https://apps.gulfbdf.xyz/api/aviator-game/cancel"),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${sharedPreferences.getString(AppConstants.token)}",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        responseData.value = jsonDecode(response.body);
        errorMessage.value = '';
        print("Response data: ${responseData.value}");
      } else {
        errorMessage.value = "Error: ${response.statusCode} - ${response.body}";
        print(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initAviatorGameCashOut({
    required double multiplynumber,
  }) async {
    Map<String, dynamic> body = {
      "game_id": gameId.value,
      "box": 1,
      "multiply_number": multiplynumber,
    };
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("https://apps.gulfbdf.xyz/api/aviator-game/cashout"),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${sharedPreferences.getString(AppConstants.token)}",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        responseData.value = jsonDecode(response.body);
        errorMessage.value = '';
        print("Response data: ${responseData.value}");
      } else {
        errorMessage.value = "Error: ${response.statusCode} - ${response.body}";
        print(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initAviatorGameClose({
    required double amount,
  }) async {
    Map<String, dynamic> body = {
      "game_id":  gameId.value,
      "crash_multiply_number": amount
    };
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("https://apps.gulfbdf.xyz/api/aviator-game/close"),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${sharedPreferences.getString(AppConstants.token)}",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        responseData.value = jsonDecode(response.body);
        errorMessage.value = '';
        print("Response data: ${responseData.value}");
      } else {
        errorMessage.value = "Error: ${response.statusCode} - ${response.body}";
        print(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchGameSettings() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('https://apps.gulfbdf.xyz/api/chorki-game/settings'),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${sharedPreferences.getString(AppConstants.token)}",
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body)['data'];
        min_amount.value = double.tryParse(jsonData['min_bet_amount']) ?? 0;
        max_amount.value = double.tryParse(jsonData['max_bet_amount']) ?? 0;
        gameActive.value = double.tryParse(jsonData['game_active']) ?? 0;
        print('valeu print ${gameActive.value}');
        update();
      } else {
        errorMessage('Failed to load game settings: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

 Future<void> fetchGameSettingsAviator() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('https://apps.gulfbdf.xyz/api/aviator-game/settings'),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${sharedPreferences.getString(AppConstants.token)}",
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body)['data'];
        min_amountA.value = double.tryParse(jsonData['min_bet_amount']) ?? 0;
        max_amountA.value = double.tryParse(jsonData['max_bet_amount']) ?? 0;
        gameActiveA.value = double.tryParse(jsonData['game_active']) ?? 0;
        print('valeu print ${gameActive.value}');
        update();
      } else {
        errorMessage('Failed to load game settings: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Error occurred: $e');
    } finally {
      isLoading(false);
    }
  }




  Future<void> fetchUserGameData() async {
    try {
      isLoading(true); // Set loading to true
      final response = await http.get(
        Uri.parse('https://apps.gulfbdf.xyz/api/getUserGameData'),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${sharedPreferences.getString(AppConstants.token)}",
        },
      );

      if (response.statusCode == 200) {
        userGameData.value = json.decode(response.body)['data'];
        print(" game data check ${userGameData.value}");
      } else {
    
        Get.snackbar('Error', 'Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
          print("error data $e");
      Get.snackbar('Error', 'Error fetching data: $e');
    } finally {
      isLoading(false); // Set loading to false
    }
  }
}

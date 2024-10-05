import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouletteControllers extends GetxController {
  StreamController<int> fortuneWheelNotifier = StreamController<int>();
  bool limitOver = false;
  bool isSubmitted = false;
  int? isWinners;
  RxInt isSpineValue = RxInt(0);
  late AnimationController animationController;
  List<String> name = [];
  int rotationCount = 100;
  int roatationDuration = 5;
  bool isLoading = false;
  bool isWinner = false;
  bool isSpinningValue = false;
  bool isBetValueSelected = false;
  var bets = [];
  var gameStatus = "none";
  late AudioPlayer audioController;

  void onInit() {
    super.onInit();
    fortuneWheelNotifier =
        StreamController<int>.broadcast(); // Convert to broadcast stream
    audioController = AudioPlayer();
  }

  var adminSelectedNum;
  int adminSelectedIndex = 4;
  int spinResult = 0;
  Future<void> getSpinData() async {
    name.clear();
    isLoading = true;
    update();
    name.addAll([
      "0",
      "1",
      "2",
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
    ]);
    isLoading = false;
    update();
  }

  void setIsSpinning(bool isSpinning) {
    isSpinningValue = isSpinning;
    update();
  }

  play() {
    roatationDuration = 9;
    int value = Random().nextInt(name.length);
    fortuneWheelNotifier.add(value);
    isWinners = value;
    Timer(Duration(seconds: roatationDuration), () {
      audioController.stop();
    });

    update();
  }

  @override
  void dispose() {
    super.dispose();
    audioController.stop();
    fortuneWheelNotifier.close();
    isBetValueSelected = false;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_hypro/game/circle_and_aviator_controller.dart';
import 'package:flutter_hypro/game/colors.dart';
import 'package:flutter_hypro/game/game_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSpinWheel extends StatefulWidget {
  const CustomSpinWheel({super.key});
  @override
  State<CustomSpinWheel> createState() => _CustomSpinWheelState();
}

class _CustomSpinWheelState extends State<CustomSpinWheel>
    with TickerProviderStateMixin {
  late final AnimationController _defaultLottieController;
  late final AnimationController _coinsLottieController;
  late final AnimationController _goldenConfettiLottieController;

  final controller = Get.find<RouletteControllers>();
  final gameController = Get.put(CirleAndAviatorContoller());
  @override
  void initState() {
    _defaultLottieController = AnimationController(vsync: this)
      ..duration = Duration(seconds: controller.roatationDuration);
    _coinsLottieController = AnimationController(vsync: this)
      ..duration = Duration(seconds: controller.roatationDuration);
    _goldenConfettiLottieController = AnimationController(vsync: this)
      ..duration = Duration(seconds: controller.roatationDuration);

    super.initState();
    controller.getSpinData();
  }

  List<Color> colorList = [
    Color(0xFFDBFBA1),
    Color(0xFFFAF2CD),
    Color(0xFFFFD582),
    Color(0xFFFFB651),
    Color(0xFFFF762C),
    Color(0xFFEE356D),
    Color(0xFF1A62A1),
    Color(0xFF00BCEA),
  ];
  @override
  void dispose() {
    _coinsLottieController.dispose();
    _goldenConfettiLottieController.dispose();
    _defaultLottieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var wheelSize = size.width / 3;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        //NEW CODE
        GetBuilder<RouletteControllers>(builder: (controller) {
          if (controller.limitOver) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              controller.fortuneWheelNotifier.close();
            });
          }
          return AbsorbPointer(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/images/Circale.png",
                  height: 312,
                  width: 315,
                  fit: BoxFit.fill,
                ),
                controller.name.isEmpty
                    ? const SizedBox()
                    : Stack(
                        children: [
                          SizedBox(
                            // height: wheelSize / 1.156,
                            // width: wheelSize / 1.156,
                            height: 270,
                            width: 400,
                            child: FortuneWheel(
                              animateFirst: false,
                              duration: Duration(
                                  seconds: controller.roatationDuration),
                              selected: controller.fortuneWheelNotifier.stream,
                              rotationCount: controller.rotationCount,
                              indicators: const [],
                              items: List.generate(
                                controller.name.length,
                                (index) {
                                  String number =
                                      formatNumber(controller.name[index])
                                          .replaceAll(".00", "");
                                  bool isEven = index.isEven;

                                  return FortuneItem(
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        "${number.tr}",
                                        textAlign: TextAlign.end,
                                        style: GoogleFonts.crimsonText(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    style: FortuneItemStyle(
                                      color: colorList[index %
                                          colorList
                                              .length], // Select color based on index
                                      borderColor: MyColor.transparentColor,
                                      textStyle: TextStyle(
                                        fontFamily: 'Semakin',
                                        color: MyColor.primaryTextColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 40,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              onAnimationEnd: () async {
                                await gameController.initChorkiGame(
                                  spin1: controller.isWinners.toString(),
                                  spin2:
                                      controller.isSpineValue!.value.toString(),
                                  amount: gameController.min_amount.value
                                      .toString(),
                                );
                                showGameWinnerDialog(
                                    context,
                                    controller.isWinners ?? 0,
                                    controller.isSpineValue!.value);
                                gameController.getBalance();
                              },
                              onAnimationStart: () {
                                // Handle any start logic here if needed
                              },
                            ),
                          ),
                        ],
                      ),
                Positioned.fill(
                  top: 70,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      "assets/images/Spinpointer.png",
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String formatNumber(String value, {int precision = 2}) {
    try {
      double number = double.parse(value);
      String b = number.toStringAsFixed(precision);
      return b;
    } catch (e) {
      return value;
    }
  }

  void showGameWinnerDialog(BuildContext context, int selectvalue, int winner) {
    // Determine colors and messages based on the score or winner
    Color dialogColor;
    String message;
    String message1;

    if (selectvalue == winner) {
      dialogColor = Colors.green;
      message1 = "Game Winner";
      message = "You played amazingly!";
    } else {
      dialogColor = Colors.red;
      message1 = "Game Loss";
      message = "Better luck next time!";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: dialogColor,
          title: Text(
            message1,
            style: TextStyle(
              color: Colors.white, // Title text color
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message, // Custom message based on score
                style: TextStyle(
                  color: Colors.white, // Message text color
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white), // Button text color
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

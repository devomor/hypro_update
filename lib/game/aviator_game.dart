import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hypro/game/circle_and_aviator_controller.dart';
import 'package:get/get.dart';

class AviatorGameScreen extends StatefulWidget {
  @override
  _AviatorGameScreenState createState() => _AviatorGameScreenState();
}

class _AviatorGameScreenState extends State<AviatorGameScreen>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  late AnimationController _moveController;
  late AnimationController _verticalController;
  Animation<double>? _animation;
  late Animation<double> _animation1;
  late Animation<double> _verticalAnimation;
  final gameController = Get.put(CirleAndAviatorContoller());
  TextEditingController inputController = TextEditingController();

  bool isFading = false;
  bool _isDelayActive = false;
  bool _isGameInit = false;
  bool _startGame = false;

  List<Map<double, double>> datalist = [
    {
      1.0: 0.001,
      0.0: 30.0,
    },
    {
      1.0: 0.700,
      0.0: 3000.0,
    },
    {
      1.0: 0.500,
      0.0: 2000.0,
    },
    {
      1.0: 0.300,
      0.0: 1500.0,
    },
    {
      1.0: 0.200,
      0.0: 1000.0,
    },
    {
      1.0: 0.100,
      0.0: 500.0,
    },
    {
      1.0: 0.800,
      0.0: 4000.0,
    },
  ];

  // double getRandomValue(List<double> list) {
  //   final random = Random();
  //   int index = random.nextInt(list.length);
  //   return list[index];
  // }
  double? getRandomValueFromMap(double type) {
    final random = Random();
    int index = random.nextInt(datalist.length); // Get a random index
    if (type == 1 || type == 0) {
      return datalist[index][type]; // Access the value by the key (0 or 1)
    } else {
      throw ArgumentError("Invalid type key. Use 0 or 1.");
    }
  }

  @override
  void initState() {
    super.initState();
    gameController.getBalance();
    gameController.fetchUserGameData();
    gameController.min_amountA.value = 1;
    inputController.text = gameController.min_amountA.value.toString();

    // Initialize the main animation controller
    // var time = getRandomValueFromMap(0.0);
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: time!.toInt()),
    // );
    initeGameMethod();

    // Initialize the move animation controller
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Initialize the vertical animation controller
    _verticalController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true); // Repeat the animation in reverse

    // Main animation for moving the plane getRandomValue(datalist)
    // _animation =
    //     Tween<double>(begin: 0, end: getRandomValueFromMap(1.0)).animate(
    //   CurvedAnimation(
    //     parent: _controller!,
    //     curve: FastSlowFastCurve(),
    //   ),
    // )..addListener(() {
    //         setState(() {});
    //       });

    // Define the move animation
    _animation1 = Tween<double>(begin: 0, end: 900).animate(
      CurvedAnimation(
        parent: _moveController,
        curve: Curves.linear,
      ),
    )..addListener(() {
        setState(() {});
      });

    // Define the vertical animation
    _verticalAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _verticalController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    // _controller!.forward();

    Timer.periodic(Duration(seconds: 15), (Timer timer) {
      print('game start');
      setState(() {
        _isGameInit == true ? _startGame = true : _startGame = false;
        _isGameInit = false;
        _isDelayActive = false;
        isFading = false;
      });
      _moveController.reset();
      initeGameMethod();
    });
  }

  void initeGameMethod() {
    print('game start 1');
    var time = getRandomValueFromMap(0.0);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: time!.toInt()),
    );
    _controller!.forward();
    _animation =
        Tween<double>(begin: 0, end: getRandomValueFromMap(1.0)).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: FastSlowFastCurve(),
      )..addListener(() {
          setState(() {});
        }),
    );

    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print('game end');
        setState(() {
          isFading = true;
          _startGame = false;
          _moveController.forward();
          _verticalController.stop();
          // _controller!.reset();
        });
        // double calculatedValue = (_animation.value * 5 + 1);
        double calculatedValue = (_animation!.value * 5 + 1);
        double formattedValue =
            double.parse(calculatedValue.toStringAsFixed(2));
        gameController.initAviatorGameClose(
          amount: formattedValue,
        );
        gameController.fetchUserGameData();
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isDelayActive = true;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _moveController.dispose();
    _controller!.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF0D0101),
        title: Text(
          "AirBorne",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        actions: [
          Obx(() {
            if (gameController.isLoadings.value) {
              return Container(
                height: 10,
                width: 10,
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(right: 40),
                child: Text(
                  "Balance: \$${gameController.balance}",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            }
          }),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D0101),
              Color(0xFF1B1C1D),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = MediaQuery.of(context).size.width;
                double screenHeight = MediaQuery.of(context).size.height;
                return Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      // margin: EdgeInsets.only(left: screenWidth * 0.01),
                      padding: EdgeInsets.only(
                          bottom: screenHeight * 0.03,
                          left: screenWidth * 0.05),
                      height: screenHeight * 0.3, // Adjust height
                      width: double.infinity, // Adjust width
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/aviator_game/960x540 Background.gif'),
                          opacity: 0.8,
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: isFading != true
                          ? CustomPaint(
                              painter: GraphPainter(
                                  progress: _animation!.value.clamp(0.0, 1.0),
                                  // progres1: (double.parse(
                                  //             (_animation.value * 5 + 1)
                                  //                 .toStringAsFixed(2)) >=
                                  //         3.00
                                  //     ? _verticalAnimation.value * 0.5
                                  //     : 0.3),
                                  progres1: 0.500),
                              size: Size.infinite,
                            )
                          : Container(
                              // alignment: Alignment(30, 30),
                              height: screenHeight * 0.3, // Adjust height
                              width: double.infinity,
                              decoration:
                                  BoxDecoration(color: Colors.transparent),
                              child: Stack(
                                children: [
                                  _isDelayActive != true
                                      ? Positioned(
                                          top: screenHeight *
                                              0.070, // Positioning the multiplier based on screen height
                                          left: screenWidth * 0.250,
                                          child: Text(
                                            "Flew away!",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 30),
                                          ))
                                      : Positioned(
                                          // top: screenHeight *
                                          //     0.070, // Positioning the multiplier based on screen height
                                          // left: screenWidth * 0.050,
                                          child: Image.asset(
                                            "assets/aviator_game/Loading New.gif",
                                          ),
                                        )
                                ],
                              ),
                            ),
                    ),
                    Positioned(
                      left: _animation!.value * screenWidth * 0.9,
                      bottom: _animation!.value * screenHeight * 0.1,
                      child: AnimatedBuilder(
                        animation: _animation!,
                        builder: (context, child) {
                          // Apply horizontal movement
                          final movement = Offset(_animation1.value, 0);
                          return Transform.translate(
                            offset: movement,
                            child: child,
                          );
                        },
                        child: Transform.rotate(
                          angle: -4700,
                          child: Image.asset(
                            'assets/aviator_game/Airborne-plane-animation.gif',
                            height: 110,
                            width: 110,
                          ),
                        ),
                      ),
                    ),
                    _isDelayActive != true
                        ? Positioned(
                            top: screenHeight *
                                0.118, // Positioning the multiplier based on screen height
                            left: screenWidth *
                                0.360, // Positioning multiplier based on screen width
                            child: Text(
                              '${(_animation!.value * 5 + 1).toStringAsFixed(2)}x',
                              style: const TextStyle(
                                fontSize:
                                    36, // Adjust font size relative to screen height
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  height: 50,
                  width: 250,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          gameController.drecrimentAmountA();
                          setState(() {
                            inputController.text =
                                gameController.min_amountA.value.toString();
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border:
                                  Border.all(width: 2, color: Colors.white)),
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          width: 50,
                          // margin: const EdgeInsets.only(bottom: 16.0),
                          child: TextField(
                            controller: inputController,
                            cursorColor: Colors.white,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white), // Text color set to white
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                    color: Colors
                                        .white), // Border color set to white
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2.0), // Enabled border color white
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2.0), // Focused border color white
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 14.0),
                              filled: true,
                              fillColor: Colors.transparent,
                              // Transparent background
                              hintText: 'Amount',
                              hintStyle: TextStyle(
                                  color: Colors
                                      .white70), // Hint text color set to a lighter white
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      InkWell(
                        onTap: () async {
                          gameController.incrimentAmountA();
                          setState(() {
                            inputController.text =
                                gameController.min_amountA.value.toString();
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border:
                                  Border.all(width: 2, color: Colors.white)),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                _startGame == true
                    ? InkWell(
                        onTap: () async {
                          setState(() {
                            _startGame = false;
                          });
                          double calculatedValue = (_animation!.value * 5 + 1);
                          double formattedValue =
                              double.parse(calculatedValue.toStringAsFixed(2));
                          print(formattedValue);
                          await gameController.initAviatorGameCashOut(
                              multiplynumber: formattedValue);

                          // if (_isDelayActive == true) {
                          //   setState(() {
                          //     _isGameInit = !_isGameInit;
                          //   });
                          // }
                          gameController.fetchUserGameData();
                          print("init not");

                          // showTopSnackBar(context,
                          //     'Bet Widrow ${calculatedValue.toStringAsFixed(2)}');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Text(
                                "CashOut",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  "\$${(_animation!.value * 5 + 1).toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20)),
                            ],
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          if (_isDelayActive == true) {
                            setState(() {
                              _isGameInit = !_isGameInit;
                            });

                            if (_isGameInit == true) {
                              await gameController.initAviatorGame(
                                  amount: gameController.min_amountA.value);
                            } else {
                              gameController.initAviatorGameCancel();
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 120,
                          decoration: BoxDecoration(
                              color: _isGameInit == true
                                  ? Colors.red
                                  : Colors.green,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            _isGameInit == true ? "Cancel" : "Place Bet",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 350,
              width: double.infinity,
              child: Obx(() {
                if (gameController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (gameController.userGameData.isEmpty) {
                  return Center(child: Text('No game data available.'));
                } else {
                  return ListView.builder(
                      itemCount: gameController.userGameData.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(
                                radius: 20, // Adjust the size of the circle
                                backgroundImage: NetworkImage(
                                  "${gameController.userGameData[index]['user']['image']}", // Replace with your image URL
                                ),
                                onBackgroundImageError: (error, stackTrace) {
                                  // Handle error when the image fails to load
                                  print("Image failed to load");
                                },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${gameController.userGameData[index]['user']['name']}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                      "@${gameController.userGameData[index]['user']['username']}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13))
                                ],
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 25,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: gameController.userGameData[index]
                                                ['box1']['win_loss'] ==
                                            "2"
                                        ? Colors.red // Win (value 2)
                                        : gameController.userGameData[index]
                                                    ['box1']['win_loss'] ==
                                                "1"
                                            ? Colors.green // Loss (value 1)
                                            : Colors.yellow,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  gameController.userGameData[index]['box1']
                                              ['win_loss'] ==
                                          '2'
                                      ? "Loss"
                                      : gameController.userGameData[index]
                                                  ['box1']['win_loss'] ==
                                              '1'
                                          ? "Win"
                                          : "Pending",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: [
                                  Text(
                                      "Bet: ${gameController.userGameData[index]['box1']!['bet_amount'] != null ? "\$${(double.tryParse(gameController.userGameData[index]['box1']!['bet_amount']) ?? 0.0).toStringAsFixed(2)}" : "\$0.00"}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                  gameController.userGameData[index]
                                              ['box1']!['win_amount'] !=
                                          null
                                      ? Text(
                                          "Win: ${gameController.userGameData[index]['box1']!['bet_amount'] != null ? "\$${(double.tryParse(gameController.userGameData[index]['box1']!['win_amount']) ?? 0.0).toStringAsFixed(2)}" : "\$0.00"}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12))
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ],
                          ),
                        );

                        //         return ListTile(
                        //           title: Text(
                        //             "${gameController.userGameData[index]['user']['name']}",
                        //             style: TextStyle(color: Colors.white,fontSize: 12),
                        //           ),
                        //                leading: CircleAvatar(
                        //   radius: 25, // Adjust the size of the circle
                        //   backgroundImage: NetworkImage(
                        //    "${gameController.userGameData[index]['user']['image']}", // Replace with your image URL
                        //   ),
                        //   onBackgroundImageError: (error, stackTrace) {
                        //     // Handle error when the image fails to load
                        //     print("Image failed to load");
                        //   },
                        // ),
                        //           subtitle: Text("@${gameController.userGameData[index]['user']['username']}",
                        //               style: TextStyle(color: Colors.white,fontSize: 13)),
                        //           trailing: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.end,
                        //             mainAxisAlignment: MainAxisAlignment.end,
                        //             children: [
                        //               Text(
                        //                   " Bet: ${gameController.userGameData[index]['box1']!['bet_amount'] != null
                        //                 ? "\$${(double.tryParse(gameController.userGameData[index]['box1']!['bet_amount']) ?? 0.0).toStringAsFixed(2)}"
                        //                 : "\$0.00"}       Win: ${gameController.userGameData[index]['box1']!['win_amount'] != null
                        //                 ? "\$${(double.tryParse(gameController.userGameData[index]['box1']!['win_amount']) ?? 0.0).toStringAsFixed(2)}"
                        //                 : "\$0.00"}",
                        //               style: TextStyle(color: Colors.white)),
                        //                  Text( "${gameController.userGameData[index]['box1']['win_loss']}",style: TextStyle(color: Colors.white))
                        //             ],
                        //           )
                        //         );
                      });

                  // return Center(
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text('Bet Amount: \$${betAmount.toString()}'),
                  //       Text('Win/Loss: ${winLoss == 1 ? "Win" : "Loss"}'),
                  //     ],
                  //   ),
                  // );
                }
              }),
            )
          ],
        ),
      ),
    );
  }

  void showTopSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context); // Access the Overlay

    // Create the Snackbar widget
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Position near the top
        left: 10,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blueAccent, // Background color
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.close, color: Colors.white),
                //   onPressed: () {
                //
                //      overlayEntry.remove();  // Close the Snackbar
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );

    // Insert the Snackbar into the Overlay
    overlay?.insert(overlayEntry);

    // Automatically remove after a few seconds
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}

// class FastSlowFastCurve extends Curve {
//   @override
//   double transform(double t) {
//     print(t);
//     if (t < 0.5) {
//       // First half: fast start
//       return Curves.fastOutSlowIn.transform(t * 2) / 2;
//     } else {
//       // Second half: fast end
//       return 0.5 + Curves.fastOutSlowIn.transform((t - 0.5) * 2) / 2;
//     }
//   }
// }
class FastSlowFastCurve extends Curve {
  @override
  double transform(double t) {
    if (t < 0.5) {
      // First half: fast start
      return Curves.linear.transform(t * 2) / 2;
    } else {
      // Second half: fast end (keeping it fast at the end)
      return 0.5 + Curves.linear.transform((t - 0.5) * 2) / 2;
    }
  }
}

class GraphPainter extends CustomPainter {
  final double progress;
  final double progres1;

  GraphPainter({required this.progress, required this.progres1});

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for the fill color with shadow
    Paint paint = Paint()
      ..color = Colors.red.withOpacity(0.5) // Fill color with opacity
      ..style = PaintingStyle.fill; // Fill the path

    // Create the graph path
    Path path = Path();
    path.moveTo(0, size.height); // Start from bottom-left
    path.quadraticBezierTo(
      size.width * progress, // Control point X
      size.height * (1 - progress * progres1), // Control point Y
      size.width * progress, // End point X
      size.height * (1 - progress * progres1), // End point Y
    );
    path.lineTo(size.width * progress, size.height);
    path.close(); // Close the path for the fill

    // Draw the shadow with the same path
    canvas.drawShadow(path, Colors.black, 6.0, false);

    // Draw the filled path
    canvas.drawPath(path, paint);

    // Paint for the border (left and top only)
    Paint borderPaint = Paint()
      ..color = Colors.red // Border color
      ..style = PaintingStyle.stroke // Stroke style for the border
      ..strokeWidth = 6; // Border width

    // Path for the border (only on left and top)
    Path borderPath = Path();
    borderPath.moveTo(0, size.height); // Start from bottom-left
    borderPath.quadraticBezierTo(
      size.width * progress, // Control point X
      size.height * (1 - progress * progres1),
      size.width * progress, // End point X
      size.height * (1 - progress * progres1), // End point Y
    );

    // Draw the border on the left and top only
    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

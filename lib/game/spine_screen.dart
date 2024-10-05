import 'package:flutter/material.dart';
import 'package:flutter_hypro/game/circle_and_aviator_controller.dart';
import 'package:flutter_hypro/game/game_controller.dart';
import 'package:flutter_hypro/game/game_screen.dart';
import 'package:get/get.dart';

class SpineScreen extends StatefulWidget {
  const SpineScreen({super.key});

  @override
  State<SpineScreen> createState() => _SpineScreenState();
}

class _SpineScreenState extends State<SpineScreen> {
  final controller = Get.put(RouletteControllers());
  final gameController = Get.put(CirleAndAviatorContoller());

  TextEditingController inputController = TextEditingController();
  String? selectedValue;

  List<String> dropdownItems = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];

  @override
  void initState() {
    // TODO: implement initState
    controller.getSpinData();
    super.initState();
    gameController.min_amount.value = 1;
    inputController.text = gameController.min_amount.value.toString();
    gameController.initSharedPreferences();
    gameController.getBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00BCEA),
      appBar: AppBar(
        backgroundColor: Color(0xFF00BCEA),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Spin Game ",
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFABECFC),
              Color(0xFF00BCEA),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [CustomSpinWheel()],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 1)),
                        child: DropdownButton<String>(
                          value: selectedValue,
                          hint: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('Spin',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ),
                          isExpanded: true,
                          // Makes dropdown fill available width
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          dropdownColor: Colors.transparent,
                          iconSize: 24,
                          elevation: 16,

                          items: dropdownItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  alignment: Alignment.center,
                                  // Custom background color
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.lightBlueAccent.withOpacity(0.2),
                                  ),
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ));
                          }).toList(),
                          onChanged: (String? newValue) {
                            print(newValue);
                            setState(() {
                              selectedValue = newValue;
                              controller.isSpineValue?.value =
                                  int.tryParse(newValue ?? '') ?? 0;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              gameController.drecrimentAmount();
                              setState(() {
                                inputController.text =
                                    gameController.min_amount.value.toString();
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      width: 2, color: Colors.white)),
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
                                style: TextStyle(color: Colors.white),
                                // Text color set to white
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
                                        width:
                                            2.0), // Enabled border color white
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                        color: Colors.white,
                                        width:
                                            2.0), // Focused border color white
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
                              gameController.incrimentAmount();
                              setState(() {
                                inputController.text =
                                    gameController.min_amount.value.toString();
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      width: 2, color: Colors.white)),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    if (selectedValue != null &&
                        (int.tryParse(gameController.balance.value) ?? 0) <=
                            100) {
                      controller.play();
                    } else {
                      showSnackBar(context,
                          'Either no value is selected or balance is insufficient.');
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    // Increased height for a more prominent button
                    width: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF00B4DB),
                          // Start color (you can replace with your choice)
                          Color(0xFF0083B0)
                        ], // Gradient colors for a gaming effect
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                          30), // Rounded edges for a modern look
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 4), // Shadow for depth effect
                        ),
                      ],
                    ),
                    child: Text(
                      "Spin Play",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22, // Larger font size
                        fontWeight: FontWeight.bold, // Bold for more emphasis
                        letterSpacing:
                            2.0, // Spacing between letters for a futuristic look
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration:
          Duration(seconds: 3), // Set how long the Snackbar will be visible
      action: SnackBarAction(
        label: 'Undo', // Optional action button
        onPressed: () {
          // Perform some action when "Undo" is pressed
        },
      ),
    );

    // Show the Snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

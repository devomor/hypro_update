import 'package:flutter/material.dart';
import 'package:flutter_hypro/view/screens/menu/menu_screen.dart';
import 'package:get/get.dart';

import '../view/screens/dashboard/dashboard_sreen.dart';
import '../view/screens/plan/plan_screen.dart';
import '../view/screens/transaction/transaction_history_screen.dart';
import '../view/screens/transfer/transfer_screen.dart';

class BottomNavController extends GetxController {
  int selectedIndex = 0;
  List<Widget> screens = [
    DashBoardScreen(),
    PlanScreen(),
    TransferScreen(),
    TransactionHistoryScreen(),
    MenuScreen(),
  ];

  Widget get currentScreen => screens[selectedIndex];

  void changeScreen(int index) {
    selectedIndex = index;
    update();
  }
}

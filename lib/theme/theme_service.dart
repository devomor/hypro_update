
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxController{
final getStorage = GetStorage();
final storageKey = "isDarkMode";
final switchStateKey = "isSwitched";

ThemeMode getThemeMode(){
  return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
}

bool isSavedDarkMode(){
  return getStorage.read(storageKey)?? false;
}

void saveThemeMode(bool isDarkMode){
 getStorage.write(storageKey, isDarkMode);
}

// Add a method to save the switch state
void saveThemeSwitchState(bool isSwitched) {
  getStorage.write(switchStateKey, isSwitched);
}

// Add a method to retrieve the switch state
bool getThemeSwitchState() {
  return getStorage.read(switchStateKey) ?? false;
}

void changeThemeMode(){
  Get.changeThemeMode(isSavedDarkMode()? ThemeMode.light : ThemeMode.dark);
  saveThemeMode(!isSavedDarkMode());
}

}
import 'dart:developer';

import 'package:fireflyai/core/constants/my_pref_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'my_colors.dart';

class ThemeController extends GetxController {
  //
  final _box = GetStorage();

  final isDark = false.obs;
  final primary = MyColors.pink.obs;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  bool get _isDarkMode => _box.read(MyPrefKeys.isDarkMode) ?? false;

  configureTheme() {
    log('------------------------- configuring Dark Theme page ----------------------');
    if (_isDarkMode) {
      isDark(true);
      primary(MyColors.lightPurple);
    }
  }

  toggleThemeMode() {
    if (Get.isDarkMode) {
      /// ------------------------------- `LIGHT`
      isDark(false);
      Get.changeThemeMode(ThemeMode.light);
      _box.write(MyPrefKeys.isDarkMode, false);
      primary(MyColors.pink);
    } else {
      /// ------------------------------- `DARK`
      isDark(true);
      Get.changeThemeMode(ThemeMode.dark);
      _box.write(MyPrefKeys.isDarkMode, true);
      primary(MyColors.lightPurple);
    }
  }
}

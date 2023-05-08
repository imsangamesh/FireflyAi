import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyColors {
  static const white = Colors.white;
  static const black = Color(0xFF030723);
  static const green = Color(0xFF00A005);
  static const grey = Color(0xFFAAAAAA);
  static const midGrey = Color(0xFF5A5A5A);
  static const greySmoke = Color(0xDCFFFFFF);

  static const pink = Color(0xffFF8FB1);
  static const orangePink = Color(0xffFEBEB1);
  static const purple = Color(0xff7A4495);
  static const emerald = Color(0xff647E68);
  static const wheatGrey = Color(0xffDCD7C9);
  static const wheat = Color(0xffF2DEBA);

  /// ------------------------------------------------------ `light theme`
  static const lightScaffoldBG = Color.fromARGB(255, 255, 251, 243);
  static const lightPink = Color(0xffffc6d7);
  static const lightListTile = Color(0xFFFFE2EA);

  /// ------------------------------------------------------ `dark theme`
  static const darkScaffoldBG = Color(0xFF03071B);
  static final darkListTile = const Color(0xffBA94D1).withAlpha(25);

  /// ------------------------------------------------------ `dark`
  static const darkPink = Color(0xffde004a);
  static const lightPurple = Color(0xffBA94D1);
  static const darkPurple = Color(0xff18142c);

  // static const darkBlue = Color(0xffC060A1);
  // static const darkBlue = Color.fromARGB(255, 76, 46, 95);

  /// ------------------------------------------------------ `intermediate`
  static const midPink = Color(0xFFEC407A);
  static const midPurple = Color(0xFF382F5F);

  static primary(int a) => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(a)
      : MyColors.pink.withAlpha(a);
}

class ThemeColors {
  /// ------------------------------------------------------ `PRIMS`
  static get prim1 => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(255)
      : MyColors.pink.withAlpha(255);

  static get prim2 => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(200)
      : MyColors.pink.withAlpha(200);

  static get prim3 => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(150)
      : MyColors.pink.withAlpha(150);

  static get prim4 => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(100)
      : MyColors.pink.withAlpha(100);

  /// ------------------------------------------------------ `SHADES`
  static get shade1 => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(35)
      : MyColors.pink.withAlpha(35);

  static get shade2 => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(20)
      : MyColors.pink.withAlpha(25);

  static get shade3 => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(15)
      : MyColors.pink.withAlpha(15);

  /// ------------------------------------------------------ `GENERAL`
  static primary(int a) => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(a)
      : MyColors.pink.withAlpha(a);

  static get scaffold =>
      Get.isDarkMode ? MyColors.darkScaffoldBG : MyColors.lightScaffoldBG;

  static get listTile => Get.isDarkMode
      ? const Color(0xffBA94D1).withAlpha(25)
      : const Color(0xFFFFE2EA);

  static get midPrim => Get.isDarkMode ? MyColors.midPurple : MyColors.midPink;

  static get textColor =>
      Get.isDarkMode ? const Color(0xffffffff) : const Color(0xff000000);
}

// 1 playfairDisplay
// 1 berkshireSwash
// 2 quicksand
// 3 zillaSlab - M

// amatic sc

import 'package:fireflyai/core/themes/my_colors.dart';
import 'package:fireflyai/core/themes/my_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemes {
  //
  // *=========================================================== `LIGHT`
  static final lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(primary: MyColors.pink),
    scaffoldBackgroundColor: MyColors.lightScaffoldBG,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: MyColors.pink,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: MyColors.lightScaffoldBG,
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: GoogleFonts.quicksand(
          textStyle: MyTStyles.kTS20Regular.copyWith(
        fontWeight: FontWeight.w500,
        color: MyColors.black,
      )),
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: MyColors.lightScaffoldBG,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: MyColors.lightScaffoldBG,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: MyColors.midPink,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: MyColors.lightListTile,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      suffixIconColor: MyColors.midPink,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink, width: 2),
      ),
      activeIndicatorBorder: BorderSide(color: Colors.pink, width: 2),
    ),
    textTheme: GoogleFonts.rubikTextTheme().copyWith(
      bodyMedium: const TextStyle(color: Colors.black),
      bodyLarge: const TextStyle(color: Colors.black),
      displayLarge: const TextStyle(color: Colors.black),
      displayMedium: const TextStyle(color: Colors.black),
      displaySmall: const TextStyle(color: Colors.black),
      headlineMedium: const TextStyle(color: Colors.black),
      headlineSmall: const TextStyle(color: Colors.black),
      titleLarge: const TextStyle(color: Colors.black),
      titleMedium: const TextStyle(color: Colors.black),
      titleSmall: const TextStyle(color: Colors.black),
    ),
  );

  // *=========================================================== `DARK`
  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(primary: MyColors.lightPurple),
    scaffoldBackgroundColor: MyColors.darkScaffoldBG,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: MyColors.lightPurple,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: MyColors.darkScaffoldBG,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: MyColors.lightPurple,
      titleTextStyle: GoogleFonts.quicksand(
        textStyle: MyTStyles.kTS20Regular.copyWith(
          fontWeight: FontWeight.w500,
          color: MyColors.black,
        ),
      ),
      centerTitle: true,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: MyColors.darkScaffoldBG,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: MyColors.darkScaffoldBG,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: MyColors.lightPurple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: MyColors.darkListTile,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      suffixIconColor: MyColors.midPurple,
    ),
    textTheme: GoogleFonts.rubikTextTheme().copyWith(
      bodyMedium: const TextStyle(color: Colors.white),
      bodyLarge: const TextStyle(color: Colors.white),
      displayLarge: const TextStyle(color: Colors.white),
      displayMedium: const TextStyle(color: Colors.white),
      displaySmall: const TextStyle(color: Colors.white),
      headlineMedium: const TextStyle(color: Colors.white),
      headlineSmall: const TextStyle(color: Colors.white),
      titleLarge: const TextStyle(color: Colors.white),
      titleMedium: const TextStyle(color: Colors.white),
      titleSmall: const TextStyle(color: Colors.white),
    ),
  );
}

/*
bodyText2: const TextStyle(color: Colors.black),
bodyLarge: const TextStyle(color: Colors.black),
bodyMedium: const TextStyle(color: Colors.black),
bodySmall: const TextStyle(color: Colors.black),
bodyText1: const TextStyle(color: Colors.black),
displayLarge: const TextStyle(color: Colors.black),
displayMedium: const TextStyle(color: Colors.black),
displaySmall: const TextStyle(color: Colors.black),
headline1: const TextStyle(color: Colors.black),
headline2: const TextStyle(color: Colors.black),
headline3: const TextStyle(color: Colors.black),
headline4: const TextStyle(color: Colors.black),
headline5: const TextStyle(color: Colors.black),
headline6: const TextStyle(color: Colors.black),
headlineLarge: const TextStyle(color: Colors.black),
headlineMedium: const TextStyle(color: Colors.black),
headlineSmall: const TextStyle(color: Colors.black),
labelLarge: const TextStyle(color: Colors.black),
labelMedium: const TextStyle(color: Colors.black),
labelSmall: const TextStyle(color: Colors.black),
overline: const TextStyle(color: Colors.black),
subtitle1: const TextStyle(color: Colors.black),
subtitle2: const TextStyle(color: Colors.black),
titleLarge: const TextStyle(color: Colors.black),
titleMedium: const TextStyle(color: Colors.black),
titleSmall: const TextStyle(color: Colors.black),
*/
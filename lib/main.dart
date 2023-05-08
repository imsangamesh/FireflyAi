import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/constants/my_constants.dart';
import 'core/themes/my_themes.dart';
import 'core/themes/theme_controller.dart';
import 'modules/auth/auth_controller.dart';
import 'modules/auth/signin_screen.dart';
import 'modules/home/home_controller.dart';
import 'modules/home/home_screen.dart';
import 'modules/profile/profile_controller.dart';

void main() async {
  await GetStorage.init();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  final authController = Get.put(AuthController());

  if (!authController.isUserPresent || auth.currentUser == null) {
    runApp(MyApp(SigninScreen()));
    return;
  }

  log('------------------------- user ID: ${auth.currentUser!.uid} ----------------------');

  final themeController = Get.put(ThemeController());
  final homeController = Get.put(HomeController(), permanent: true);
  final profileCntrlr = Get.put(ProfileController());

  themeController.configureTheme();
  homeController.setUpInterests();
  profileCntrlr.setUpProfilePage();
  profileCntrlr.configureGreetingText();

  runApp(MyApp(const HomeScreen()));
}

class MyApp extends StatelessWidget {
  MyApp(this.screen, {super.key});

  final themeController = Get.put(ThemeController());
  final dynamic screen;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FireflyAI',
      debugShowCheckedModeBanner: false,
      themeMode: themeController.themeMode,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: screen,
    );
  }
}

// F9:3D:1E:00:4F:CB:5C:9C:FF:0A:09:16:0D:99:18:0D:71:5C:C6:F3
// DB:C2:E9:FE:52:A1:D0:1A:E0:1F:6E:2C:46:8F:FA:1D:1F:0A:7E:73:ED:44:94:A1:A4:5A:83:70:FB:9B:9A:D7
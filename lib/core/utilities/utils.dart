import 'package:fireflyai/core/themes/my_colors.dart';
import 'package:fireflyai/core/themes/my_textstyles.dart';
import 'package:fireflyai/core/widgets/my_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'util_widgets/my_input_dialog_box.dart';

class Utils {
  //
  static void normalDialog() {
    showAlert(
      'Oops',
      'Sorry, something went wrong, please report us while We work on it.',
    );
  }

  static Widget emptyList(String text) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bubble_chart_outlined, size: 30),
            const SizedBox(height: 5),
            Text(
              text,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// ------------------------------------------------------------------------------------ `show alert`
  static void showAlert(String title, String description,
      {bool? isDismissable}) {
    Get.defaultDialog(
      backgroundColor: Get.isDarkMode ? MyColors.darkPurple : MyColors.wheat,
      barrierDismissible: isDismissable ?? true,
      //
      content: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------- title
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      title,
                      style: GoogleFonts.berkshireSwash(
                        textStyle: MyTStyles.kTS20Medium.copyWith(
                          color: MyColors.darkPink,
                        ),
                      ),
                    ),
                  ),
                ),
                const MyCloseBtn()
              ],
            ),
            // ----------------- description
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                description,
                style: MyTStyles.kTS14Medium.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
            ),
            // ----------------- button
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: SizedBox(
                width: double.infinity,
                child: MyOutlinedBtn(
                  'Got it',
                  () => Get.back(),
                ),
              ),
            ),
          ],
        ),
      ),
      //
      title: '',
      titleStyle: const TextStyle(fontSize: 0),
      titlePadding: EdgeInsets.zero,
      //
      middleText: '',
      middleTextStyle: const TextStyle(fontSize: 0),
      contentPadding: EdgeInsets.zero,
      //
    );
  }

  /// ------------------------------------------------------------------------------------ `confirm`
  static void confirmDialogBox(
    String title,
    String description, {
    required VoidCallback yesFun,
    bool? isDismissable,
    VoidCallback? noFun,
  }) {
    Get.defaultDialog(
      backgroundColor: Get.isDarkMode ? MyColors.darkPurple : MyColors.wheat,
      barrierDismissible: isDismissable ?? true,
      //
      content: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------- title
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      title,
                      style: GoogleFonts.berkshireSwash(
                        textStyle: MyTStyles.kTS20Medium.copyWith(
                          color: Get.isDarkMode
                              ? MyColors.lightPurple
                              : MyColors.darkPink,
                        ),
                      ),
                    ),
                  ),
                ),
                const MyCloseBtn()
              ],
            ),
            // ----------------- description
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                description,
                style: MyTStyles.kTS14Medium.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color:
                      Get.isDarkMode ? MyColors.greySmoke : MyColors.darkPurple,
                ),
              ),
            ),
            // ----------------- buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: MyOutlinedBtn(
                      'Nope',
                      noFun ?? () => Get.back(),
                      icon: Icons.close_rounded,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Text('|'),
                  ),
                  Expanded(
                    child: MyOutlinedBtn('Yup ', () {
                      Get.back();
                      yesFun();
                    }, icon: Icons.check_rounded),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            )
          ],
        ),
      ),
      //
      title: '',
      titleStyle: const TextStyle(fontSize: 0),
      titlePadding: EdgeInsets.zero,
      //
      middleText: '',
      middleTextStyle: const TextStyle(fontSize: 0),
      contentPadding: EdgeInsets.zero,
      //
    );
  }

  /// ------------------------------------------------------------------------------------ `input field dilalog`
  static void inputDialogBox(
    String hintText,
    TextEditingController controller, {
    required VoidCallback yesFun,
    bool? isDismissable,
    VoidCallback? noFun,
    String? confirmLabel,
    String? cancelLabel,
  }) async {
    Get.defaultDialog(
      backgroundColor: Get.isDarkMode ? MyColors.darkPurple : MyColors.wheat,
      barrierDismissible: isDismissable ?? true,
      //
      content: MyInputDialogBox(hintText, controller, yesFun),
      //
      title: '',
      titleStyle: const TextStyle(fontSize: 0),
      titlePadding: EdgeInsets.zero,
      //
      middleText: '',
      middleTextStyle: const TextStyle(fontSize: 0),
      contentPadding: EdgeInsets.zero,
      //
    );
  }

  /// ------------------------------------------------------------------------------------ `snack bar`
  static showSnackBar(String message, {bool? status}) {
    Color myColor(int a) => status == null
        ? const Color(0xFFFFEBAF)
        : status
            ? const Color(0xFF79F17D)
            : const Color(0xFFE9746C);

    Get.showSnackbar(GetSnackBar(
      padding: const EdgeInsets.all(0),
      messageText: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: myColor(170),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: myColor(255)),
        ),
        child: Center(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(width: 10),
            Icon(
              status == null
                  ? Icons.mark_unread_chat_alt
                  : status
                      ? Icons.done_all_rounded
                      : Icons.dangerous_outlined,
              size: 20,
              color: MyColors.darkScaffoldBG,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: MyTStyles.kTS13Medium.copyWith(
                  color: MyColors.black,
                  overflow: TextOverflow.ellipsis,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 40),
          ],
        )),
      ),
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      duration: const Duration(milliseconds: 2000),
    ));
  }

  /// ------------------------------------------------------------------------------------ `loading`
  static progressIndctr({String? label}) {
    Get.dialog(Scaffold(
      backgroundColor: MyColors.pink.withOpacity(0.05),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: MyColors.pink.withAlpha(100),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: ThemeColors.scaffold,
                  color: ThemeColors.prim1,
                ),
              ),
            ),
            const SizedBox(height: 5),
            if (label != null)
              Text(
                label,
                style: MyTStyles.kTS15Medium.copyWith(color: ThemeColors.prim1),
                textAlign: TextAlign.center,
              )
          ],
        ),
      ),
    ));
  }
}

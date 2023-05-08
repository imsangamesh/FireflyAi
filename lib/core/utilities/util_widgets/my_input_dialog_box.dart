import 'package:fireflyai/core/utilities/textfield_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../themes/my_textstyles.dart';
import '../../widgets/my_buttons.dart';

class MyInputDialogBox extends StatelessWidget {
  const MyInputDialogBox(
    this.hintText,
    this.textCntrlr,
    this.yesFun, {
    this.maxLines,
    this.noFun,
    this.confirmLabel,
    this.cancelLabel,
    super.key,
  });

  final String hintText;
  final VoidCallback yesFun;
  final VoidCallback? noFun;
  final String? confirmLabel, cancelLabel;
  final int? maxLines;

  final TextEditingController textCntrlr;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),

            /// ---------------------------------------------------------- `textfield`
            child: TextFieldWrapper(
              TextField(
                maxLines: maxLines,
                autofocus: true,
                controller: textCntrlr,
                decoration: InputDecoration.collapsed(
                  hintText: hintText,
                  hintStyle: MyTStyles.kTS14Regular,
                ),
              ),
              borderAlpha: 150,
            ),
          ),
          // --------------------------------------------------------------- buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 10),

                /// -------------------------------- `cancel` buttons
                Expanded(
                  child: MyOutlinedBtn(
                    cancelLabel ?? 'Cancel',
                    noFun ?? () => Get.back(),
                    icon: Icons.close_rounded,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Text('|'),
                ),

                /// -------------------------------- `confirm` buttons
                Expanded(
                  child: MyOutlinedBtn(confirmLabel ?? 'Yup', () {
                    Get.back(result: textCntrlr.text);
                    yesFun();
                  }, icon: Icons.check_rounded),
                ),
                const SizedBox(width: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}

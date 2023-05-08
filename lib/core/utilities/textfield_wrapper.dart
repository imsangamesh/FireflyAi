import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes/my_colors.dart';

class TextFieldWrapper extends StatelessWidget {
  const TextFieldWrapper(
    this.widget, {
    this.icon,
    this.bottomPad,
    this.borderAlpha,
    super.key,
  });

  final Widget widget;
  final IconData? icon;
  final double? bottomPad;
  final int? borderAlpha;

  primary(int a) => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(a)
      : MyColors.pink.withAlpha(a);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPad ?? 15),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 13),
        decoration: BoxDecoration(
          color: primary(25),
          borderRadius: BorderRadius.circular(8),
          border: borderAlpha != null
              ? Border.all(color: primary(borderAlpha!), width: 1.5)
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              Icon(
                icon,
                color:
                    Get.isDarkMode ? MyColors.lightPurple : MyColors.darkPink,
              ),
            const SizedBox(width: 5),
            Expanded(child: widget),
          ],
        ),
      ),
    );
  }
}

import 'package:fireflyai/core/themes/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes/my_colors.dart';
import '../themes/my_textstyles.dart';

/// ----------------------------------------------------------------- `CLOSE`
class MyCloseBtn extends StatelessWidget {
  const MyCloseBtn({this.icon, this.ontap, super.key});

  final VoidCallback? ontap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: InkWell(
        onTap: ontap ?? () => Get.back(),
        borderRadius: BorderRadius.circular(30),
        splashColor: MyColors.pink,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.circle,
                color: MyColors.lightPink,
                size: 30,
              ),
            ),
            Icon(icon ?? Icons.close, size: 23, color: MyColors.darkPink),
          ],
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------------- `OUTLINE BUTTONS`
class MyOutlinedBtn extends StatelessWidget {
  const MyOutlinedBtn(
    this.label,
    this.ontap, {
    this.icon,
    this.radius,
    super.key,
  });

  final VoidCallback? ontap;
  final String label;
  final IconData? icon;
  final double? radius;

  primary() => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(150)
      : MyColors.pink.withAlpha(255);

  @override
  Widget build(BuildContext context) {
    /// ----------------------------- `Label`
    if (icon == null) {
      return OutlinedButton(
        onPressed: ontap,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 30),
          ),
          side: BorderSide(width: 1, color: primary()),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        ),
        child: Text(label, style: MyTStyles.kTS16Medium),
      );
    }

    /// ----------------------------- `Label & Icon`
    return OutlinedButton.icon(
      onPressed: ontap,
      icon: Icon(icon),
      label: Text(label, style: MyTStyles.kTS16Medium),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 30),
        ),
        side: BorderSide(width: 1, color: primary()),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7.5),
      ),
    );
  }
}

/// ----------------------------------------------------------------- `ELEVATED BUTTONS`
class MyElevatedBtn extends StatelessWidget {
  const MyElevatedBtn(
    this.label,
    this.ontap, {
    this.icon,
    this.radius,
    super.key,
  });

  final VoidCallback? ontap;
  final String label;
  final IconData? icon;
  final double? radius;

  primary() => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(150)
      : MyColors.pink.withAlpha(255);

  @override
  Widget build(BuildContext context) {
    /// ----------------------------- `Label`
    if (icon == null) {
      return ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 30),
          ),
          side: BorderSide(width: 1, color: primary()),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        ),
        child: Text(label, style: MyTStyles.kTS16Medium),
      );
    }

    /// ----------------------------- `Label & Icon`
    return ElevatedButton.icon(
      onPressed: ontap,
      icon: Icon(icon),
      label: Text(label, style: MyTStyles.kTS16Medium),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 30),
        ),
        side: BorderSide(width: 1, color: primary()),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7.5),
      ),
    );
  }
}

/// ----------------------------------------------------------------- `ICON Button`
class MyIconBtn extends StatelessWidget {
  const MyIconBtn(
    this.icon,
    this.ontap, {
    this.size,
    this.color,
    this.radius,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback ontap;
  final double? size;
  final Color? color;
  final double? radius;

  primary(int a) => color != null
      ? color!.withAlpha(a)
      : Get.put(ThemeController()).isDark()
          ? MyColors.lightPurple.withAlpha(a)
          : MyColors.midPink.withAlpha(a);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 42,
      width: size ?? 42,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: FittedBox(
          child: Container(
            decoration: BoxDecoration(
              color: primary(30),
              borderRadius: BorderRadius.circular(radius ?? 100),
            ),
            child: IconButton(
              splashRadius: 30,
              icon: Icon(
                icon,
                size: 32,
                color: color ?? primary(255),
              ),
              onPressed: ontap,
              splashColor: primary(150),
            ),
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------------- `SELECTABLE`
class MySelectableIconBtn extends StatelessWidget {
  const MySelectableIconBtn(
    this.isSelected,
    this.selectedIcon,
    this.unSelectedIcon,
    this.ontap, {
    this.radius,
    this.size,
    Key? key,
  }) : super(key: key);

  final IconData selectedIcon;
  final IconData unSelectedIcon;
  final VoidCallback ontap;
  final double? radius;
  final double? size;
  final bool isSelected;

  primary(int a) => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(a)
      : MyColors.pink.withAlpha(a);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 42,
      width: size ?? 42,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: FittedBox(
          child: InkWell(
            splashColor: primary(60),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius ?? 100),
                border: Border.all(
                  width: isSelected ? 3.5 : 1.2,
                  color: isSelected
                      ? Get.isDarkMode
                          ? MyColors.lightPurple
                          : MyColors.midPink
                      : primary(80),
                ),
              ),
              child: IconButton(
                icon: Icon(
                  isSelected ? selectedIcon : unSelectedIcon,
                  size: 32,
                  color:
                      Get.isDarkMode ? MyColors.lightPurple : MyColors.midPink,
                ),
                onPressed: ontap,
                splashColor: primary(80),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

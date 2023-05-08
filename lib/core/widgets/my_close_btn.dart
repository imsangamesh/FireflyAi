import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBackBtn extends StatelessWidget {
  const MyBackBtn({this.icon, this.onTap, this.size, this.btnSize, super.key});

  final IconData? icon;
  final VoidCallback? onTap;
  final double? size, btnSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 37,
      width: 37,
      child: FloatingActionButton.small(
        heroTag: UniqueKey(),
        onPressed: onTap ?? () => Get.back(),
        elevation: 0,
        highlightElevation: 5,
        child: Container(
          height: btnSize ?? 32,
          width: btnSize ?? 32,
          decoration: const BoxDecoration(
            color: Color.fromARGB(40, 0, 0, 0),
            shape: BoxShape.circle,
          ),
          child: Icon(icon ?? Icons.chevron_left_rounded, size: size ?? 25),
        ),
      ),
    );
  }
}

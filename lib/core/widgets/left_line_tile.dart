import 'package:fireflyai/core/themes/my_colors.dart';
import 'package:fireflyai/core/themes/my_textstyles.dart';
import 'package:fireflyai/core/widgets/my_buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeftLineUnderlineBox extends StatelessWidget {
  const LeftLineUnderlineBox(this.title, this.description,
      {this.function, this.secondFun, this.secondIcon, super.key});

  final String title, description;
  final VoidCallback? function;
  final VoidCallback? secondFun;
  final IconData? secondIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: ThemeColors.shade2,
        border: Border(
          left: BorderSide(color: ThemeColors.prim3, width: 5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.only(left: 10, bottom: 5, right: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: ThemeColors.prim3, width: 1.2),
                    ),
                  ),
                  child: Text(title, style: MyTStyles.kTS16Medium),
                ),
                const Spacer(),

                /// --------------------------------------- `upload`
                if (secondFun != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: MyIconBtn(
                      secondIcon ?? Icons.upload,
                      secondFun!,
                      size: 26,
                    ),
                  ),

                /// --------------------------------------- `copy`
                if (function != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: MyIconBtn(Icons.copy, function!, size: 25),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(description, style: MyTStyles.kTS14Regular),
          ),
        ],
      ),
    );
  }
}

class IconTextTile extends StatelessWidget {
  const IconTextTile(
    this.icon,
    this.label, {
    this.color,
    this.size,
    this.fw,
    super.key,
  });

  final String label;
  final IconData icon;
  final Color? color;
  final double? size;
  final FontWeight? fw;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: size ?? 18, color: color),
        Text(
          ' $label',
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontSize: size ?? 18,
              height: 1,
              fontWeight: fw ?? FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class LeftLineTile extends StatelessWidget {
  const LeftLineTile(this.title, this.value, {super.key});

  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ThemeColors.shade2,
        border: Border(
          left: BorderSide(color: ThemeColors.prim3, width: 5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: MyTStyles.kTS16Medium)),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(value, style: MyTStyles.kTS15Medium),
          ),
        ],
      ),
    );
  }
}

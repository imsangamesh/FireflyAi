import 'package:fireflyai/core/themes/my_colors.dart';
import 'package:fireflyai/core/themes/my_textstyles.dart';
import 'package:fireflyai/model/features_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeFeaturesTile extends StatelessWidget {
  const HomeFeaturesTile(this.mlfeats, {super.key});

  final MLFeatures mlfeats;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cnstr) {
      return Material(
        elevation: 8,
        color: const Color(0xff0FCBA5),
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          splashColor: ThemeColors.prim3,
          onTap: () {
            FocusScope.of(context).unfocus();
            Get.to(() => mlfeats.page);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: cnstr.maxWidth * 0.4224,
                width: cnstr.maxWidth,
                child: Ink.image(image: AssetImage(mlfeats.image)),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  mlfeats.name,
                  style: MyTStyles.splHeading25.copyWith(
                    color: MyColors.darkPurple,
                    fontSize: 21,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    mlfeats.description,
                    style: GoogleFonts.quicksand(
                      textStyle: MyTStyles.kTS12Medium.copyWith(
                        color: MyColors.darkPurple,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    maxLines: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

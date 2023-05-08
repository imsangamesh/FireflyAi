import 'package:fireflyai/core/themes/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/my_textstyles.dart';
import '../../profile/profile_controller.dart';
import '../../profile/profile_screen_view.dart';

class HomeProfileHeader extends StatelessWidget {
  const HomeProfileHeader({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// ----------------------- `Greeting Text`
          GetX<ProfileController>(
            builder: (cntrlr) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cntrlr.greetingText(),
                  style:
                      GoogleFonts.quicksand(textStyle: MyTStyles.kTS20Medium),
                ),
                SizedBox(
                  width: size.width * 0.6,
                  child: Text(
                    cntrlr.username(),
                    style: GoogleFonts.berkshireSwash(
                        textStyle: MyTStyles.kTS24Medium, height: 1),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),

          /// ----------------------- `Profile Icon`
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0x13000000),
            child: SizedBox(
              height: 38,
              width: 38,
              child: FloatingActionButton(
                heroTag: 'profile',
                clipBehavior: Clip.antiAliasWithSaveLayer,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Get.to(() => const ProfileScreenView());
                },
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 3,
                      color: MyColors.pink,
                    ),
                  ),
                  child: Ink.image(
                    image: NetworkImage(imageUrl),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:fireflyai/core/themes/my_colors.dart';
import 'package:fireflyai/core/themes/my_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utilities/utils.dart';
import '../search_result_page_view.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  //
  final _controller = TextEditingController();

  @override
  void initState() {
    checkForLinks();
    super.initState();
  }

  checkForLinks() async {
    final data = await Clipboard.getData('text/plain');
    if (data == null || data.text == null) return;

    final String text = data.text!.trim();

    if (text.startsWith('http') && await canLaunchUrl(Uri.parse(text))) {
      Utils.confirmDialogBox(
        'follow link?',
        text,
        yesFun: () => Get.to(() => SearchResultPageView(text, isUrl: true)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(width: 2, color: Colors.white30),
      ),
      child: TextFormField(
        controller: _controller,
        cursorColor: MyColors.darkPurple,
        cursorWidth: 1.5,
        style: MyTStyles.kTS15Medium.copyWith(
          fontWeight: FontWeight.w400,
          color: MyColors.darkPurple,
        ),
        textInputAction: TextInputAction.search,

        /// ----------------------------------------------------------- `submit`
        onFieldSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            _controller.clear();
            Get.to(() => SearchResultPageView(value.trim()));
          }
        },
        decoration: InputDecoration(
          /// -------------- `hint text`
          hintText: "What's on your mind?",
          hintStyle: MyTStyles.kTS13Regular.copyWith(
            color: MyColors.midGrey,
            height: 0.9,
          ),

          /// -------------- `icons`
          prefixIcon: const Icon(
            Icons.search,
            color: MyColors.midGrey,
            size: 19,
          ),

          /// -------------- `borders`
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: ThemeColors.midPrim,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

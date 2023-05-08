import 'package:fireflyai/core/constants/my_constants.dart';
import 'package:fireflyai/core/themes/my_colors.dart';
import 'package:fireflyai/core/themes/theme_controller.dart';
import 'package:fireflyai/model/features_data.dart';
import 'package:fireflyai/modules/home/widgets/home_features_tile.dart';
import 'package:fireflyai/modules/home/widgets/home_profile_header.dart';
import 'package:fireflyai/modules/home/widgets/home_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/helpers/my_helper.dart';
import 'widgets/home_interests_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  //
  String get imageUrl => auth.currentUser!.photoURL ?? MyHelper.profilePic;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      onVerticalDragUpdate: (details) {
        FocusScope.of(context).unfocus();
      },
      child: GetX<ThemeController>(
        builder: (cntrlr) => Scaffold(
          body: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              /// --------------------------------- `appBar`
              SliverAppBar(
                expandedHeight: context.height * 0.2,

                /// --------------------------------- `appBar body`
                flexibleSpace: FlexibleSpaceBar(
                  // ---------- outer box for bg color
                  background: Container(
                    color: cntrlr.isDark()
                        ? MyColors.darkScaffoldBG
                        : MyColors.lightScaffoldBG,
                    // ---------- inner box for it's contents
                    child: Container(
                      padding: EdgeInsets.only(
                          top: topPad, right: 20, left: 20, bottom: 20),
                      decoration: BoxDecoration(
                        color: cntrlr.primary(),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// -------------------------------------------------- `appBar components`
                          HomeProfileHeader(imageUrl: imageUrl),
                          const Spacer(),
                          const HomeSearchBar(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// --------------------------------- `your interests`
              SliverToBoxAdapter(
                child: HomeInterestsTile(cntrlr.primary()),
              ),

              /// --------------------------------- `features list tiles`
              SliverToBoxAdapter(
                child: GridView.builder(
                  itemCount: allFeatures.length,
                  primary: false,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, i) {
                    return HomeFeaturesTile(allFeatures[i]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

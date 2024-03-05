import 'package:fireflyai/core/themes/my_textstyles.dart';
import 'package:fireflyai/core/utilities/utils.dart';
import 'package:fireflyai/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../search_result_page_view.dart';

class HomeInterestsTile extends StatelessWidget {
  HomeInterestsTile(this.color, {super.key});

  final Color color;
  final isExpanded = false.obs;

  final interestCntrlr = TextEditingController();

  void tapHandler(String label, HomeController controller) {
    if (label == 'add new +') {
      Utils.inputDialogBox(
        'new interest...',
        interestCntrlr,
        yesFun: () {
          controller.addNewInterests(interestCntrlr.text.trim());
        },
      );
    } else if (label == 'reset') {
      controller.resetInterests();
    } else {
      Get.to(() => SearchResultPageView(label));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isExpanded() ? color.withAlpha(150) : Colors.transparent,
            ),
          ),
          margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
          //
          child: ExpansionTile(
            leading: Icon(isExpanded()
                ? Icons.interests_rounded
                : Icons.interests_outlined),
            childrenPadding: const EdgeInsets.all(10),
            expandedAlignment: Alignment.centerLeft,
            onExpansionChanged: (val) => isExpanded(val),
            title: const Text('My Interests', style: MyTStyles.kTS18Medium),
            children: [
              /// -------------------------------------------------------------- `children`
              GetX<HomeController>(
                builder: (cntrlr) {
                  return Wrap(
                    alignment: WrapAlignment.start,
                    children: [...cntrlr.interests, 'add new +', 'reset']
                        .map(
                          (ech) => Padding(
                            padding: const EdgeInsets.only(right: 7, bottom: 7),

                            /// ---------------------------------------- `Tile widget`
                            child: InkWell(
                              onTap: () => tapHandler(ech, cntrlr),
                              splashColor: color.withAlpha(100),
                              borderRadius: BorderRadius.circular(50),
                              child: ech == 'add new +' || ech == 'reset'
                                  ? specialTile(ech)
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 8),
                                      decoration: BoxDecoration(
                                        color:
                                            ech == 'add new +' || ech == 'reset'
                                                ? color.withAlpha(25)
                                                : color.withAlpha(50),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Text(ech,
                                          style: MyTStyles.kTS15Medium),
                                    ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  specialTile(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        decoration: BoxDecoration(
          border: Border.all(color: color.withAlpha(50)),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(label, style: MyTStyles.kTS15Medium),
      );
}

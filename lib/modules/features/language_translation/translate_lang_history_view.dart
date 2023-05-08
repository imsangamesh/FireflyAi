import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireflyai/core/constants/my_constants.dart';
import 'package:fireflyai/core/constants/my_pref_keys.dart';
import 'package:fireflyai/core/themes/my_colors.dart';
import 'package:fireflyai/core/themes/my_textstyles.dart';
import 'package:fireflyai/core/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/my_buttons.dart';

class TranslateLangHistoryView extends StatelessWidget {
  const TranslateLangHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your History')),
      body: StreamBuilder(
        stream: fire
            .collection(MyPrefKeys.userFireData)
            .doc(MyPrefKeys.fireAuthId)
            .collection(MyPrefKeys.translationHistory)
            .orderBy('createdAt')
            .snapshots(),
        builder: (context, snapshot) {
          final snapData = snapshot.data;

          if (snapData == null ||
              snapData.docs.isEmpty ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Utils.emptyList('no translations here!\nadd some...');
          }

          return ListView.builder(
            itemCount: snapData.docs.length,
            padding: const EdgeInsets.all(15),
            itemBuilder: (context, index) {
              final data = snapData.docs[index].data();
              final date = (data['createdAt'] as Timestamp).toDate();
              final docId = snapData.docs[index].id;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: ThemeColors.listTile,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ------------------------------ source
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data['src'],
                              style: MyTStyles.kTS16Regular,
                            ),
                          ),
                          langLabelTile(data['srcLang'].toString()),
                        ],
                      ),
                      // ------------------------------ divider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: context.width * 0.35,
                            child: const Divider(height: 10, thickness: 0.5),
                          ),
                          const Text('  to  '),
                          SizedBox(
                            width: context.width * 0.35,
                            child: const Divider(height: 10, thickness: 0.5),
                          ),
                        ],
                      ),
                      // ----------------------------- destination
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data['dest'],
                              style: MyTStyles.kTS16Regular,
                            ),
                          ),
                          langLabelTile(data['destLang'].toString()),
                        ],
                      ),
                      const Divider(height: 15, thickness: 0.5),
                      // ----------------------------- delete & date
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('dd MMM yy | hh:mm  ').format(date),
                              style: MyTStyles.kTS12Regular
                                  .copyWith(color: MyColors.grey),
                            ),
                            MyIconBtn(
                              Icons.delete,
                              () => Utils.confirmDialogBox(
                                'Alert!',
                                'do you wanna delete this translation?',
                                yesFun: () => deleteTextSnippet(docId),
                              ),
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  langLabelTile(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: ThemeColors.prim4),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(label, style: MyTStyles.kTS11Medium),
      );

  deleteTextSnippet(String docId) async {
    try {
      await fire
          .collection(MyPrefKeys.userFireData)
          .doc(MyPrefKeys.fireAuthId)
          .collection(MyPrefKeys.translationHistory)
          .doc(docId)
          .delete();

      Utils.showSnackBar('Deleted Successfully!', status: true);
    } catch (e) {
      Utils.showAlert(
        'Oops!',
        'we couldn\'t delete the text snippet, please try again later.',
      );
    }
  }
}

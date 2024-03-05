import 'package:fireflyai/core/themes/my_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';

import '../../core/utilities/textfield_wrapper.dart';
import '../../core/utilities/utils.dart';
import '../../core/widgets/left_line_tile.dart';
import '../../core/widgets/my_buttons.dart';

class SmartReplyView extends StatelessWidget {
  SmartReplyView({super.key});

  final loading = false.obs;
  final textCntrlr = TextEditingController();
  final beforeText = ''.obs;

  final RxList<EntityAnnotation> annotations = RxList([]);
  final _myListKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          textCntrlr.clear();
          removeAllAndLoadNew();
          return true;
        },
        child: Scaffold(
          /// ------------------------------------- `app bar`
          appBar: AppBar(
            title: const Text('Extract Entities'),
            bottom: !loading()
                ? null
                : const PreferredSize(
                    preferredSize: Size(double.infinity, 10),
                    child: LinearProgressIndicator(),
                  ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// ---------------------------------------------- `source`
                Expanded(
                  child: TextFieldWrapper(
                    TextField(
                      controller: textCntrlr,
                      maxLines: null,
                      cursorHeight: 25,
                      style: MyTStyles.kTS16Regular,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'your language goes here...',
                        hintStyle: MyTStyles.kTS16Regular,
                      ),
                    ),
                  ),
                ),

                /// ---------------------------- `AnimatedList`
                AnimatedList(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  key: _myListKey,
                  initialItemCount: annotations.length,
                  itemBuilder: (context, i, animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      child: LeftLineUnderlineBox(
                        annotations[i].entities.first.type.name.capitalize!,
                        annotations[i].text,
                        function: () {
                          Clipboard.setData(
                              ClipboardData(text: annotations[i].text));
                          Utils.showSnackBar('text copied!');
                        },
                      ),
                    );
                  },
                ),

                /// ---------------------------------------------- `button`
                SizedBox(
                  width: double.infinity,
                  child: MyElevatedBtn(
                    'Extract entitities',
                    () => extractData(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ------------------------------------------------------ `detect Language`
  extractData(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final text = textCntrlr.text.trim();

    if (text == '' || text == beforeText()) return;

    loading(true);
    beforeText(text);

    final entityExtractor = EntityExtractor(
      language: EntityExtractorLanguage.english,
    );

    final List<EntityAnnotation> annots =
        await entityExtractor.annotateText(text);

    if (annots.isEmpty) {
      loading(false);
      textCntrlr.clear();
      await entityExtractor.close();
      Utils.showAlert(
        '😟 Oops!',
        'We couldn\'t identify the specified language, please check whether it is valid...',
      );
      return;
    }

    removeAllAndLoadNew();
    for (var i = 0; i < annots.length; i++) {
      addItemInList(i, annots[i]);
    }

    await entityExtractor.close();
    loading(false);
  }

  /// ------------------------------------------------------ `List modifiers`
  ///----- `ADD`
  addItemInList(int i, dynamic data) {
    annotations.add(data);
    _myListKey.currentState?.insertItem(
      i,
      duration: const Duration(milliseconds: 500),
    );
  }

  ///----- `REMOVE`
  removeItemInList(int i) {
    _myListKey.currentState?.removeItem(
      i,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: LeftLineUnderlineBox(
          annotations[i].entities.first.type.name,
          annotations[i].text,
        ),
      ),
      duration: const Duration(milliseconds: 500),
    );
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => annotations.removeAt(i));
  }

  ///----- `REMOVE ALL AND LOAD`
  removeAllAndLoadNew() {
    for (var i = annotations.length - 1; i >= 0; i--) {
      removeItemInList(i);
    }
  }
}

import 'package:fireflyai/core/themes/my_textstyles.dart';
import 'package:fireflyai/core/widgets/left_line_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../../core/utilities/textfield_wrapper.dart';
import '../../core/utilities/utils.dart';
import '../../core/widgets/my_buttons.dart';

class LanguageDetectionView extends StatelessWidget {
  LanguageDetectionView({super.key});

  final loading = false.obs;
  final textCntrlr = TextEditingController();
  final beforeText = ''.obs;

  final langName = ''.obs;
  final confidence = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          textCntrlr.clear();
          return true;
        },
        child: Scaffold(
          /// ------------------------------------- `app bar`
          appBar: AppBar(
            title: const Text('Language Identification'),
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
                      cursorHeight: 40,
                      style: MyTStyles.kTS28Regular,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'your language goes here...',
                        hintStyle: MyTStyles.kTS24Regular,
                      ),
                    ),
                  ),
                ),

                /// ---------------------------------------------- `button`
                SizedBox(
                  width: double.infinity,
                  child: MyOutlinedBtn(
                    'Detect Language',
                    () => detectLanguage(context),
                  ),
                ),

                /// ---------------------------------------------- `detected lang`
                if (langName() != '')
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: LeftLineTile(langName(), '${confidence()}%'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ------------------------------------------------------ `detect Language`
  detectLanguage(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final text = textCntrlr.text.trim();
    if (text == '' || text == beforeText()) return;

    loading(true);
    beforeText(text);

    final languageIdentifier = LanguageIdentifier(
      confidenceThreshold: 0.5,
    );

    final response = await languageIdentifier.identifyPossibleLanguages(
      textCntrlr.text.trim(),
    );

    langName('');
    final name = response.first.languageTag;

    if (name == 'undeterminedLanguageCode' || name == 'und') {
      loading(false);
      textCntrlr.clear();
      await languageIdentifier.close();
      Utils.showAlert(
        '😟 Oops!',
        'We couldn\'t identify the specified language, please check whether it is valid...',
      );
      return;
    }

    langName(BCP47Code.fromRawValue(name)!.name.capitalize!);
    confidence((response.first.confidence * 100).toStringAsFixed(0));

    await languageIdentifier.close();
    loading(false);
  }
}

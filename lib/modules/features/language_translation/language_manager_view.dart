import 'package:fireflyai/core/utilities/utils.dart';
import 'package:fireflyai/modules/features/language_translation/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../../../core/themes/my_colors.dart';

class LangManagerView extends StatefulWidget {
  const LangManagerView({this.isForSelect, super.key});

  final bool? isForSelect;

  @override
  State<LangManagerView> createState() => _LangManagerViewState();
}

class _LangManagerViewState extends State<LangManagerView> {
  //
  final languages = TranslateLanguage.values;
  final langController = Get.put(LanguageController());

  List<TranslateLanguage> get currentLangs =>
      widget.isForSelect == true ? langController.downloadedCodes : languages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ------------------------------------- `app bar`
      appBar: AppBar(title: const Text('Available Languages')),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: currentLangs.length,
        itemBuilder: (context, i) {
          return GetX<LanguageController>(
            builder: (cntrl) {
              final downloaded =
                  cntrl.downloadedCodes.contains(currentLangs[i]);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(currentLangs[i].name.capitalize!),
                  onTap: widget.isForSelect == true
                      ? () => Get.back(result: currentLangs[i])
                      : null,
                  trailing: downloaded
                      ? IconButton(
                          icon: const Icon(
                            Icons.download_done_outlined,
                            color: MyColors.green,
                          ),
                          onPressed: () => deleteLang(currentLangs[i]),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.download,
                            color: ThemeColors.prim2,
                          ),
                          onPressed: () => downloadLang(currentLangs[i]),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  downloadLang(TranslateLanguage language) {
    Utils.confirmDialogBox(
      'Hey!',
      'do you want to download "${language.name.capitalize!}" language?',
      yesFun: () => langController.downloadLang(language),
    );
  }

  deleteLang(TranslateLanguage language) {
    Utils.confirmDialogBox(
      'Alert!',
      'do you wanna delete this language?',
      yesFun: () => langController.deleteLang(language),
    );
  }
}

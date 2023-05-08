import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireflyai/core/widgets/my_buttons.dart';
import 'package:fireflyai/modules/features/language_translation/language_controller.dart';
import 'package:fireflyai/modules/features/language_translation/translate_lang_history_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../../../core/constants/my_constants.dart';
import '../../../core/constants/my_pref_keys.dart';
import '../../../core/themes/my_textstyles.dart';
import '../../../core/utilities/textfield_wrapper.dart';
import '../../../core/utilities/utils.dart';
import 'language_manager_view.dart';

class TranslateLanguageView extends StatefulWidget {
  const TranslateLanguageView({super.key});

  @override
  State<TranslateLanguageView> createState() => _TranslateLanguageViewState();
}

class _TranslateLanguageViewState extends State<TranslateLanguageView> {
  //
  final source = TranslateLanguage.english.obs;
  final destination = TranslateLanguage.spanish.obs;
  final loading = false.obs;

  final langController = Get.put(LanguageController());
  final srcCntrlr = TextEditingController();
  final destCntrlr = TextEditingController();

  @override
  void initState() {
    langController.updateDownloads();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(
      () => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          /// ------------------------------------- `app bar`
          appBar: AppBar(
            title: const Text('Language Translater'),
            bottom: !loading()
                ? null
                : const PreferredSize(
                    preferredSize: Size(double.infinity, 10),
                    child: LinearProgressIndicator(),
                  ),
            actions: [
              IconButton(
                onPressed: () => Get.to(() => const TranslateLangHistoryView()),
                icon: const Icon(Icons.history),
              ),
              IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Get.to(() => const LangManagerView());
                },
                icon: const Icon(Icons.g_translate),
              ),
            ],
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
                      controller: srcCntrlr,
                      maxLines: null,
                      cursorHeight: 40,
                      style: MyTStyles.kTS28Regular,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'your language goes here...',
                        hintStyle: MyTStyles.kTS28Regular,
                      ),
                    ),
                  ),
                ),

                /// ---------------------------------------------- `destination`
                Expanded(
                  child: TextFieldWrapper(
                    TextField(
                      controller: destCntrlr,
                      maxLines: null,
                      cursorHeight: 40,
                      style: MyTStyles.kTS28Regular,
                      readOnly: true,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'translated language!',
                        hintStyle: MyTStyles.kTS28Regular,
                      ),
                    ),
                  ),
                ),

                Row(
                  children: [
                    /// ---------------------------------------------- `translate button`
                    Expanded(child: MyOutlinedBtn('Let\'s go!', translateText)),
                    const SizedBox(width: 10),

                    /// ---------------------------------------------- `upload button`
                    MyIconBtn(
                      Icons.upload,
                      () => Utils.confirmDialogBox(
                        'Confirm?',
                        'hey, do you wanna upload this translation to database?',
                        yesFun: () => uploadToFireStore(
                          srcCntrlr.text,
                          destCntrlr.text,
                          source().name,
                          destination().name,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(height: size.height * 0.06),
              ],
            ),
          ),

          /// ------------------------------------------------------------------- `floating buttons`
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: size.width * 0.35,
                child: FloatingActionButton.extended(
                  heroTag: 'herotag1',
                  onPressed: () => selectLanguage('src'),
                  label: Text(source().name.capitalize.toString()),
                ),
              ),
              FloatingActionButton.small(
                heroTag: 'herotag3',
                onPressed: swapLanguages,
                child: const Icon(Icons.swap_horizontal_circle, size: 30),
              ),
              SizedBox(
                width: size.width * 0.35,
                child: FloatingActionButton.extended(
                  heroTag: 'herotag2',
                  onPressed: () => selectLanguage('dest'),
                  label: Text(destination().name.capitalize!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  selectLanguage(String label) async {
    FocusScope.of(context).unfocus();
    final TranslateLanguage? result = await Get.to(
      () => const LangManagerView(isForSelect: true),
    );
    if (result == null) return;

    if (label == 'src') {
      if (result == destination()) {
        swapLanguages();
      } else {
        source(result);
      }
    } else {
      if (result == destination()) {
        swapLanguages();
      } else {
        destination(result);
      }
    }
  }

  /// ------------------------------------------------------------ `upload to Fire`
  uploadToFireStore(
      String src, String dest, String srcLang, String destLang) async {
    try {
      if (srcCntrlr.text == '' || destCntrlr.text == '') {
        Utils.showSnackBar('empty data alert', status: false);
        return;
      }

      final timestamp = Timestamp.now();
      Utils.progressIndctr();

      await fire
          .collection(MyPrefKeys.userFireData)
          .doc(MyPrefKeys.fireAuthId)
          .collection(MyPrefKeys.translationHistory)
          .doc(timestamp.toString())
          .set({
        'createdAt': timestamp,
        'src': src.trim(),
        'dest': dest.trim(),
        'srcLang': srcLang,
        'destLang': destLang,
      });

      Get.back();
      Utils.showSnackBar('Upload Successful!', status: true);
    } catch (e) {
      Get.back();
      Utils.showAlert(
        'Oops!',
        'we couldn\'t upload the translation to database, please try again later.',
      );
    }
  }

  /// ------------------------------------------------------ `get Image labels`
  translateText() async {
    FocusScope.of(context).unfocus();
    final modelManager = OnDeviceTranslatorModelManager();

    // ----------------------------- source lang download check
    if (await modelManager.isModelDownloaded(source().bcpCode) == false) {
      Utils.showAlert(
        'Alert',
        'please make sure, you\'ve downloaded ${source().name} language & then try again.',
      );
      return;
    }

    // ----------------------------- source lang download check
    if (await modelManager.isModelDownloaded(destination().bcpCode) == false) {
      Utils.showAlert(
        'Alert',
        'please make sure, you\'ve downloaded ${destination().name} language & then try again.',
      );
      return;
    }

    loading(true);
    final languageTranslator = OnDeviceTranslator(
      sourceLanguage: source(),
      targetLanguage: destination(),
    );

    final response = await languageTranslator.translateText(
      srcCntrlr.text.trim(),
    );
    log(response);
    log('=======================');

    destCntrlr.text = response;

    await languageTranslator.close();
    loading(false);
  }

  /// ------------------------------------------------------ `swap languages`
  swapLanguages() {
    final temp = source.value;
    source.value = destination.value;
    destination.value = temp;
  }
}

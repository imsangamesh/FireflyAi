import 'package:fireflyai/core/utilities/utils.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class LanguageController extends GetxController {
  final modelManager = OnDeviceTranslatorModelManager();

  final languages = TranslateLanguage.values.map((ech) => ech.name).toList();
  final RxList<TranslateLanguage> downloadedCodes = RxList();

  /// ---------------------------------- `set up languages`
  setUpLanguages() async {
    const lang = TranslateLanguage.spanish;
    final res = await modelManager.isModelDownloaded(lang.bcpCode);

    if (!res) {
      await modelManager.downloadModel(lang.bcpCode).then((value) {
        downloadedCodes.add(lang);
      });
    }
  }

  /// ---------------------------------- `update download codes`
  updateDownloads() async {
    for (var ech in TranslateLanguage.values) {
      final res = await modelManager.isModelDownloaded(ech.bcpCode);
      if (res) downloadedCodes.add(ech);
    }
  }

  /// ---------------------------------- `download`
  downloadLang(TranslateLanguage lang) async {
    Utils.showSnackBar('downloading...');
    await modelManager.downloadModel(lang.bcpCode).then((value) {
      downloadedCodes.add(lang);
      Utils.showSnackBar('${lang.name} downloaded!', status: true);
    });
  }

  /// ---------------------------------- `delete`
  deleteLang(TranslateLanguage lang) async {
    await modelManager.deleteModel(lang.bcpCode).then((value) {
      downloadedCodes.remove(lang);
      Utils.showSnackBar('${lang.name} deleted!');
    });
  }
}

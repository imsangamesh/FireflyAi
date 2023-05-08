import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireflyai/core/constants/my_constants.dart';
import 'package:fireflyai/core/constants/my_pref_keys.dart';
import 'package:fireflyai/core/utilities/utils.dart';
import 'package:fireflyai/core/widgets/left_line_tile.dart';
import 'package:fireflyai/modules/features/text_recognition/text_recognition_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/my_images.dart';

class TextRecognitionView extends StatelessWidget {
  TextRecognitionView({super.key});

  final imageFile = File('').obs;
  final loading = false.obs;
  final scannedText = ''.obs;

  final uploadCtrlr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          imageFile(File(''));
          return true;
        },
        child: Scaffold(
          /// ------------------------------------- `app bar`
          appBar: AppBar(
            title: const Text('Text Recognition'),
            bottom: !loading()
                ? null
                : const PreferredSize(
                    preferredSize: Size(double.infinity, 10),
                    child: LinearProgressIndicator(),
                  ),
            actions: [
              IconButton(
                onPressed: () => Get.to(() => const TextRecognitionHistory()),
                icon: const Icon(Icons.history),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// ---------------------------------------------- `upload image`
                  if (imageFile().path == '')
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Center(
                        child: SizedBox(
                          height: 250,
                          width: 250,
                          child: Image.asset(MyImages.uploadImages),
                        ),
                      ),
                    ),

                  /// ---------------------------------------------- `image`
                  if (imageFile().path != '')
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: size.width * 0.6,
                        maxHeight: size.width * 0.6,
                      ),
                      margin: const EdgeInsets.all(50),
                      child: Image.file(imageFile(), fit: BoxFit.contain),
                    ),

                  /// ---------------------------------------------- `Output Text`
                  if (imageFile().path != '')
                    LeftLineUnderlineBox(
                      'Scanned Text',
                      scannedText(),
                      function: () {
                        Clipboard.setData(ClipboardData(text: scannedText()));
                        Utils.showSnackBar('copied to Clipboard!');
                      },
                      secondFun: () {
                        uploadCtrlr.text = scannedText();
                        Utils.inputDialogBox(
                          '',
                          uploadCtrlr,
                          yesFun: () => uploadToFireStore(uploadCtrlr.text),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),

          /// ------------------------------------------------------------------- `floating buttons`
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton.extended(
                heroTag: 'herotag1',
                onPressed: () => pickImage(ImageSource.gallery),
                label: Row(
                  children: const [
                    Text(' Pick Image '),
                    Icon(Icons.photo),
                  ],
                ),
              ),
              FloatingActionButton.extended(
                heroTag: 'herotag2',
                onPressed: () => pickImage(ImageSource.camera),
                label: Row(
                  children: const [
                    Text('Take Picture '),
                    Icon(Icons.camera_alt),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ------------------------------------------------------------ `upload to Fire`
  uploadToFireStore(String data) async {
    try {
      final timestamp = Timestamp.now();
      Utils.progressIndctr();

      await fire
          .collection(MyPrefKeys.userFireData)
          .doc(MyPrefKeys.fireAuthId)
          .collection(MyPrefKeys.textHistory)
          .doc(data)
          .set({
        'createdAt': timestamp,
        'data': data.trim(),
      });

      Get.back();
      Utils.showSnackBar('Upload Successful!', status: true);
    } catch (e) {
      Get.back();
      Utils.showAlert(
        'Oops!',
        'we couldn\'t upload the text snippet to database, please try again later.',
      );
    }
  }

  /// ------------------------------------------------------ `Pick image`
  pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) {
      Utils.showSnackBar('Please pick the image', status: false);
      return;
    }
    imageFile(File(pickedFile.path));
    await extractText();
  }

  /// ------------------------------------------------------ `get Image labels`
  extractText() async {
    loading(true);
    final image = InputImage.fromFile(imageFile());
    final textRecognizer = TextRecognizer();

    RecognizedText recognizedText = await textRecognizer.processImage(image);
    scannedText('');

    for (var block in recognizedText.blocks) {
      for (var line in block.lines) {
        scannedText.value = '${scannedText.value}${line.text}\n';
      }
    }

    log('======================================= ${scannedText.value}');
    if (scannedText() == '') {
      imageFile(File(''));
      Utils.showAlert(
        '😟 Oops!',
        'It seems that the image you\'ve uploaded doesn\'t have text snippets or it is not clear enough...',
      );
    }

    await textRecognizer.close();
    loading(false);
  }
}

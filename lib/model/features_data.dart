import 'package:fireflyai/core/constants/my_images.dart';
import 'package:fireflyai/modules/features/barcode_scanner_view.dart';
import 'package:fireflyai/modules/features/extract_entities_view.dart';
import 'package:fireflyai/modules/features/image_labelling_view.dart';
import 'package:fireflyai/modules/features/language_detection_view.dart';
import 'package:fireflyai/modules/features/language_translation/translate_language_view.dart';
import 'package:fireflyai/modules/features/text_recognition/text_recognition_view.dart';
import 'package:flutter/material.dart';

final allFeatures = [
  MLFeatures(
    'Text Recognition',
    '● recognise and extract text from images',
    MyImages.textRecognition,
    TextRecognitionView(),
  ),
  MLFeatures(
    'Image Labelling',
    '● identify objects, animal species, products and more...',
    MyImages.imageClassification,
    ImageLabellingView(),
  ),
  MLFeatures(
    'Scan Barcode',
    '● scan and extract the data from barcodes.',
    MyImages.barcodeScanning,
    BarcodeScannerView(),
  ),
  MLFeatures(
    'Language Id',
    '● detect the language of text snippet',
    MyImages.languageDetection,
    LanguageDetectionView(),
  ),
  MLFeatures(
    'Lang Translation',
    '● translate text from one language to another',
    MyImages.onDeviceTranslate,
    const TranslateLanguageView(),
  ),
  MLFeatures(
    'Extract Entities',
    '● recognize specific entities in text snippet',
    MyImages.smartReply,
    SmartReplyView(),
  ),
  // MLFeatures(
  //   'Landmark ID',
  //   '● Identify popular landmarks in an image',
  //   MyImages.landmarkIdentification,
  //   const TranslateLanguageView(),
  // ),
];

class MLFeatures {
  String name, description, image;
  Widget page;

  MLFeatures(this.name, this.description, this.image, this.page);
}

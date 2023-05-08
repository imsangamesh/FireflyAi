import 'dart:async';
import 'dart:io';

import 'package:fireflyai/core/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/my_images.dart';
import '../../core/themes/my_colors.dart';
import '../../core/themes/my_textstyles.dart';
import '../../core/widgets/left_line_tile.dart';
import '../../core/widgets/my_buttons.dart';
import '../home/search_result_page_view.dart';

class BarcodeScannerView extends StatelessWidget {
  BarcodeScannerView({super.key});

  final imageFile = File('').obs;
  final loading = false.obs;
  final _myListKey = GlobalKey<AnimatedListState>();

  final displayValue = ''.obs;
  final rawValue = ''.obs;
  final cornerPoints = ''.obs;
  final format = ''.obs;
  final type = ''.obs;

  final List<String> dataList = RxList([]);

  final labels = [
    'Main Parameter',
    'Raw Data',
    'Image Type',
    'Image Format',
    'Corner Points',
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          imageFile(File(''));
          removeAllAndLoadNew();
          return true;
        },
        child: Scaffold(
          /// ------------------------------------- `app bar`
          appBar: AppBar(
            title: const Text('Barcode Scanner'),
            bottom: !loading()
                ? null
                : const PreferredSize(
                    preferredSize: Size(double.infinity, 10),
                    child: LinearProgressIndicator(
                      backgroundColor: MyColors.lightScaffoldBG,
                      minHeight: 3,
                    ),
                  ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// ----------------------------------- `don't have barcode`

                  if (imageFile().path == '')
                    InkWell(
                      onTap: () => launchUrl(Uri.parse(
                          'https://www.qr-code-generator.com/solutions/email-qr-code/')),
                      splashColor: ThemeColors.prim3,
                      child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 7),
                          color: ThemeColors.prim4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('don\'t have a qr code or barcode?'),
                              Text(
                                'create one',
                                style: MyTStyles.kTS13Medium.copyWith(
                                  decoration: TextDecoration.underline,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          )),
                    ),

                  /// ---------------------------- `upload image`
                  if (imageFile().path == '')
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 250,
                              width: 250,
                              child: Image.asset(MyImages.uploadImages),
                            ),
                          ],
                        ),
                      ),
                    ),

                  /// ---------------------------- `AnimatedList`
                  AnimatedList(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    key: _myListKey,
                    initialItemCount: dataList.length,
                    itemBuilder: (context, i, animation) {
                      return SizeTransition(
                        sizeFactor: animation,
                        child: LeftLineUnderlineBox(
                          labels[i],
                          dataList[i],
                          function: () {
                            Clipboard.setData(ClipboardData(text: dataList[i]));
                            Utils.showSnackBar('${labels[i]} copied!');
                          },
                          secondFun: dataList[i].startsWith('http') &&
                                  labels[i] == 'Main Parameter'
                              ? () => Utils.confirmDialogBox(
                                    'Open link?',
                                    dataList[i],
                                    yesFun: () => Get.to(
                                      () => SearchResultPageView(dataList[i],
                                          isUrl: true),
                                    ),
                                  )
                              : null,
                          secondIcon: Icons.open_in_new,
                        ),
                      );
                    },
                  ),

                  /// ---------------------------- `copy all button`
                  if (dataList.isNotEmpty)
                    Align(
                      alignment: Alignment.topRight,
                      child: MyOutlinedBtn(
                        'Copy all',
                        copyAll,
                        icon: Icons.copy_all,
                      ),
                    ),
                  const SizedBox(height: 100),
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
                onPressed: () =>
                    removeAllAndLoadNew(source: ImageSource.gallery),
                label: Row(
                  children: const [
                    Text(' Pick Image '),
                    Icon(Icons.photo),
                  ],
                ),
              ),
              FloatingActionButton.extended(
                heroTag: 'herotag2',
                onPressed: () =>
                    removeAllAndLoadNew(source: ImageSource.camera),
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

  /// ------------------------------------------------------ `Pick image`
  pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) {
      Utils.showSnackBar('Please pick the image', status: false);
      return;
    }
    imageFile(File(pickedFile.path));
    await decodeBarcodeImage();
  }

  /// ------------------------------------------------------ `decode bar code`
  decodeBarcodeImage() async {
    loading(true);

    final image = InputImage.fromFile(imageFile());
    final barcodeScanner = BarcodeScanner();
    List<Barcode> barcodes = await barcodeScanner.processImage(image);

    if (barcodes.isEmpty) {
      imageFile(File(''));
      loading(false);
      await barcodeScanner.close();
      Utils.showAlert(
        '😟 Oops!',
        'It seems that the image you\'ve uploaded is either not a barcode or it is not clear enough...',
      );
      return;
    }

    final barcode = barcodes.first;

    displayValue.value = barcode.displayValue ?? '';
    rawValue.value = barcode.rawValue ?? '';
    format.value = barcode.format.toString().split('.')[1];
    type.value = barcode.type.toString().split('.')[1];
    cornerPoints.value = barcode.cornerPoints == null
        ? ''
        : barcode.cornerPoints
            .toString()
            .substring(1, barcode.cornerPoints.toString().length);

    await barcodeScanner.close();
    loading(false);
    removeAllAndLoadNew();

    addItemInList(0, displayValue());
    addItemInList(1, rawValue());
    addItemInList(2, format());
    addItemInList(3, type());
    addItemInList(4, cornerPoints());
  }

  /// ------------------------------------------------------ `Copy all`
  copyAll() {
    final text = '''${labels[0]}: ${displayValue()}\n
${labels[1]}: ${rawValue()}\n
${labels[2]}: ${format()}\n
${labels[3]}: ${type()}\n
${labels[4]}: ${cornerPoints()}''';

    Clipboard.setData(ClipboardData(text: text));

    Utils.showSnackBar('Copied to clipboard', status: true);
  }

  /// ------------------------------------------------------ `List modifiers`
  ///----- `ADD`
  addItemInList(int i, dynamic data) {
    dataList.add(data);
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
        child: LeftLineUnderlineBox(labels[i], dataList[i]),
      ),
      duration: const Duration(milliseconds: 500),
    );
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => dataList.removeAt(i));
  }

  ///----- `REMOVE ALL AND LOAD`
  removeAllAndLoadNew({ImageSource? source}) {
    if (dataList.isEmpty) {
      if (source != null) pickImage(source);
      return;
    }

    for (var i = dataList.length - 1; i >= 0; i--) {
      removeItemInList(i);
    }

    if (source != null) {
      Future.delayed(const Duration(milliseconds: 300))
          .then((value) => pickImage(source));
    }
  }
}

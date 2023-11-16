import 'dart:io';

import 'package:fireflyai/core/themes/my_colors.dart';
import 'package:fireflyai/core/themes/my_textstyles.dart';
import 'package:fireflyai/core/utilities/utils.dart';
import 'package:fireflyai/core/widgets/left_line_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/my_images.dart';

class ImageLabellingView extends StatelessWidget {
  ImageLabellingView({super.key});

  final imageFile = File('').obs;
  final loading = false.obs;
  final RxList<String> imageLabels = RxList();
  final RxList<String> confidences = RxList();
  final _myListKey = GlobalKey<AnimatedListState>();

  final minConfiValue = 50.obs;
  final List<int> confiLevels = [50, 60, 70, 80, 90];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            title: const Text('Image Labelling'),
            bottom: !loading()
                ? null
                : const PreferredSize(
                    preferredSize: Size(double.infinity, 10),
                    child: LinearProgressIndicator(),
                  ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
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

                  /// ---------------------------------------------- `select accuracy`
                  if (imageFile().path != '')
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 35,
                            child: Text(
                              'Accuracy level  ',
                              style: MyTStyles.kTS15Medium.copyWith(
                                color: ThemeColors.prim1,
                              ),
                            ),
                          ),
                          Container(
                            height: 35,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: ThemeColors.shade2,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: ThemeColors.prim3),
                            ),
                            // ------------------ `dropdown`
                            child: DropdownButton<int>(
                              value: minConfiValue(),
                              iconSize: 0,
                              underline: const SizedBox(),
                              dropdownColor: ThemeColors.primary(255),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: confiLevels.map((int ech) {
                                return DropdownMenuItem(
                                  value: ech,
                                  child: Text('   + $ech%   '),
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                if (minConfiValue() != newValue) {
                                  getImageLabels();
                                }
                                minConfiValue(newValue);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  /// ---------------------------------------------- `AnimatedList`
                  AnimatedList(
                    padding: const EdgeInsets.only(bottom: 100),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    key: _myListKey,
                    initialItemCount: imageLabels.length,
                    itemBuilder: (context, i, animation) {
                      return SizeTransition(
                        sizeFactor: animation,
                        child: LeftLineTile(
                          imageLabels[i],
                          confidences[i],
                        ),
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
    await getImageLabels();
  }

  /// ------------------------------------------------------ `get Image labels`
  getImageLabels() async {
    loading(true);
    final image = InputImage.fromFile(imageFile());
    final labelDetector = ImageLabeler(
      options: ImageLabelerOptions(),
    );

    // confidenceThreshold: minConfiValue() / 100

    List<ImageLabel> imgLabels = await labelDetector.processImage(image);
    removeAllAndLoadNew();

    if (imgLabels.isEmpty) {
      loading(false);
      await labelDetector.close();
      Utils.showAlert(
        '😟 Oops!',
        'We couldn\'t detect the image you\'ve uploaded, please try other one...',
      );
      return;
    }

    for (var i = 0; i < imgLabels.length; i++) {
      if (imgLabels[i].confidence >= minConfiValue() / 100) {
        addItemInList(
          i,
          imgLabels[i].label,
          '${(imgLabels[i].confidence * 100).toStringAsFixed(0)}%',
        );
      }
    }

    await labelDetector.close();
    loading(false);
  }

  /// ------------------------------------------------------ `List modifiers`
  ///----- `ADD`
  addItemInList(int i, String label, String confi) {
    imageLabels.add(label);
    confidences.add(confi);

    _myListKey.currentState?.insertItem(
      i,
      duration: const Duration(milliseconds: 300),
    );
  }

  ///----- `REMOVE`
  removeItemInList(int i) {
    _myListKey.currentState?.removeItem(
      i,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: LeftLineTile(imageLabels[i], confidences[i]),
      ),
      duration: const Duration(milliseconds: 300),
    );

    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => imageLabels.removeAt(i));
  }

  ///----- `REMOVE ALL AND LOAD`
  removeAllAndLoadNew({ImageSource? source}) {
    if (imageLabels.isEmpty) {
      if (source != null) pickImage(source);
      return;
    }

    for (var i = imageLabels.length - 1; i >= 0; i--) {
      removeItemInList(i);
    }

    if (source != null) {
      Future.delayed(const Duration(milliseconds: 300))
          .then((value) => pickImage(source));
    }
  }
}

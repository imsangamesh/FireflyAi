import 'dart:developer';
import 'dart:io';

import 'package:fireflyai/core/constants/my_constants.dart';
import 'package:fireflyai/core/constants/my_pref_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/utilities/utils.dart';

class ProfileController extends GetxController {
  //
  final _box = GetStorage();

  final greetingText = 'Good Morning!'.obs;

  final RxString username = (auth.currentUser!.displayName ?? '').obs;
  final profile = File('').obs;
  final backdrop = File('').obs;

  final _pr = true.obs;
  final _bg = true.obs;

  changeName(String name) {
    _box.write(MyPrefKeys.profileUserName, name);
    username(name);
  }

  /// ------------------------------------------------------ `set up Profile details`
  setUpProfilePage() {
    log('------------------------- setting Profile page ----------------------');
    configureGreetingText();
    final name = _box.read<String>(MyPrefKeys.profileUserName);
    final pr = _box.read(MyPrefKeys.profileImage);
    final bg = _box.read(MyPrefKeys.backdropImage);

    profile(pr == null ? File('') : File(pr));
    backdrop(bg == null ? File('') : File(bg));
    username(name ?? auth.currentUser!.displayName);
  }

  /// ------------------------------------------------------ `save Profile images`
  setProfileImage(SaveImgType type, double height, double width) async {
    final rootPath = (await getApplicationDocumentsDirectory()).path;
    double x, y;
    if (type == SaveImgType.profile) {
      x = 1;
      y = 1;
    } else {
      x = width;
      y = height * 0.2;
    }

    /// `picking image`
    final pickedImg = await pickImage();
    if (pickedImg == null) return;

    /// `cropping image`
    final croppedImg = await cropImage(pickedImg.path, x, y);
    if (croppedImg == null) return;

    /// `copying image to local storage`
    File finalImg;
    if (type == SaveImgType.profile) {
      finalImg = await croppedImg.copy('$rootPath/profile$_pr.jpg');

      _pr(!_pr()); // `to update widget due to same path everytime`
      profile(File(finalImg.path));
      _box.write(MyPrefKeys.profileImage, profile().path);
    } else {
      finalImg = await croppedImg.copy('$rootPath/backdrop$_bg.jpg');

      _bg(!_bg()); // `to update widget due to same path everytime`
      backdrop(File(finalImg.path));
      _box.write(MyPrefKeys.backdropImage, backdrop().path);
    }
    Utils.showSnackBar('Image updated!', status: true);
  }

  /// ------------------------------------------------------ `Delete Profile images`
  deleteProfileImage(SaveImgType type) async {
    final rootPath = (await getApplicationDocumentsDirectory()).path;

    if (type == SaveImgType.profile) {
      final img = File('$rootPath/profile$_pr.jpg');
      if (img.existsSync()) img.deleteSync();

      profile(File(''));
      _box.remove(MyPrefKeys.profileImage);
    } else {
      final img = File('$rootPath/backdrop$_bg.jpg');
      if (img.existsSync()) img.deleteSync();

      backdrop(File(''));
      _box.remove(MyPrefKeys.backdropImage);
    }
    Utils.showSnackBar('Image deleted!');
  }

  /// ------------------------------------------------------ `Pick image`
  Future<File?> pickImage() async {
    final pickedImg = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImg == null) {
      Utils.showSnackBar('Please pick the image', status: false);
      return null;
    }
    return File(pickedImg.path);
  }

  /// ------------------------------------------------------ `Crop image`
  Future<File?> cropImage(String imgPath, double x, double y) async {
    //
    final image = await ImageCropper().cropImage(
      sourcePath: imgPath,
      aspectRatio: CropAspectRatio(ratioX: x, ratioY: y),
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
      ],
    );

    if (image == null) {
      Utils.showAlert(
        'Alert!',
        'please proceed to crop the image to get the best view.',
      );
      return null;
    }

    return File(image.path);
  }

  /// ------------------------------------------------------ `configure greeting message`
  configureGreetingText() {
    final time = DateTime.now();

    if (time.hour >= 12 && time.hour <= 16) {
      greetingText('Good Afternoon!');
    } else if (time.hour > 16 && time.hour <= 21) {
      greetingText('Pleasant Evening!');
    } else if (time.hour > 21 || time.hour < 5) {
      greetingText('Nightly Nights!');
    }
  }
}

enum SaveImgType { profile, backdrop }

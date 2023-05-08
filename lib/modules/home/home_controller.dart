import 'dart:developer';

import 'package:fireflyai/core/constants/my_pref_keys.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  //
  final _box = GetStorage();

  final RxList<dynamic> interests = RxList([
    'Lifestyle',
    'Technology',
    'Music',
    'Education',
    'Sports',
    'Recipes',
    'Electronics',
    'Health',
    'TV shows',
    'Fashion',
    'Business',
    'Art',
    'News',
  ]);

  setUpInterests() {
    log('------------------------- setting up interests ----------------------');
    final intrsts = _box.read<List>(MyPrefKeys.interestsList) ??
        [
          'Lifestyle',
          'Technology',
          'Music',
          'Education',
          'Sports',
          'Recipes',
          'Electronics',
          'Health',
          'TV shows',
          'Fashion',
          'Business',
          'Art',
          'News',
        ];

    interests(intrsts);
  }

  addNewInterests(String newInterest) {
    interests.add(newInterest);
    _box.write(MyPrefKeys.interestsList, interests.toList());
  }

  resetInterests() {
    final intrsts = [
      'Lifestyle',
      'Technology',
      'Music',
      'Education',
      'Sports',
      'Recipes',
      'Electronics',
      'Health',
      'TV shows',
      'Fashion',
      'Business',
      'Art',
      'News',
    ];

    _box.write(MyPrefKeys.interestsList, intrsts);
    interests(intrsts);
  }
}

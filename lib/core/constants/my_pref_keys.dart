import 'package:fireflyai/core/constants/my_constants.dart';

class MyPrefKeys {
  static const isDarkMode = 'IS_DARK_MODE';
  static const userStatus = 'IS_USER_PRESENT';

  static const profileUserName = 'PROFILE_USER_NAME';
  static const profileImage = 'PROFILE_IMAGE';
  static const backdropImage = 'BACKGROUND_IMAGE';
  static const interestsList = 'INTERESTS_SET';

  /// ========================== `FIRESTORE`
  static final fireAuthId = auth.currentUser!.uid;

  static const userFireData = 'USER_FIRE_DATA';
  static const textHistory = 'TEXT_HISTORY';
  static const translationHistory = 'TRANSLATION_HISTORY';
}

class MyHelper {
  static String get genDateId =>
      'genId: ${DateTime.now().toIso8601String()}|||${DateTime.now().toIso8601String()}|||${DateTime.now().toIso8601String()}';

  static String profilePic =
      'https://img.freepik.com/premium-psd/3d-cartoon-avatar-smiling-man_1020-5130.jpg?size=338&ext=jpg&uid=R65626931&ga=GA1.2.1025021015.1655558182&semt=sph';

  static enumToString(dynamic enumData) => enumData.toString().split('.')[1];
}

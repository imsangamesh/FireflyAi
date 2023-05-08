import 'package:fireflyai/core/constants/my_constants.dart';
import 'package:fireflyai/core/themes/my_colors.dart';
import 'package:fireflyai/core/widgets/left_line_tile.dart';
import 'package:fireflyai/core/widgets/my_buttons.dart';
import 'package:fireflyai/modules/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/my_images.dart';
import '../../core/helpers/my_helper.dart';
import '../../core/themes/my_textstyles.dart';
import '../../core/themes/theme_controller.dart';
import '../../core/utilities/utils.dart';
import '../../core/widgets/my_close_btn.dart';
import '../auth/auth_controller.dart';

class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({super.key});

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  //
  String get name => auth.currentUser!.displayName ?? 'Guest User';
  String get email => auth.currentUser!.email ?? '';
  String get imageUrl => auth.currentUser!.photoURL ?? MyHelper.profilePic;

  final themeCntrlr = Get.put(ThemeController());
  final profileCntrlr = Get.put(ProfileController());
  final authController = Get.put(AuthController());

  final textCntrlr = TextEditingController();

  final isDark = Get.isDarkMode.obs;

  primary(int a) => isDark.value
      ? MyColors.lightPurple.withAlpha(a)
      : MyColors.pink.withAlpha(a);

  @override
  void initState() {
    profileCntrlr.setUpProfilePage();
    super.initState();
  }

  @override
  void dispose() {
    textCntrlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<ProfileController>(
      builder: (cntrlr) => Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: context.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// ------------------------------------------------------------ `appbar content` - `1`
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 55),
                      height: context.height * 0.2,
                      decoration: BoxDecoration(
                        color: primary(255),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                        image: cntrlr.backdrop().path == ''
                            ? null
                            : DecorationImage(
                                image: FileImage(cntrlr.backdrop()),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: AppBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        automaticallyImplyLeading: false,
                        leadingWidth: 0,
                        title: cntrlr.backdrop().path == ''
                            ? const Text('it\'s all ME')
                            : null,
                        actions: [
                          const SizedBox(width: 7),
                          const MyBackBtn(),
                          const Spacer(),
                          MyBackBtn(
                            icon: Icons.power_settings_new_rounded,
                            onTap: logout,
                            size: 20,
                          ),
                          const SizedBox(width: 7),
                        ],
                      ),
                    ),

                    /// ----------------------------- `name`
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        cntrlr.username(),
                        style: MyTStyles.kTS18Medium,
                      ),
                    ),

                    /// ----------------------------- `email`
                    Text(
                      email,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style:
                          MyTStyles.kTS13Regular.copyWith(color: MyColors.grey),
                    ),
                  ],
                ),

                /// ------------------------------------------------------------ `Setting Features` - `2`
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// ----------------------------- `heading`
                      IconTextTile(
                        Icons.category,
                        'customisations for you',
                        color: isDark.value
                            ? MyColors.lightPurple
                            : MyColors.midPink,
                      ),

                      Divider(
                        height: 30,
                        indent: 30,
                        endIndent: 30,
                        color: primary(150),
                      ),

                      /// ----------------------------- `edit name`
                      ProfileSettingsTile(
                        Icons.short_text_rounded,
                        'Wanna edit your name?',
                        editName,
                        false,
                        isDark(),
                      ),

                      /// ----------------------------- `update Profile`
                      ProfileSettingsTile(
                        Icons.account_circle_outlined,
                        'Your new flashy shot...',
                        () => setImages(SaveImgType.profile),
                        cntrlr.profile().path != '',
                        isDark(),
                        onDelete: () => deleteImages(SaveImgType.profile),
                      ),

                      /// ----------------------------- `update background`
                      ProfileSettingsTile(
                        Icons.photo_size_select_actual_outlined,
                        'Backdrop to suit your style',
                        () => setImages(SaveImgType.backdrop),
                        cntrlr.backdrop().path != '',
                        isDark(),
                        onDelete: () => deleteImages(SaveImgType.backdrop),
                      ),

                      /// ----------------------------- `theme toggler`
                      ProfileSettingsTile(
                        Icons.auto_awesome_rounded,
                        isDark()
                            ? 'Lively Nightly nights!'
                            : 'Light & Bright mood!',
                        toggleTheme,
                        false,
                        isDark(),
                        trailing: themeSwitch(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        /// -------------------------------------------------------------------- `top profile Avatar`
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterTop,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(top: context.height * 0.105),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: primary(50),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0x17000000),
              child: SizedBox(
                height: 80,
                width: 80,
                child: FloatingActionButton(
                  heroTag: 'profile',
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  onPressed: () => Get.to(() => const ProfileScreenView()),
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 3,
                        color: primary(255),
                      ),
                    ),
                    child: Ink.image(
                      image: cntrlr.profile().path == ''
                          ? NetworkImage(imageUrl) as ImageProvider<Object>
                          : FileImage(cntrlr.profile()),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  editName() {
    Utils.inputDialogBox(
      'your new name...',
      textCntrlr,
      yesFun: () => profileCntrlr.changeName(
        textCntrlr.text.trim(),
      ),
    );
  }

  setImages(SaveImgType type) {
    profileCntrlr.setProfileImage(
      type,
      context.height,
      context.width,
    );
  }

  deleteImages(SaveImgType type) {
    Utils.confirmDialogBox(
      'Alert!',
      'do you want to delete the uploaded ${MyHelper.enumToString(type)} image?',
      yesFun: () => profileCntrlr.deleteProfileImage(type),
    );
  }

  themeSwitch() {
    return Switch(
      value: isDark(),
      onChanged: (val) => toggleTheme(),
      activeThumbImage: const AssetImage(MyImages.darkMode),
      activeColor: MyColors.lightPurple,
      inactiveThumbImage: const AssetImage(MyImages.lightMode),
    );
  }

  toggleTheme() {
    themeCntrlr.toggleThemeMode();
    isDark(!isDark());
  }

  logout() {
    Utils.confirmDialogBox(
      'Wanna Logout?',
      'Hey you\'d have stayed a little longer and explored our models more...',
      yesFun: authController.logout,
    );
  }
}

class ProfileSettingsTile extends StatelessWidget {
  const ProfileSettingsTile(
    this.icon,
    this.label,
    this.onTap,
    this.isDone,
    this.isDark, {
    this.onDelete,
    this.trailing,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;
  final bool isDone;
  final VoidCallback? onDelete;
  final Widget? trailing;

  primary(int a) =>
      isDark ? MyColors.lightPurple.withAlpha(a) : MyColors.pink.withAlpha(a);

  trailingIcon() {
    if (isDone) {
      return MyIconBtn(
        Icons.done_outline,
        onDelete ?? () {},
        size: 28,
        color: MyColors.green,
      );
    } else {
      return const Icon(Icons.chevron_right, color: MyColors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(icon, color: primary(255), size: 28),
          ),
          title: Text(
            label,
            style: MyTStyles.quickSand(16),
          ),
          trailing: trailing ?? trailingIcon()),
    );
  }
}

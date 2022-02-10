import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/user_model.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  UserPreferences _userPreferences = new UserPreferences();
  UserModel userModel = new UserModel();
  String fullVersion = 'x.x.x';
  String locale = '';
  bool langValue = true;

  ProfileProvider() {
    _fnFetchUserInfo();
    fnFetchAppVersion();
    fnFetchLocale();
  }

  Future _fnFetchUserInfo() async {
    this.userModel = (await _userPreferences.getUserData())!;
    notifyListeners();
  }

  Future fnFetchAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    fullVersion = "${packageInfo.version}+${packageInfo.buildNumber}";
    notifyListeners();
  }

  Future fnFetchLocale() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    locale = _prefs.getString(KeyHelper.KEY_LOCALE)!;
  }

  Widget fnOnSwitchLanguage(BuildContext context, bool value) {
    return CustomWidget.showConfirmationDialog(
      context,
      desc: AppLocalizations.instance.text('TXT_LANGUAGE_INFO'),
      function: () {
        this.langValue = value;
        notifyListeners();
      },
    );
  }

  Future fnLogout() async {
    await UserPreferences().removeUserData();
    Get.offAndToNamed(StartScreen.tag);
  }
}
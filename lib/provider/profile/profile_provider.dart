import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/user_model.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  UserPreferences _userPreferences = new UserPreferences();
  UserModel userModel = new UserModel();
  String fullVersion = 'x.x.x';
  String locale = '';
  bool switchVal = true;
  String language = '';

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
    if (locale == 'en') {
      language = 'Bahasa Indonesia';
      switchVal = true;
    } else {
      language = 'English';
      switchVal = false;
    }
    notifyListeners();
  }

  Future fnOnSwitchLanguage(bool value) async {
    SharedPreferences? _prefs = await SharedPreferences.getInstance();
    this.switchVal = value;

    if (switchVal) {
      locale = 'en';
    } else {
      locale = 'id';
    }

    _prefs.setString(KeyHelper.KEY_LOCALE, locale);
    AppLocalizations.instance.load(Locale(locale));
    notifyListeners();
  }

  Future fnLogout() async {
    await UserPreferences().removeUserData();
    Get.offAndToNamed(StartScreen.tag);
  }
}
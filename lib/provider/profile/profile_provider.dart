
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/user_detail_model.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/route_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileProvider extends ChangeNotifier {
  final _storage = new FlutterSecureStorage();
  UserPreferences _userPreferences = new UserPreferences();
  UserDetailModel userModel = new UserDetailModel();
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
    final _storage = new FlutterSecureStorage();
    locale = (await _storage.read(key: KeyHelper.KEY_LOCALE))!;
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
    this.switchVal = value;

    if (switchVal) {
      locale = 'en';
    } else {
      locale = 'id';
    }

    _storage.write(key: KeyHelper.KEY_LOCALE, value: locale);
    AppLocalizations.instance.load(Locale(locale));
    notifyListeners();
  }

  Future fnLogout() async {
    await _userPreferences.removeUserToken();
    Get.offAndToNamed(StartScreen.tag);
  }
}
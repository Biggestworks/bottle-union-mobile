
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/region_list_model.dart';
import 'package:eight_barrels/model/auth/user_detail_model.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/route_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileProvider extends ChangeNotifier {
  AuthService _authService = new AuthService();
  final _storage = new FlutterSecureStorage();
  UserPreferences _userPreferences = new UserPreferences();
  UserDetailModel userModel = new UserDetailModel();
  RegionListModel regionList = new RegionListModel();

  String fullVersion = 'x.x.x';
  String locale = '';
  bool switchVal = true;
  String language = '';
  int? selectedRegionId;
  String? selectedRegion;

  ProfileProvider() {
    _fnFetchUserInfo().then((_) => _fnFetchRegionList());
    _fnFetchAppVersion();
    _fnFetchLocale();
  }

  Future _fnFetchUserInfo() async {
    this.userModel = (await _userPreferences.getUserData())!;
    selectedRegionId = userModel.region?.id;
    notifyListeners();
  }

  Future _fnFetchAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    fullVersion = "${packageInfo.version}+${packageInfo.buildNumber}";
    notifyListeners();
  }

  Future _fnFetchLocale() async {
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
    await _userPreferences.removeFcmToken();
    await _storage.delete(key: KeyHelper.KEY_USER_REGION_ID);
    await _storage.delete(key: KeyHelper.KEY_USER_REGION_NAME);
    Get.offNamedUntil(StartScreen.tag, (route) => false);
  }

  Future _fnFetchRegionList() async {
    regionList = (await _authService.regionList())!;
    var _regionId = await _storage.read(key: KeyHelper.KEY_USER_REGION_ID) ?? null;
    var _regionName = await _storage.read(key: KeyHelper.KEY_USER_REGION_NAME) ?? null;

    if (_regionId != null && _regionName != null) {
      selectedRegionId = int.parse(_regionId);
      selectedRegion = _regionName;
    } else {
      if (regionList.data != null) {
        selectedRegionId = regionList.data?.singleWhere((i) => i.id == selectedRegionId).id;
        selectedRegion = regionList.data?.singleWhere((i) => i.id == selectedRegionId).name;
      }
    }
    notifyListeners();
  }

  Future fnOnSelectRegion(int? value) async {
    Get.back();
    this.selectedRegionId = value;
    await _storage.write(key: KeyHelper.KEY_USER_REGION_ID, value: value.toString());
    await _storage.write(key: KeyHelper.KEY_USER_REGION_NAME, value: regionList.data?.singleWhere((i) => i.id == value).name);
    notifyListeners();
  }
}
import 'dart:async';

import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/route_manager.dart';

class SplashProvider extends ChangeNotifier {
  UserPreferences _userPreferences = new UserPreferences();
  final _storage = new FlutterSecureStorage();

  Future fnAuthentication() async {
    var _res = await _userPreferences.getUserData();
    String? _isGuest = await _userPreferences.getGuestStatus();

    if (_isGuest == 'true') {
      Future.delayed(Duration(seconds: 2)).then((_) => Get.offAndToNamed(BaseHomeScreen.tag, arguments: BaseHomeScreen()));
    } else {
      /// LOGOUT USER IF TOKEN IS INVALID
      if (_res?.status == 'Token is Invalid') {
        await _userPreferences.removeUserToken();
        await _userPreferences.removeFcmToken();
        await _storage.delete(key: KeyHelper.KEY_USER_REGION_ID);
        await _storage.delete(key: KeyHelper.KEY_USER_REGION_NAME);
        Get.offNamedUntil(StartScreen.tag, (route) => false);
      } else {
        var _token = await _userPreferences.getUserToken();

        if (_token != null) {
          Future.delayed(Duration(seconds: 2)).then((_) => Get.offAndToNamed(BaseHomeScreen.tag, arguments: BaseHomeScreen()));
          // Future.delayed(Duration(seconds: 2)).then((_) => Get.offAndToNamed(OnBoardingScreen.tag));
        } else {
          Future.delayed(Duration(seconds: 2)).then((_) => Get.offAndToNamed(StartScreen.tag));
        }
      }
    }
  }

}
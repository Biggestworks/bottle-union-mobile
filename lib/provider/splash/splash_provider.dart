import 'dart:async';

import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SplashProvider extends ChangeNotifier {
  UserPreferences _userPreferences = new UserPreferences();
  Future fnAuthentication() async {
    var _token = await _userPreferences.getUserToken();

    if (_token != null) {
      Future.delayed(Duration(seconds: 2)).then((_) => Get.offAndToNamed(BaseHomeScreen.tag, arguments: BaseHomeScreen()));
      // Future.delayed(Duration(seconds: 2)).then((_) => Get.offAndToNamed(OnBoardingScreen.tag));
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) => Get.offAndToNamed(StartScreen.tag));
    }
  }
}
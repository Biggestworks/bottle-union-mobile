import 'dart:async';

import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashProvider extends ChangeNotifier {
  Future fnAuthentication() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _token = _prefs.getString(KeyHelper.KEY_TOKEN);

    if (_token != null) {
      Future.delayed(Duration(seconds: 2)).then((_) => Get.offAndToNamed(BaseHomeScreen.tag, arguments: BaseHomeScreen()));
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) => Get.offAndToNamed(StartScreen.tag));
    }
  }
}
import 'dart:async';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/user_model.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:eight_barrels/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SplashProvider extends ChangeNotifier {
  UserPreferences _userPreferences = new UserPreferences();

  Future fnAuthentication() async {
    UserModel? _user = await _userPreferences.getUserData();
    var _token = _user?.token;

    if (_token != null) {
      Future.delayed(Duration(seconds: 2)).then((_) => Get.offAndToNamed(HomeScreen.tag));
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) => Get.offAndToNamed(StartScreen.tag));
    }
  }
}
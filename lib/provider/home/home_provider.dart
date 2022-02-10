import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/user_model.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {

  UserPreferences _userPreferences = new UserPreferences();
  UserModel userModel = new UserModel();

  final List<String> bannerList = [
    'assets/images/banner_1.jpg',
    'assets/images/banner_2.webp',
    'assets/images/banner_3.webp',
  ];

  HomeProvider() {
    _fnFetchUserInfo();
  }

  Future _fnFetchUserInfo() async {
    this.userModel = (await _userPreferences.getUserData())!;
    notifyListeners();
  }
}

import 'dart:convert';

import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/model/auth/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  Future? saveUserData(Map<String, dynamic> response) async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _user = jsonEncode(response);
      _prefs.setString(KeyHelper.USER, _user);
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> _userMap = jsonDecode(_prefs.getString(KeyHelper.USER)!);
      var user = UserModel.fromJson(_userMap);
      return user;
    } catch (e) {
      print(e);
    }
  }

  removeUserData() async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.remove(KeyHelper.USER);
    } catch (e) {
      print(e);
    }
  }

  Future saveFcmToken(String token) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(KeyHelper.KEY_FCM_TOKEN, token);
  }

  Future<String?> getFcmToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? token = _prefs.getString(KeyHelper.KEY_FCM_TOKEN);
    return token;
  }

  removeFcmToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove(KeyHelper.KEY_FCM_TOKEN);
  }
}

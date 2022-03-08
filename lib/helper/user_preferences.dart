

import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/model/auth/user_detail_model.dart';
import 'package:get/get_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences extends GetConnect {

  Future? saveUserToken(String token) async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString(KeyHelper.KEY_TOKEN, token);
    } catch (e) {
      print(e);
    }
  }

  Future<UserDetailModel?> getUserData() async {
    UserDetailModel _model = new UserDetailModel();
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _token = _prefs.getString(KeyHelper.KEY_TOKEN);

    try {
      Response _response = await get(
        URLHelper.USER_URL,
        headers: {
          "Accept": "application/json",
          "User-Agent": "Persada Apps 1.0",
          "Authorization": "Bearer $_token",
        }
      );
      _model = UserDetailModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  removeUserToken() async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.remove(KeyHelper.KEY_TOKEN);
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

  Future? saveOtpToken(String token) async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString(KeyHelper.KEY_OTP_TOKEN, token);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> getOtpToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? token = _prefs.getString(KeyHelper.KEY_OTP_TOKEN);
    return token;
  }

}

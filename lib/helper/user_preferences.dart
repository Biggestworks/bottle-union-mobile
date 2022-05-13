
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/model/auth/user_detail_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_connect.dart';

class UserPreferences extends GetConnect {
  final _storage = new FlutterSecureStorage();

  Future? saveUserToken(String token) async {
    try {
      await _storage.write(key: KeyHelper.KEY_TOKEN, value: token);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> getUserToken() async {
    String? token;

    try {
      token = await _storage.read(key: KeyHelper.KEY_TOKEN);
    } catch (e) {
      print(e);
    }
    return token;
  }

  Future<UserDetailModel?> getUserData() async {
    UserDetailModel _model = new UserDetailModel();

    try {
      var _token = await _storage.read(key: KeyHelper.KEY_TOKEN);
      Response _response = await get(
        URLHelper.userUrl,
        headers: {
          "Accept": "application/json",
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
      _storage.delete(key: KeyHelper.KEY_TOKEN);
    } catch (e) {
      print(e);
    }
  }

  Future saveFcmToken(String token) async {
    try {
      print('save: $token');
      await _storage.write(key: KeyHelper.KEY_FCM_TOKEN, value: token);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> getFcmToken() async {
    String? token;

    try {
      token = await _storage.read(key: KeyHelper.KEY_FCM_TOKEN);
      print('get: ${token ?? '-'}');
    } catch (e) {
      print(e);
    }
    return token;
  }

  removeFcmToken() async {
    try {
      _storage.delete(key: KeyHelper.KEY_FCM_TOKEN);
    } catch (e) {
      print(e);
    }
  }

  Future? saveOtpToken(String token) async {
    try {
      await _storage.write(key: KeyHelper.KEY_OTP_TOKEN, value: token);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> getOtpToken() async {
    String? token;

    try {
      token = await _storage.read(key: KeyHelper.KEY_OTP_TOKEN);
    } catch (e) {
      print(e);
    }
    return token;
  }

}

import 'dart:io';

import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/model/auth/user_detail_model.dart';
import 'package:eight_barrels/model/auth/user_model.dart';
import 'package:eight_barrels/model/default_model.dart';
import 'package:get/get_connect.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService extends GetConnect {

  Future<Map<String, String>?> _headersAuth() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _token = _prefs.getString(KeyHelper.KEY_TOKEN);

    return {
      "Accept": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  Future<UserModel?> updateProfile({
    String? fullName,
    String? dob,
    String? email,
    String? phone,
    String? gender,
    int? regionId,
  }) async {
    UserModel _model = new UserModel();

    final Map<String, dynamic> _data = {
      "fullname": fullName,
      "date_of_birth": dob,
      "email": email,
      "phone": phone,
      "gender": gender,
      "id_region": regionId,
    };

    try {
      Response _response = await post(
        URLHelper.UPDATE_PROFILE_URL,
        _data,
        headers: await _headersAuth(),
      );
      print(_response.body);
      _model = UserModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<UserDetailModel?> getUser() async {
    UserDetailModel _model = new UserDetailModel();

    try {
      Response _response = await get(
        URLHelper.USER_URL,
        headers: await _headersAuth(),
      );
      _model = UserDetailModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<DefaultModel?> updateUserAvatar({File? image}) async {
    DefaultModel _model = new DefaultModel();
    MultipartFile? _imageFile;

    try {
      if (image != null) {
        _imageFile = MultipartFile(
          image.path,
          filename: basename(image.path),
          contentType: MediaType(
            "image",
            basename(image.path),
          ).type,
        );
      }

      FormData _data = new FormData({
        "image": _imageFile
      });

      Response _response = await post(
        URLHelper.UPDATE_AVATAR_URL,
        _data,
        headers: await _headersAuth(),
      );
      _model = DefaultModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<DefaultModel?> changePassword({
    String? oldPass,
    String? newPass,
    String? confirmPass,
  }) async {
    DefaultModel _model = new DefaultModel();

    final Map<String, dynamic> _data = {
      "old_password": oldPass,
      "password": newPass,
      "password_confirmation": confirmPass,
    };

    try {
      Response _response = await post(
        URLHelper.NEW_PASSWORD_URL,
        _data,
        headers: await _headersAuth(),
      );
      print(_response.body);
      _model = DefaultModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<DefaultModel?> resetPassword({
    String? newPass,
    String? confirmPass,
    required String token,
  }) async {
    DefaultModel _model = new DefaultModel();

    final Map<String, dynamic> _data = {
      "password": newPass,
      "password_confirmation": confirmPass,
    };

    try {
      Response _response = await post(
        URLHelper.RESET_PASSWORD_URL,
        _data,
        headers: {
          "Accept": "application/json",

          "Authorization": "Bearer $token",
        },
      );
      print(_response.body);
      _model = DefaultModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

}
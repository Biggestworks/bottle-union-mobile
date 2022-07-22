import 'dart:io';

import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/user_detail_model.dart';
import 'package:eight_barrels/model/auth/user_model.dart';
import 'package:eight_barrels/model/default_model.dart';
import 'package:get/get_connect.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class ProfileService extends GetConnect {
  UserPreferences _userPreferences = new UserPreferences();

  Future<Map<String, String>?> _headersAuth() async {
    var _token = await _userPreferences.getUserToken();

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
        URLHelper.updateProfileUrl,
        _data,
        headers: await _headersAuth(),
      );
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
        URLHelper.userUrl,
        headers: await _headersAuth(),
      );
      _model = UserDetailModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<DefaultModel?> updateUserAvatar({required File image}) async {
    DefaultModel _model = new DefaultModel();
    MultipartFile? _imageFile;

    try {
      _imageFile = MultipartFile(
        image.path,
        filename: basename(image.path),
        contentType: MediaType(
          "image",
          basename(image.path),
        ).type,
      );

      FormData _data = new FormData({
        "image": _imageFile
      });

      Response _response = await post(
        URLHelper.updateAvatarUrl,
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
        URLHelper.newPasswordUrl,
        _data,
        headers: await _headersAuth(),
      );
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
        URLHelper.resetPasswordUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = DefaultModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<DefaultModel?> deleteAccount() async {
    DefaultModel _model = new DefaultModel();

    try {
      Response _response = await get(
        URLHelper.deleteAccountUrl,
        headers: await _headersAuth(),
      );
      _model = DefaultModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

}
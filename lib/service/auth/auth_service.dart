import 'dart:convert';

import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/auth_model.dart';
import 'package:eight_barrels/model/auth/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetConnect {
  UserPreferences? _userPreferences = new UserPreferences();

  var _headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  _headersAuth(token) {
    return {
      "Accept": "application/json",
      "User-Agent": "Persada Apps 1.0",
      "Authorization": "Bearer $token",
    };
  }

  Future<UserModel?> login({
    required String username,
    required String password}) async {
    Response _response;
    UserModel user = new UserModel();

    // var _fcmToken = await _userPreferences!.getFcmToken();

    final Map<String, dynamic> _data = {
      "username": username,
      "password": password,
      "fcm_token": "ABCD"
    };

    try {
      _response = await post(
        URLHelper.LOGIN_URL,
        _data,
        headers: _headers,
      );
      user = UserModel.fromJson(_response.body);
      await _userPreferences?.saveUserData(_response.body);
    } catch (e) {
      print(e);
    }

    return user;
  }

  Future<AuthModel?> register({
    required int idRegion,
    required String fullname,
    required String email,
    required String phone,
    required String gender,
    required String address,
    required String latitude,
    required String longitude,
    required String password,
    required String confirmPassword,
  }) async {
    Response _response;
    AuthModel auth = new AuthModel();

    final Map<String, dynamic> _data = {
      "id_region": idRegion,
      "fullname": fullname,
      "email": email,
      "phone": phone,
      "gender": gender,
      "addrres": address,
      "latitude": latitude,
      "longitude": longitude,
      "password": password,
      "password_confirmation": confirmPassword,
    };

    try {
      _response = await post(
          URLHelper.REGISTER_URL,
          _data,
          headers: _headers,
      );
      auth = AuthModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return auth;
  }
}

import 'dart:convert';

import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/region_list_model.dart';
import 'package:eight_barrels/model/auth/user_model.dart';
import 'package:eight_barrels/model/default_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get_connect.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService extends GetConnect {
  UserPreferences _userPreferences = new UserPreferences();

  var _headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  Future<UserModel?> login({
    required String username,
    required String password}) async {
    UserModel _model = new UserModel();

    var _fcmToken = await _userPreferences.getFcmToken();

    final Map<String, dynamic> _data = {
      "username": username,
      "password": password,
      "fcm_token": _fcmToken
    };

    try {
      http.Response _response = await http.post(
        Uri.parse(URLHelper.loginUrl),
        body: json.encode(_data),
        headers: _headers,
      );
      _model = UserModel.fromJson(json.decode(_response.body));

      if (_model.status == true) {
        await _userPreferences.saveUserToken(_model.token!);
      }

      /// GET CONNECT BUG
      // Response _response = await post(
      //   URLHelper.loginUrl,
      //   _data,
      //   headers: _headers,
      // );
      // _model = UserModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<UserModel?> register({
    required int idRegion,
    required String fullName,
    required String dob,
    required String email,
    required String phone,
    required String gender,
    required String password,
    required String confirmPassword,
    ///Address
    required String address,
    required String provinceId,
    required String province,
    required String cityId,
    required String city,
    required String latitude,
    required String longitude,
  }) async {
    UserModel _model = new UserModel();

    final Map<String, dynamic> _data = {
      "id_region": idRegion,
      "fullname": fullName,
      "date_of_birth": dob,
      "email": email,
      "phone": phone,
      "gender": gender,
      "password": password,
      "password_confirmation": confirmPassword,
      "address": address,
      "province_code": provinceId,
      "province_name": province,
      "city_code": cityId,
      "city_name": city,
      "latitude": latitude,
      "longitude": longitude,
    };

    try {
      http.Response _response = await http.post(
        Uri.parse(URLHelper.registerUrl),
        body: json.encode(_data),
        headers: _headers,
      );
      _model = UserModel.fromJson(json.decode(_response.body));

      /// GET CONNECT BUG
      // Response _response = await post(
      //     URLHelper.registerUrl,
      //     _data,
      //     headers: _headers,
      // );
      // _model = UserModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<RegionListModel?> regionList() async {
    RegionListModel _model = new RegionListModel();

    try {
      Response _response = await get(
        URLHelper.regionUrl,
        headers: _headers,
      );
      _model = RegionListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<bool?> validateAge({
    required String dob,
  }) async {
    DefaultModel _model = new DefaultModel();
    bool _isValidate = false;

    final Map<String, dynamic> _data = {
      "date_of_birth": dob
    };

    try {
      Response _response = await post(
        URLHelper.validateAgeUrl,
        _data,
        headers: _headers,
      );
      _model = DefaultModel.fromJson(_response.body);
      _isValidate = _model.status!;
    } catch (e) {
      print(e);
    }

    return _isValidate;
  }

  Future<bool?> validateEmailPhone({
    required String? value,
  }) async {
    DefaultModel _model = new DefaultModel();
    bool _isValidate = false;

    final Map<String, dynamic> _data = {
      "username": value
    };

    try {
      Response _response = await post(
        URLHelper.validateEmailPhoneUrl,
        _data,
        headers: _headers,
      );
      _model = DefaultModel.fromJson(_response.body);
      _isValidate = _model.status!;
    } catch (e) {
      print(e);
    }

    return _isValidate;
  }

  Future<UserModel?> registerSocmed({
    required String? email,
    required String? fullName,
    required String? phone,
    required String? providerUid,
    required String? providerId,
    required String? avatar,
  }) async {
    UserModel _model = new UserModel();

    final Map<String, dynamic> _data = {
      "displayName": fullName,
      "email": email,
      "provider_uid": providerUid,
      "provider_id": providerId,
      "phone": phone,
      "photoURL": avatar,
    };

    try {
      http.Response _response = await http.post(
        Uri.parse(URLHelper.registerSocMedUrl),
        body: json.encode(_data),
        headers: _headers,
      );
      _model = UserModel.fromJson(json.decode(_response.body));

      /// GET CONNECT BUG
      // Response _response = await post(
      //   URLHelper.registerSocMedUrl,
      //   _data,
      //   headers: _headers,
      // );
      // _model = UserModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<UserModel?> loginSocmed({
    required String? email,
    required String? fullName,
    required String? phone,
    required String? providerUid,
    required String? providerId,
    required String? avatar,
  }) async {
    UserModel _model = new UserModel();

    var _fcmToken = await _userPreferences.getFcmToken();

    final Map<String, dynamic> _data = {
      "fullname": fullName,
      "email": email,
      "provider_uid": providerUid,
      "provider_id": providerId,
      "phone": phone,
      "photoURL": avatar,
      "fcm_token": _fcmToken,
    };

    try {
      http.Response _response = await http.post(
        Uri.parse(URLHelper.loginSocMedUrl),
        body: json.encode(_data),
        headers: _headers,
      );
      _model = UserModel.fromJson(json.decode(_response.body));

      if (_model.status == true) {
        await _userPreferences.saveUserToken(_model.token!);
      }

      /// GET CONNECT BUG
      // Response _response = await post(
      //   URLHelper.loginSocMedUrl,
      //   _data,
      //   headers: _headers,
      // );
      // _model = UserModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<UserCredential?> authGoogle() async {
    UserCredential? _data;

    try {
      final GoogleSignInAccount? _googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication _googleAuth = await _googleUser!.authentication;
      final OAuthCredential _credential = GoogleAuthProvider.credential(
        accessToken: _googleAuth.accessToken,
        idToken: _googleAuth.idToken,
      );
      _data = await FirebaseAuth.instance.signInWithCredential(_credential);
    } catch (e) {
      print(e);
    }

    return _data;
  }

  Future<UserCredential?> authFacebook() async {
    UserCredential? _data;

    try {
      final LoginResult _result = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(_result.accessToken!.token);
      _data = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } catch (e) {
      print(e);
    }

    return _data;
  }

  Future<UserCredential?> authApple() async {
    UserCredential? _data;

    try {
      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final OAuthCredential _credential = OAuthProvider("apple.com").credential(
        idToken: result.identityToken,
      );
      _data = await FirebaseAuth.instance.signInWithCredential(_credential);
    } catch (e) {
      print(e);
    }

    return _data;
  }

}

import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/region_list_model.dart';
import 'package:eight_barrels/model/auth/user_model.dart';
import 'package:eight_barrels/model/default_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get_connect.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetConnect {
  UserPreferences? _userPreferences = new UserPreferences();

  var _headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  Future<UserModel?> login({
    required String username,
    required String password}) async {
    UserModel _model = new UserModel();

    var _fcmToken = await _userPreferences!.getFcmToken();

    final Map<String, dynamic> _data = {
      "username": username,
      "password": password,
      "fcm_token": _fcmToken
    };

    try {
      Response _response = await post(
        URLHelper.LOGIN_URL,
        _data,
        headers: _headers,
      );
      _model = UserModel.fromJson(_response.body);
      if (_model.status == true) {
        await _userPreferences?.saveUserToken(_model.token!);
      }
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
    required String address,
    required String latitude,
    required String longitude,
    required String password,
    required String confirmPassword,
  }) async {
    UserModel _model = new UserModel();

    final Map<String, dynamic> _data = {
      "id_region": idRegion,
      "fullname": fullName,
      "date_of_birth": dob,
      "email": email,
      "phone": phone,
      "gender": gender,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "password": password,
      "password_confirmation": confirmPassword,
    };

    try {
      Response _response = await post(
          URLHelper.REGISTER_URL,
          _data,
          headers: _headers,
      );
      _model = UserModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<RegionListModel?> regionList() async {
    RegionListModel _model = new RegionListModel();

    try {
      Response _response = await get(
        URLHelper.REGION_URL,
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
        URLHelper.VALIDATE_AGE_URL,
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
        URLHelper.VALIDATE_EMAIL_PHONE_URL,
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
      Response _response = await post(
        URLHelper.REGISTER_SOCMED_URL,
        _data,
        headers: _headers,
      );
      print(_response.body);
      _model = UserModel.fromJson(_response.body);
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

    var _fcmToken = await _userPreferences!.getFcmToken();

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
      Response _response = await post(
        URLHelper.LOGIN_SOCMED_URL,
        _data,
        headers: _headers,
      );
      print(_response.body);
      _model = UserModel.fromJson(_response.body);
      if (_model.status == true) {
        await _userPreferences?.saveUserToken(_model.token!);
      }
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<UserCredential?> authGoogle() async {
    UserCredential? _data;

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      _data = await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }

    return _data;
  }

  Future<UserCredential?> authFacebook() async {
    UserCredential? _data;

    try {
      final LoginResult result = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);
      _data = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } catch (e) {
      print(e);
    }

    return _data;
  }
}
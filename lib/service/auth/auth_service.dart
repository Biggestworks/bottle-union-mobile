
import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/auth_model.dart';
import 'package:eight_barrels/model/auth/region_list_model.dart';
import 'package:eight_barrels/model/auth/user_model.dart';
import 'package:eight_barrels/model/default_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_connect.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetConnect {
  UserPreferences? _userPreferences = new UserPreferences();

  var _headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  Future<Map<String, String>?> _headersAuth() async {
    var _user = await _userPreferences?.getUserData();
    var _token = _user?.token;

    return {
      "Accept": "application/json",
      "User-Agent": "Persada Apps 1.0",
      "Authorization": "Bearer $_token",
    };
  }

  Future<UserModel?> login({
    required String username,
    required String password}) async {
    UserModel _user = new UserModel();

    // var _fcmToken = await _userPreferences!.getFcmToken();

    final Map<String, dynamic> _data = {
      "username": username,
      "password": password,
      "fcm_token": "ABCD"
    };

    try {
      Response _response = await post(
        URLHelper.LOGIN_URL,
        _data,
        headers: _headers,
      );
      _user = UserModel.fromJson(_response.body);
      await _userPreferences?.saveUserData(_response.body);
    } catch (e) {
      print(e);
    }

    return _user;
  }

  Future<AuthModel?> register({
    required int idRegion,
    required String fullname,
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
    AuthModel _auth = new AuthModel();

    final Map<String, dynamic> _data = {
      "id_region": idRegion,
      "fullname": fullname,
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
      print(_response.body);
      _auth = AuthModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _auth;
  }

  Future<RegionListModel?> regionList() async {
    RegionListModel _region = new RegionListModel();

    try {
      Response _response = await get(
        URLHelper.REGION_URL,
        headers: _headers,
      );
      _region = RegionListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _region;
  }

  Future<bool?> validateAge({
    required String dob,
  }) async {
    DefaultResponse _res = new DefaultResponse();
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
      _res = DefaultResponse.fromJson(_response.body);
      _isValidate = _res.status!;
    } catch (e) {
      print(e);
    }

    return _isValidate;
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final data = await FirebaseAuth.instance.signInWithCredential(credential);

    print(data.user!.providerData.single);

    // final res = await authenticationSocmed(
    //   email: data.user.providerData.single.email,
    //   displayName: data.user.providerData.single.displayName,
    //   phoneNumber: data.user.providerData.single.phoneNumber,
    //   photoURL: data.user.providerData.single.photoURL,
    //   providerId: data.user.providerData.single.providerId,
    //   uid: data.user.providerData.single.uid,
    // );
    // return res;
  }
}
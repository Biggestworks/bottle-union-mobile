import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/validation_model.dart';
import 'package:eight_barrels/model/default_model.dart';
import 'package:get/get_connect.dart';

class ValidationService extends GetConnect {
  UserPreferences _userPreferences = new UserPreferences();

  var _headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  Future<DefaultModel?> sendOtp({String? email}) async {
    DefaultModel _model = new DefaultModel();

    final Map<String, dynamic> _data = {
      "email": email,
    };

    try {
      Response _response = await post(
        URLHelper.SEND_OTP_URL,
        _data,
        headers: _headers,
      );
      print(_response.body);
      _model = DefaultModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<ValidationModel?> validateOtp({String? code}) async {
    ValidationModel _model = new ValidationModel();

    final Map<String, dynamic> _data = {
      "validation_code": code,
    };

    try {
      Response _response = await post(
        URLHelper.VALIDATE_OTP_URL,
        _data,
        headers: _headers,
      );
      print(_response.body);
      _model = ValidationModel.fromJson(_response.body);
      _userPreferences.saveOtpToken(_model.token ?? '');
    } catch (e) {
      print(e);
    }

    return _model;
  }

}
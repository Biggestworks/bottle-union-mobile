// ignore_for_file: body_might_complete_normally_nullable

import 'package:eight_barrels/service/auth/auth_service.dart';

class TextValidation {
  AuthService _service = new AuthService();

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Field cannot be empty";
    } else {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value);
      if (!emailValid) {
        return "Email is not valid";
      }
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return "Field cannot be empty";
    } else {
      if (value.length < 6) {
        return "Password must be more than 6 characters";
      }
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String? confirmVal) {
    if (confirmVal!.isEmpty) {
      return "Field cannot be empty";
    } else {
      if (confirmVal != value) {
        return "Password is not match";
      }
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    String patttern = r'(^(?:[0]8)?[0-9]{10,16}$)';
    RegExp regExp = new RegExp(patttern);
    if (value!.isEmpty) {
      return "Field cannot be empty";
    } else {
      if (value.length < 10 || value.length > 16) {
        return "The Phone Number Range is Between 10-16 Digits";
      } else if (!regExp.hasMatch(value)) {
        return "Please Use Valid Phone Number (08XX-XX-..X)";
      }
    }
    return null;
  }

  String? validateField(String? value) {
    if (value!.isEmpty) {
      return "Field cannot be empty";
    }
  }

  Future<bool?> validateAge(String dob) async =>
      await _service.validateAge(dob: dob);

  Future<bool?> validateEmailExist(String value) async =>
      await _service.validateEmailPhone(value: value);

  String? validateYear(String? value) {
    if ((value?.length ?? 0) > 0 && (value?.length ?? 0) < 4) {
      return "Invalid Year";
    }
    return null;
  }
}

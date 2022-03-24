import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/screen/auth/login_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

abstract class SocmedAuthInterface {
  AuthService _service = new AuthService();

  Future fnAuthGoogle(BuildContext context, {bool isLogin = false}) async {
    onAuthStart();
    await _service.authGoogle().then((value) async {
      if (value != null) {
        /// USER LOGIN SOCMED
        if (isLogin) {
          var _res = await _service.loginSocmed(
            email: value.user!.providerData.single.email,
            fullName: value.user!.providerData.single.displayName,
            phone: value.user!.providerData.single.phoneNumber,
            avatar: value.user!.providerData.single.photoURL,
            providerId: value.user!.providerData.single.providerId,
            providerUid: value.user!.providerData.single.uid,
          );

          if (_res!.status != null) {
            if (_res.status == true) {
              onAuthFinish();
              Get.offAllNamed(BaseHomeScreen.tag, arguments: BaseHomeScreen());
            } else {
              onAuthFinish();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_res.message.toString()}')));
            }
          } else {
            onAuthFinish();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR'))));
          }
        }
        /// USER REGISTER SOCMED
        else {
          bool? _isValid = await _service.validateEmailPhone(value: value.user!.providerData.single.email!);

          if (_isValid == false) {
            var _res = await _service.registerSocmed(
              email: value.user!.providerData.single.email,
              fullName: value.user!.providerData.single.displayName,
              phone: value.user!.providerData.single.phoneNumber,
              avatar: value.user!.providerData.single.photoURL,
              providerId: value.user!.providerData.single.providerId,
              providerUid: value.user!.providerData.single.uid,
            );

            if (_res!.status == true) {
              onAuthFinish();
              Get.offAndToNamed(LoginScreen.tag, arguments: LoginScreen(
                providerId: value.user!.providerData.single.providerId,
                isRegister: true,)
              );
            } else {
              onAuthFinish();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR'))));
            }
          } else {
            onAuthFinish();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_EMAIL_ERROR'))));
          }
        }
      } else {
        onAuthFinish();
      }
    });
    onAuthFinish();
  }

  Future fnAuthFacebook(BuildContext context, {bool isLogin = false}) async {
    onAuthStart();
    await _service.authFacebook().then((value) async {
      if (value != null) {
        /// USER LOGIN SOCMED
        if (isLogin) {
          var _res = await _service.loginSocmed(
            email: value.user!.providerData.single.email,
            fullName: value.user!.providerData.single.displayName,
            phone: value.user!.providerData.single.phoneNumber,
            avatar: value.user!.providerData.single.photoURL,
            providerId: value.user!.providerData.single.providerId,
            providerUid: value.user!.providerData.single.uid,
          );

          if (_res!.status != null) {
            if (_res.status == true) {
              onAuthFinish();
              Get.offAllNamed(BaseHomeScreen.tag, arguments: BaseHomeScreen());
            } else {
              onAuthFinish();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_res.message.toString()}')));
            }
          } else {
            onAuthFinish();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR'))));
          }
        }
        /// USER REGISTER SOCMED
        else {
          bool? _isValid = await _service.validateEmailPhone(value: value.user!.providerData.single.email!);

          if (_isValid == false) {
            var _res = await _service.registerSocmed(
              email: value.user!.providerData.single.email,
              fullName: value.user!.providerData.single.displayName,
              phone: value.user!.providerData.single.phoneNumber,
              avatar: value.user!.providerData.single.photoURL,
              providerId: value.user!.providerData.single.providerId,
              providerUid: value.user!.providerData.single.uid,
            );

            if (_res!.status == true) {
              onAuthFinish();
              Get.offAndToNamed(LoginScreen.tag, arguments: LoginScreen(
                providerId: value.user!.providerData.single.providerId,
                isRegister: true,)
              );
            } else {
              onAuthFinish();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR'))));
            }
          } else {
            onAuthFinish();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_EMAIL_ERROR'))));
          }
        }
      }
    });
    onAuthFinish();
  }
  
  onAuthStart();
  
  onAuthFinish();
}
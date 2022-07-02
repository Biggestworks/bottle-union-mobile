import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/screen/auth/login_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

abstract class SocmedAuthInterface {
  AuthService _service = new AuthService();

  bool isTacAccepted = false;

  Future fnAuthGoogle(BuildContext context, {bool isLogin = false}) async {
    if (isLogin) {
      onAuthStart();
      await _service.authGoogle().then((value) async {
        if (value != null) {
          var _data = value.user?.providerData.firstWhere((i) => i.providerId == 'google.com', orElse: null);
          var _res = await _service.loginSocmed(
            email: _data?.email,
            fullName: _data?.displayName,
            phone: _data?.phoneNumber,
            avatar: _data?.photoURL,
            providerId: _data?.providerId,
            providerUid: _data?.uid,
          );

          if (_res?.status != null) {
            if (_res?.status == true) {
              onAuthFinish();
              Get.offAllNamed(BaseHomeScreen.tag, arguments: BaseHomeScreen());
            } else {
              onAuthFinish();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_res?.message.toString()}')));
            }
          } else {
            onAuthFinish();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR'))));
          }
        } else {
          onAuthFinish();
        }
      });
      onAuthFinish();
    } else {
      isTacAccepted = false;
      await CustomWidget.showTacDialog(context, fnOnCheckTac: (value) async {
        isTacAccepted = value;
        if (value) {
          Get.back();
          onAuthStart();
          await _service.authGoogle().then((value) async {
            if (value != null) {
              var _data = value.user?.providerData.firstWhere((i) => i.providerId == 'google.com', orElse: null);
              bool? _isValid = await _service.validateEmailPhone(value: _data?.email!);

              if (_isValid == false) {
                var _res = await _service.registerSocmed(
                  email: _data?.email,
                  fullName: _data?.displayName,
                  phone: _data?.phoneNumber,
                  avatar: _data?.photoURL,
                  providerId: _data?.providerId,
                  providerUid: _data?.uid,
                );

                if (_res?.status == true) {
                  onAuthFinish();
                  Get.offAndToNamed(LoginScreen.tag, arguments: LoginScreen(
                    providerId: _data?.providerId,
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
            } else {
              onAuthFinish();
            }
          });
          onAuthFinish();
        }
      });
    }
  }

  Future fnAuthFacebook(BuildContext context, {bool isLogin = false}) async {
    if (isLogin) {
      onAuthStart();
      await _service.authFacebook().then((value) async {
        if (value != null) {
          var _data = value.user?.providerData.firstWhere((i) => i.providerId == 'facebook.com', orElse: null);
          var _res = await _service.loginSocmed(
            email: _data?.email,
            fullName: _data?.displayName,
            phone: _data?.phoneNumber,
            avatar: _data?.photoURL,
            providerId: _data?.providerId,
            providerUid: _data?.uid,
          );

          if (_res?.status != null) {
            if (_res?.status == true) {
              onAuthFinish();
              Get.offAllNamed(BaseHomeScreen.tag, arguments: BaseHomeScreen());
            } else {
              onAuthFinish();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_res?.message.toString()}')));
            }
          } else {
            onAuthFinish();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR'))));
          }
        } else {
          onAuthFinish();
        }
      });
      onAuthFinish();
    } else {
      isTacAccepted = false;
      await CustomWidget.showTacDialog(context, fnOnCheckTac: (value) async {
        isTacAccepted = value;
        if (value) {
          Get.back();
          onAuthStart();
          await _service.authFacebook().then((value) async {
            if (value != null) {
              var _data = value.user?.providerData.firstWhere((i) => i.providerId == 'facebook.com', orElse: null);
              bool? _isValid = await _service.validateEmailPhone(value: _data?.email!);

              if (_isValid == false) {
                var _res = await _service.registerSocmed(
                  email: _data?.email,
                  fullName: _data?.displayName,
                  phone: _data?.phoneNumber,
                  avatar: _data?.photoURL,
                  providerId: _data?.providerId,
                  providerUid: _data?.uid,
                );

                if (_res?.status == true) {
                  onAuthFinish();
                  Get.offAndToNamed(LoginScreen.tag, arguments: LoginScreen(
                    providerId: _data?.providerId,
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
            } else {
              onAuthFinish();
            }
          });
          onAuthFinish();
        }
      });
    }
  }

  Future fnAuthApple(BuildContext context, {bool isLogin = false}) async {
    if (isLogin) {
      onAuthStart();
      await _service.authApple().then((value) async {
        if (value != null) {
          var _data = value.user?.providerData.firstWhere((i) => i.providerId == 'apple.com', orElse: null);
          var _res = await _service.loginSocmed(
            email: _data?.email,
            fullName: _data?.displayName ?? _data?.email,
            phone: _data?.phoneNumber,
            avatar: _data?.photoURL,
            providerId: _data?.providerId,
            providerUid: _data?.uid,
          );

          if (_res?.status != null) {
            if (_res?.status == true) {
              onAuthFinish();
              Get.offAllNamed(BaseHomeScreen.tag, arguments: BaseHomeScreen());
            } else {
              onAuthFinish();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_res?.message.toString()}')));
            }
          } else {
            onAuthFinish();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR'))));
          }
        } else {
          onAuthFinish();
        }
      });
      onAuthFinish();
    } else {
      isTacAccepted = false;
      await CustomWidget.showTacDialog(context, fnOnCheckTac: (value) async {
        isTacAccepted = value;
        if (value) {
          Get.back();
          onAuthStart();
          await _service.authApple().then((value) async {
            if (value != null) {
              var _data = value.user?.providerData.firstWhere((i) => i.providerId == 'apple.com', orElse: null);
              bool? _isValid = await _service.validateEmailPhone(value: _data?.email!);

              if (_isValid == false) {
                var _res = await _service.registerSocmed(
                  email: _data?.email,
                  fullName: _data?.displayName ?? _data?.email,
                  phone: _data?.phoneNumber,
                  avatar: _data?.photoURL,
                  providerId: _data?.providerId,
                  providerUid: _data?.uid,
                );

                if (_res?.status == true) {
                  onAuthFinish();
                  Get.offAndToNamed(LoginScreen.tag, arguments: LoginScreen(
                    providerId: _data?.providerId,
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
            } else {
              onAuthFinish();
            }
          });
          onAuthFinish();
        }
      });
    }
  }
  
  onAuthStart();
  
  onAuthFinish();
}
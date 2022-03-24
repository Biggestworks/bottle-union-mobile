import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/register_step_interface.dart';
import 'package:eight_barrels/abstract/socmed_auth_interface.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/screen/auth/login_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class LoginProvider extends ChangeNotifier
    with RegisterStepInterface, TextValidation, SocmedAuthInterface {
  AuthService _service = new AuthService();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final fKeyLogin = new GlobalKey<FormState>();

  bool isHidePass = true;

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnKeyboardUnFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnPassVisible(BuildContext context) {
    fnKeyboardUnFocus(context);
    isHidePass = !isHidePass;
    notifyListeners();
  }

  Future fnLogin({required BuildContext context}) async {
    fnKeyboardUnFocus(context);
    if (fKeyLogin.currentState!.validate()) {
      _view!.onProgressStart();

      final _res = await _service.login(
        username: usernameController.text,
        password: passwordController.text,
      );

      if (_res!.status != null) {
        if (_res.status == true) {
          _view!.onProgressFinish();
          Get.offAllNamed(BaseHomeScreen.tag, arguments: BaseHomeScreen());
        } else {
          _view!.onProgressFinish();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_res.message.toString()}')));
        }
      } else {
        _view!.onProgressFinish();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR'))));
      }
      _view!.onProgressFinish();
    }
  }

  @override
  onAuthFinish() {
    _view!.onProgressStart();
    notifyListeners();
  }

  @override
  onAuthStart() {
    _view!.onProgressFinish();
    notifyListeners();
  }

}
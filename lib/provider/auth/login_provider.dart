import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/register_step_interface.dart';
import 'package:eight_barrels/abstract/socmed_auth_interface.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/screen/auth/login_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
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
  bool? isRegister = false;
  String? providerId;

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

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as LoginScreen;
    isRegister = _args.isRegister ?? false;
    providerId = _args.providerId;
    notifyListeners();
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
          UserPreferences _userPreferences = new UserPreferences();
          await _userPreferences.saveGuestStatus('false');
          Get.offAllNamed(BaseHomeScreen.tag, arguments: BaseHomeScreen());
        } else {
          _view!.onProgressFinish();
          await CustomWidget.showSnackBar(
              context: context,
              content: Text(
                  '${_res.message != null ? _res.message.toString() : ''}'));
        }
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(
            context: context,
            content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
      }
      _view!.onProgressFinish();
    }
  }

  @override
  onAuthFinish() {
    _view!.onProgressFinish();
    notifyListeners();
  }

  @override
  onAuthStart() {
    _view!.onProgressStart();
    notifyListeners();
  }
}

import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/screen/home/home_screen.dart';
import 'package:eight_barrels/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class LoginProvider extends ChangeNotifier {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isHidePassword = true;
  AuthService _service = new AuthService();
  UserPreferences _userPreferences = new UserPreferences();
  LoadingView? _view;

  fnGetView(LoadingView view) {
    this._view = view;
  }

  Future fnLogin({required BuildContext context}) async {
    if (formKey.currentState!.validate()) {
      _view!.onProgressStart();
      
      final response = await _service.login(
        username: usernameController.text,
        password: passwordController.text,
      );

      if (response != null) {
        if (response.status == true) {
          await Get.offAllNamed(HomeScreen.tag);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.message}')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something wrong')));
      }
      _view!.onProgressFinish();
    }
  }

}
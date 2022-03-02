import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/profile/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ChangePasswordProvider extends ChangeNotifier {
  ProfileService _service = new ProfileService();
  final formKey = new GlobalKey<FormState>();
  TextEditingController oldPassController = new TextEditingController();
  TextEditingController newPassController = new TextEditingController();
  TextEditingController confirmPassController = new TextEditingController();

  bool isHidePassOld = true;
  bool isHidePassNew = true;
  bool isHidePassConfirm = true;

  LoadingView? _view;

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnToggleVisibleOld(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    isHidePassOld = !isHidePassOld;
    notifyListeners();
  }

  fnToggleVisibleNew(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    isHidePassNew = !isHidePassNew;
    notifyListeners();
  }

  fnToggleVisibleConfirm(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    isHidePassConfirm = !isHidePassConfirm;
    notifyListeners();
  }

  Future fnChangePassword(BuildContext context) async {
    _view!.onProgressStart();

    var _res = await _service.changePassword(
      oldPass: oldPassController.text,
      newPass: newPassController.text,
      confirmPass: confirmPassController.text,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        _view!.onProgressFinish();
        Get.back(result: true);
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message!));
      }
    } else {
      _view!.onProgressFinish();
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
    notifyListeners();
  }

}
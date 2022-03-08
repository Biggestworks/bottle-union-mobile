import 'dart:async';

import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/screen/auth/forgot_password_screen.dart';
import 'package:eight_barrels/screen/profile/change_password_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/auth/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpProvider extends ChangeNotifier {
  ValidationService _service = new ValidationService();
  TextEditingController emailController = new TextEditingController();
  TextEditingController codeController = new TextEditingController();
  AnimationController? animationController;
  Animation<Offset>? offsetAnimation;

  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();

  int stepIndex = 0;

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final fKeyEmail = new GlobalKey<FormState>();
  final fKeyOtp = new GlobalKey<FormState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  Future closeStream() => errorController.close();

  Future _fnSendOtp(BuildContext context) async {
    _view!.onProgressStart();
    var _res = await _service.sendOtp(
      email: emailController.text,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        _view!.onProgressFinish();
        animationController!.forward();
        animationController!.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            animationController!.reverse();
          }
        });
        await Future.delayed(Duration(milliseconds: 500)).then((value) async {
          stepIndex++;
        });
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message!));
      }
    } else {
      _view!.onProgressFinish();
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
  }

  Future _fnValidateOtp(BuildContext context) async {
    _view!.onProgressStart();
    var _res = await _service.validateOtp(
      code: codeController.text,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        _view!.onProgressFinish();
        Get.offAndToNamed(ChangePasswordScreen.tag, arguments: ChangePasswordScreen(
          token: _res.token,
        ));
      } else {
        _view!.onProgressFinish();
        errorController.add(ErrorAnimationType.shake);
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message!));
      }
    } else {
      _view!.onProgressFinish();
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
  }

  Future fnResendOtp(BuildContext context) async {
    _view!.onProgressStart();
    var _res = await _service.sendOtp(
      email: emailController.text,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_RESEND_OTP_INFO')));
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message!));
      }
    } else {
      _view!.onProgressFinish();
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
  }

  void fnInitAnimation(TickerProvider vsync) {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: vsync,
    );
    offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController!,
      curve: Curves.easeInOut,
    ));
    notifyListeners();
  }

  Future fnOnForwardTransition(BuildContext context) async {
    if (stepIndex == 0) {
      if (fKeyEmail.currentState!.validate()) {
        fKeyEmail.currentState!.save();
        await _fnSendOtp(context);
      }
    } else {
      if (fKeyOtp.currentState!.validate()) {
        fKeyOtp.currentState!.save();
        await _fnValidateOtp(context);
      } else {
        errorController.add(ErrorAnimationType.shake);
      }
    }
    notifyListeners();
  }

}
import 'dart:async';

import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/auth/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  ValidationService _service = new ValidationService();
  TextEditingController emailController = new TextEditingController();
  TextEditingController codeController = new TextEditingController();
  AnimationController? animationController;
  Animation<Offset>? offsetAnimation;

  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();


  int stepIndex = 0;

  LoadingView? _view;

  final formKey = new GlobalKey<FormState>();

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
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        await fnSendOtp(context);
      }
    } else {

    }
    notifyListeners();
  }

  Future fnSendOtp(BuildContext context) async {
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
        await CustomWidget.showSnackBar(context: context, content: Text(_res.errors != null ? _res.errors.toString() : _res.message!));
      }
    } else {
      _view!.onProgressFinish();
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
  }

  Future fnValidateOtp(BuildContext context) async {
    _view!.onProgressStart();
    var _res = await _service.validateOtp(
      code: emailController.text,
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


}
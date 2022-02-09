import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

abstract class RegisterStepVerification {
  AnimationController? animationController;
  Animation<Offset>? offsetAnimation;

  int stepIndex = 0;

  final fKeyPersonal = new GlobalKey<FormState>();
  final fKeyAddress = new GlobalKey<FormState>();
  final fKeyPassword = new GlobalKey<FormState>();

  AuthService _service = new AuthService();
  bool? isAgeValid;
  bool? isEmailValid;
  String? errEmail;

  Future validateAge(BuildContext context, String dob) async {
    isAgeValid = await _service.validateAge(dob: dob);
    if (isAgeValid == false) {
      CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_AGE_ERROR')));
    }
  }

  Future<bool?> validateEmail(BuildContext context, String value) async => await _service.validateEmailPhone(value: value);

  void initAnimation(TickerProvider vsync) {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: vsync,
    );
    offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController!,
      curve: Curves.easeInOut,
    ));
  }

  Future onBackTransition(BuildContext context) async {
    if (stepIndex == 0) {
      await Get.offNamedUntil(StartScreen.tag, (route) => false);
    } else if (stepIndex >= 1) {
      animationController!.forward();
      animationController!.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController!.reverse();
        }
      });
      await Future.delayed(Duration(milliseconds: 550)).then((value) {
        stepIndex--;
      });
    }
  }

  Future onForwardTransition(BuildContext context, Future<void> function()) async {
    if (stepIndex == 0) {
      if (fKeyPersonal.currentState!.validate() && isAgeValid == true) {
        animationController!.forward();
        animationController!.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            animationController!.reverse();
          }
        });
        await Future.delayed(Duration(milliseconds: 550)).then((value) async {
          stepIndex++;
        });
      }
    } else if (stepIndex == 1) {
      if (fKeyAddress.currentState!.validate()) {
        animationController!.forward();
        animationController!.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            animationController!.reverse();
          }
        });
        await Future.delayed(Duration(milliseconds: 550)).then((value) {
          stepIndex++;
        });
      }
    } else if (stepIndex == 2) {
      if (fKeyPassword.currentState!.validate()) {
        await function();
      }
    }
  }

}
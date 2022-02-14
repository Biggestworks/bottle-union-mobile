import 'dart:io';

import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/provider/auth/auth_provider.dart';
import 'package:eight_barrels/screen/auth/login_screen.dart';
import 'package:eight_barrels/screen/auth/register_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class StartScreen extends StatefulWidget {
  static String tag = '/start-screen';
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> implements LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<AuthProvider>(context, listen: false).fnGetView(this);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<AuthProvider>(context, listen: false);

    Widget _mainContent = Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/ic_logo_bu_white.png', scale: 1.5,),
          SizedBox(height: 20,),
          Text(AppLocalizations.instance.text('TXT_MSG_START'), style: TextStyle(
            color: Colors.white,
          ), textAlign: TextAlign.center,),
        ],
      ),
    );

    void showRegisterSheet() {
      return CustomWidget.showSheet(
        context: context,
        isScroll: true,
        isRounded: true,
        child: Container(
          height: 350,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                AppLocalizations.instance.text('TXT_REGISTER_WITH'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: CustomWidget.roundOutlinedBtn(
                  label: 'Bottle Union Account',
                  btnColor: CustomColor.MAIN,
                  lblColor: CustomColor.MAIN,
                  function: () => Get.toNamed(RegisterScreen.tag),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: CustomWidget.roundIconBtn(
                  icon: MdiIcons.google,
                  label: 'Google',
                  btnColor: Colors.red,
                  lblColor: Colors.white,
                  function: () async {
                    Get.back();
                    await _provider.fnAuthGoogle(context);
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: CustomWidget.roundIconBtn(
                  icon: MdiIcons.facebook,
                  label: 'Facebook',
                  btnColor: Colors.blue,
                  lblColor: Colors.white,
                  function: () async {
                    Get.back();
                    await _provider.fnAuthFacebook(context);
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (Platform.isIOS) SignInWithAppleButton(
                height: 40,
                onPressed: () async {
                  Get.back();
                  // await provider.signInApple(context);
                },
                borderRadius: BorderRadius.circular(20),
              ),
            ],
          ),
        ),
      );
    }

    Widget authBtns = Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomWidget.roundOutlinedBtn(
              label: AppLocalizations.instance.text('TXT_SIGN_IN'),
              btnColor: CustomColor.SECONDARY,
              lblColor: CustomColor.SECONDARY,
              isBold: true,
              function: () => Get.toNamed(LoginScreen.tag, arguments: LoginScreen()),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: CustomWidget.roundBtn(
              label: AppLocalizations.instance.text('TXT_BTN_START'),
              btnColor: CustomColor.SECONDARY,
              lblColor: CustomColor.MAIN,
              isBold: true,
              function: () => showRegisterSheet(),
            ),
          ),
        ],
      ),
    );

    return ModalProgressHUD(
      inAsyncCall: _isLoad,
      progressIndicator: SpinKitFadingCube(color: CustomColor.MAIN,),
      child: Scaffold(
        backgroundColor: CustomColor.MAIN,
        body: _mainContent,
        floatingActionButton: authBtns,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  @override
  void onProgressFinish() {
    if (mounted) {
      _isLoad = false;
      setState(() {});
    }
  }

  @override
  void onProgressStart() {
    if (mounted) {
      _isLoad = true;
      setState(() {});
    }
  }

}

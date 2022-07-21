import 'dart:io';

import 'package:eight_barrels/abstract/socmed_auth_interface.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/push_notification_manager.dart';
import 'package:eight_barrels/screen/auth/login_screen.dart';
import 'package:eight_barrels/screen/auth/register_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class StartScreen extends StatefulWidget {
  static String tag = '/start-screen';
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SocmedAuthInterface {
  bool _isLoad = false;
  PushNotificationManager _pushNotificationManager = new PushNotificationManager();

  @override
  void initState() {
    Future.delayed(Duration.zero,
            () async => await _pushNotificationManager.saveFcmToken());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget _mainContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset('assets/images/ic_21_plus.png', scale: 2.2,),
              ),
            ),
            Hero(
              tag: 'logo',
              child: SizedBox(
                height: 80,
                child: Image.asset('assets/images/ic_logo_bu_white.png'),
              ),
            ),
            SizedBox(height: 20,),
            Text(AppLocalizations.instance.text('TXT_MSG_START'), style: TextStyle(
              color: Colors.white,
            ), textAlign: TextAlign.center,),
          ],
        ),
      ),
    );

    _showRegisterSheet() {
      return CustomWidget.showSheet(
        context: context,
        isScroll: true,
        isRounded: true,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: SingleChildScrollView(
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
                    label: 'Guest Account',
                    btnColor: Colors.blue,
                    lblColor: Colors.blue,
                    fontSize: 16,
                    function: () async {
                      Get.back();
                      await fnGuestAccount();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    AppLocalizations.instance.text('TXT_OR'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: CustomWidget.roundOutlinedBtn(
                    label: 'Bottle Union Account',
                    btnColor: CustomColor.MAIN,
                    lblColor: CustomColor.MAIN,
                    fontSize: 16,
                    function: () {
                      Get.back();
                      Get.toNamed(RegisterScreen.tag);
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
                    icon: MdiIcons.google,
                    label: 'Google',
                    btnColor: Colors.red,
                    lblColor: Colors.white,
                    fontSize: 16,
                    function: () async {
                      Get.back();
                      await fnAuthGoogle(context);
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
                    fontSize: 16,
                    function: () async {
                      Get.back();
                      await fnAuthFacebook(context);
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
                    await fnAuthApple(context);
                  },
                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _authBtns = SafeArea(
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomWidget.roundOutlinedBtn(
              label: AppLocalizations.instance.text('TXT_SIGN_IN'),
              btnColor: CustomColor.SECONDARY,
              lblColor: CustomColor.SECONDARY,
              isBold: true,
              fontSize: 16,
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
              fontSize: 16,
              function: () => _showRegisterSheet(),
            ),
          ),
        ],
      ),
    ),
    );

    return CustomWidget.loadingHud(
      isLoad: _isLoad,
      child: Scaffold(
        backgroundColor: CustomColor.MAIN,
        body: _mainContent,
        floatingActionButton: _authBtns,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  @override
  onAuthFinish() {
    if (mounted) {
      _isLoad = false;
      setState(() {});
    }
  }

  @override
  onAuthStart() {
    if (mounted) {
      _isLoad = true;
      setState(() {});
    }
  }

}

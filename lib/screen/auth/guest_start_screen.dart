import 'dart:io';

import 'package:eight_barrels/abstract/socmed_auth_interface.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/push_notification_manager.dart';
import 'package:eight_barrels/screen/auth/register_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

class GuestStartScreen extends StatefulWidget {
  static String tag = '/guest-start-screen';
  const GuestStartScreen({Key? key}) : super(key: key);

  @override
  _GuestStartScreenState createState() => _GuestStartScreenState();
}

class _GuestStartScreenState extends State<GuestStartScreen>
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
                child: Image.asset('assets/images/ic_21_plus.png', scale: 2.2, color: Colors.black,),
              ),
            ),
            Hero(
              tag: 'logo',
              child: SizedBox(
                height: 80,
                child: Image.asset('assets/images/ic_logo_bu.png'),
              ),
            ),
            SizedBox(height: 20,),
            Text(AppLocalizations.instance.text('TXT_GUEST_ACCOUNT_MSG'), style: TextStyle(
              color: Colors.black,
            ), textAlign: TextAlign.center,),
            SizedBox(height: 20,),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: CustomWidget.roundBtn(
                    label: 'Bottle Union Account',
                    btnColor: CustomColor.MAIN,
                    lblColor: Colors.white,
                    fontSize: 16,
                    function: () => Get.toNamed(RegisterScreen.tag),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(AppLocalizations.instance.text('TXT_VIA_SOCMED'), style: TextStyle(
                      color: Colors.black,
                    ),),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomWidget.circleIconBtn(
                      icon: FontAwesomeIcons.facebookF,
                      btnColor: Colors.blue,
                      icColor: Colors.white,
                      function: () async => await fnAuthFacebook(context, isLogin: true),
                    ),
                    CustomWidget.circleIconBtn(
                      icon: FontAwesomeIcons.google,
                      btnColor: Colors.red,
                      icColor: Colors.white,
                      function: () async => await fnAuthGoogle(context, isLogin: true),
                    ),
                    if (Platform.isIOS)
                      CustomWidget.circleIconBtn(
                        icon: FontAwesomeIcons.apple,
                        btnColor: Colors.black,
                        icColor: Colors.white,
                        function: () async => await fnAuthApple(context, isLogin: true),
                      ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );

    return CustomWidget.loadingHud(
      isLoad: _isLoad,
      child: Scaffold(
        backgroundColor: CustomColor.BG,
        body: _mainContent,
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

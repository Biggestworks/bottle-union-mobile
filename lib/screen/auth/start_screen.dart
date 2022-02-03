import 'package:eight_barrels/helper/app-localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/screen/auth/login_screen.dart';
import 'package:eight_barrels/screen/auth/register_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class StartScreen extends StatelessWidget {
  static String tag = '/start-screen';
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget mainContent = Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/ic_logo_full_white.png', scale: 1.5,),
          SizedBox(height: 10,),
          Text(AppLocalizations.instance.text('TXT_MSG_START'), style: TextStyle(
            color: Colors.white,
          ), textAlign: TextAlign.center,),
        ],
      ),
    );

    void showRegisterSheet() {
      return CustomWidget.showSheet(
        context: context,
        scroll: true,
        child: Container(
          height: 350,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Masuk dengan',
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
                  function: () => print(''),
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
                  function: () => print(''),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // if (Platform.isIOS) SignInWithAppleButton(
              //   onPressed: () async {
              //     Navigator.of(context).pop();
              //     await provider.signInApple(context);
              //   },
              //   borderRadius: BorderRadius.circular(20),
              // ),
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
                function: () => Get.toNamed(LoginScreen.tag)
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

    return Scaffold(
      backgroundColor: CustomColor.MAIN,
      body: mainContent,
      floatingActionButton: authBtns,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

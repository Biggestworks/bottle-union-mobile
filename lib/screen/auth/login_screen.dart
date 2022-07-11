import 'dart:io';

import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/provider/auth/login_provider.dart';
import 'package:eight_barrels/screen/auth/otp_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/login-screen';

  final String? providerId;
  final bool? isRegister;
  const LoginScreen({Key? key, this.providerId, this.isRegister}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TextValidation, LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<LoginProvider>(context, listen: false).fnGetView(this);
      Provider.of<LoginProvider>(context, listen: false).fnGetArguments(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<LoginProvider>(context, listen: false);

    Widget _mainContent = Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<LoginProvider>(
                child: SizedBox(),
                builder: (context, provider, skeleton) {
                  switch (provider.isRegister) {
                    case true:
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                elevation: 0,
                                color: CustomColor.SECONDARY,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // shape: StadiumBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Icon(FontAwesomeIcons.circleInfo, color: CustomColor.BROWN_TXT,),
                                      SizedBox(width: 10,),
                                      Flexible(
                                        child: Text(AppLocalizations.instance.text('TXT_VERIFY_INFO'), style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ), textAlign: TextAlign.left,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                        ],
                      );
                    default:
                      return skeleton!;
                  }
                },
              ),
              Text(AppLocalizations.instance.text('TXT_SIGN_IN'), style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),),
              SizedBox(height: 10,),
              Card(
                color: Colors.white38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _provider.fKeyLogin,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.instance.text('TXT_LBL_UNAME'), style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),),
                        TextFormField(
                          controller: _provider.usernameController,
                          textInputAction: TextInputAction.next,
                          validator: validateField,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            isDense: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: CustomColor.MAIN),
                            ),
                            errorStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(AppLocalizations.instance.text('TXT_LBL_PASS'), style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),),
                        TextFormField(
                          controller: _provider.passwordController,
                          textInputAction: TextInputAction.next,
                          validator: validateField,
                          obscureText: _provider.isHidePass,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            isDense: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: CustomColor.MAIN),
                            ),
                            errorStyle: TextStyle(
                              color: Colors.white,
                            ),
                            suffixIcon: GestureDetector(
                              child: Icon(
                                _provider.isHidePass
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                                size: 24,
                              ),
                              onTap: () => _provider.fnPassVisible(context),
                            ),
                          ),
                          onFieldSubmitted: (_) async => await _provider.fnLogin(context: _provider.scaffoldKey.currentContext!),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => Get.toNamed(OtpScreen.tag),
                    child: Text(AppLocalizations.instance.text('TXT_FORGOT_PASSWORD'), style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget _mainContentSocmed = Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.instance.text('TXT_SIGN_IN'), style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),),
              SizedBox(height: 10,),
              Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 0,
                        color: CustomColor.SECONDARY,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // shape: StadiumBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.circleInfo, color: CustomColor.BROWN_TXT,),
                              SizedBox(width: 10,),
                              Flexible(
                                child: Text(AppLocalizations.instance.text('TXT_VERIFY_INFO'), style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ), textAlign: TextAlign.left,),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
              // Card(
              //   color: Colors.white38,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: Form(
              //     key: _provider.fKeyLogin,
              //     child: Padding(
              //       padding: const EdgeInsets.all(15),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(AppLocalizations.instance.text('TXT_LBL_EMAIL'), style: TextStyle(
              //             fontSize: 16,
              //             color: Colors.white,
              //           ),),
              //           TextFormField(
              //             controller: _provider.usernameController,
              //             textInputAction: TextInputAction.next,
              //             validator: validateField,
              //             style: TextStyle(
              //               color: Colors.white,
              //             ),
              //             decoration: InputDecoration(
              //               contentPadding: EdgeInsets.symmetric(vertical: 15),
              //               isDense: true,
              //               enabledBorder: UnderlineInputBorder(
              //                 borderSide: BorderSide(color: Colors.white),
              //               ),
              //               focusedBorder: UnderlineInputBorder(
              //                 borderSide: BorderSide(color: CustomColor.MAIN),
              //               ),
              //               errorStyle: TextStyle(
              //                 color: Colors.white,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );

    Widget _socmedBtns = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 5,),
        Align(
          alignment: Alignment.center,
          child: Text(AppLocalizations.instance.text('TXT_VIA_SOCMED'), style: TextStyle(
            color: Colors.white,
          ),),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomWidget.circleIconBtn(
              icon: FontAwesomeIcons.facebookF,
              btnColor: Colors.blue,
              icColor: Colors.white,
              function: () async => await _provider.fnAuthFacebook(_provider.scaffoldKey.currentContext!, isLogin: true),
            ),
            CustomWidget.circleIconBtn(
              icon: FontAwesomeIcons.google,
              btnColor: Colors.red,
              icColor: Colors.white,
              function: () async => await _provider.fnAuthGoogle(_provider.scaffoldKey.currentContext!, isLogin: true),
            ),
            if (Platform.isIOS)
              CustomWidget.circleIconBtn(
                icon: FontAwesomeIcons.apple,
                btnColor: Colors.white,
                icColor: Colors.black,
                function: () async => await _provider.fnAuthApple(_provider.scaffoldKey.currentContext!, isLogin: true),
              ),
          ],
        ),
      ],
    );

    Widget _submitBtn = SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Consumer<LoginProvider>(
          builder: (context, provider, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: CustomWidget.roundBtn(
                    label: provider.providerId != null
                        ?  provider.providerId!.contains('google.com')
                        ? AppLocalizations.instance.text('TXT_SIGN_GOOGLE')
                        : provider.providerId!.contains('facebook.com')
                        ? AppLocalizations.instance.text('TXT_SIGN_FACEBOOK')
                        : provider.providerId!.contains('apple.com')
                        ? AppLocalizations.instance.text('TXT_SIGN_APPLE')
                        : AppLocalizations.instance.text('TXT_SIGN_IN')
                        : AppLocalizations.instance.text('TXT_SIGN_IN'),
                    btnColor: CustomColor.SECONDARY,
                    lblColor: CustomColor.MAIN,
                    isBold: true,
                    fontSize: 16,
                    function: () async {
                      if (provider.providerId != null) {
                        if (provider.providerId!.contains('google.com')) {
                          await _provider.fnAuthGoogle(_provider.scaffoldKey.currentContext!, isLogin: true);
                        } else if (provider.providerId!.contains('facebook.com')) {
                          await _provider.fnAuthFacebook(_provider.scaffoldKey.currentContext!, isLogin: true);
                        } else if (provider.providerId!.contains('apple.com')) {
                          await _provider.fnAuthApple(_provider.scaffoldKey.currentContext!, isLogin: true);
                        }
                      } else {
                        await _provider.fnLogin(context: _provider.scaffoldKey.currentContext!);
                      }
                    },
                  ),
                ),
                if (provider.providerId == null) _socmedBtns
              ],
            );
          }
        ),
      ),
    );

    return CustomWidget.loadingHud(
      isLoad: _isLoad,
      child: GestureDetector(
        onTap: () => _provider.fnKeyboardUnFocus(context),
        child: Scaffold(
          key: _provider.scaffoldKey,
          backgroundColor: CustomColor.MAIN,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: CustomColor.MAIN,
            elevation: 0,
            title: null,
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SizedBox(
                  width: 150,
                  child: Image.asset('assets/images/ic_logo_bu_white.png',),
                ),
              ),
            ],
          ),
          body: _mainContent,
          bottomNavigationBar: _submitBtn,
        ),
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

import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app-localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/provider/auth/login_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/login-screen';

  final bool? isRegister;
  const LoginScreen({Key? key, this.isRegister}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TextValidation implements LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((value) async {
      Provider.of<LoginProvider>(context, listen: false).fnGetView(this);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<LoginProvider>(context, listen: false);

    Widget _mainContent = Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isRegister == true)
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
                                Icon(FontAwesomeIcons.infoCircle, color: CustomColor.BROWN_TXT,),
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
                  key: _provider.formKey,
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
                          obscureText: _provider.isHidePassword,
                          style: TextStyle(
                            color: Colors.white,
                          ),
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
                                _provider.isHidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                                size: 24,
                              ),
                              onTap: () => _provider.fnToggleVisibility(context),
                            ),
                          ),
                          onFieldSubmitted: (_) async => await _provider.fnLogin(context: context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget _submitBtn = Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: CustomWidget.roundBtn(
              label: AppLocalizations.instance.text('TXT_SIGN_IN'),
              btnColor: CustomColor.SECONDARY,
              lblColor: CustomColor.MAIN,
              isBold: true,
              function: () async => await _provider.fnLogin(context: context),
            ),
          ),
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
                function: () => print(''),
              ),
              CustomWidget.circleIconBtn(
                icon: FontAwesomeIcons.google,
                btnColor: Colors.red,
                icColor: Colors.white,
                function: () => print(''),
              ),
            ],
          ),
        ],
      ),
    );

    return ModalProgressHUD(
      inAsyncCall: _isLoad,
      progressIndicator: SpinKitFadingCube(color: CustomColor.MAIN,),
      opacity: 0.5,
      child: Scaffold(
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
                width: 120,
                child: Image.asset('assets/images/ic_logo_text_white.png',),
              ),
            ),
          ],
        ),
        body: _mainContent,
        bottomNavigationBar: _submitBtn,
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

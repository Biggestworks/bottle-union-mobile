import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app-localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/provider/auth/login_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

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

    Widget mainContent = Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                        isDense: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: CustomColor.MAIN),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
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
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: CustomColor.MAIN),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.white,
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
    );

    Widget submitBtn = Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      child: CustomWidget.roundBtn(
        label: _isLoad ? 'Please Wait...' : AppLocalizations.instance.text('TXT_SIGN_IN'),
        btnColor: CustomColor.SECONDARY,
        lblColor: CustomColor.MAIN,
        isBold: true,
        function: () async => await _provider.fnLogin(context: context),
      ),
    );

    return Scaffold(
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
      body: mainContent,
      floatingActionButton: submitBtn,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

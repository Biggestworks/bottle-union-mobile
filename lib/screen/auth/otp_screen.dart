import 'dart:async';

import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/provider/auth/otp_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  static String tag = '/otp-screen';
  const OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> 
    with TextValidation, SingleTickerProviderStateMixin, LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<OtpProvider>(context, listen: false).fnInitAnimation(this);
      Provider.of<OtpProvider>(context, listen: false).fnGetView(this);
    });
    super.initState();
  }

  @override
  void dispose() {
    Future.delayed(Duration.zero, () {
      if (mounted) Provider.of<OtpProvider>(context, listen: false).closeStream();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<OtpProvider>(context, listen: false);

    Widget _emailForm = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Please enter the email that has been registered on your account. We will send you an OTP to your email.', style: TextStyle(
            color: Colors.white,
          ), textAlign: TextAlign.center,),
          SizedBox(height: 20,),
          Form(
            key: _provider.fKeyEmail,
            child: Card(
              color: Colors.white38,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.instance.text('TXT_LBL_EMAIL'), style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),),
                    TextFormField(
                      controller: _provider.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Widget _validationForm = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Please check your email for the OTP code.', style: TextStyle(
            color: Colors.white,
          ), textAlign: TextAlign.center,),
          SizedBox(height: 20,),
          Form(
            key: _provider.fKeyOtp,
            child: Card(
              color: Colors.white38,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.instance.text('TXT_OTP_CODE'), style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),),
                    SizedBox(height: 10,),
                    PinCodeTextField(
                      appContext: context,
                      controller: _provider.codeController,
                      validator: (value) => validateField(value!),
                      errorAnimationController: _provider.errorController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                      autoFocus: true,
                      cursorColor: Colors.white,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        activeColor: CustomColor.MAIN,
                        inactiveColor: Colors.white,
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      onCompleted: (v) {
                        print(v);
                      },
                      onChanged: (value) {
                        print(value);
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        return true;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Align(
            alignment: Alignment.centerRight,
            child: CustomWidget.roundIconBtn(
              icon: Icons.send,
              label: AppLocalizations.instance.text('TXT_RESEND_OTP'),
              btnColor: CustomColor.SECONDARY,
              lblColor: CustomColor.MAIN,
              icColor: CustomColor.MAIN,
              function: () async => await _provider.fnResendOtp(_provider.scaffoldKey.currentContext!),
            ),
          ),
        ],
      ),
    );

    Widget _submitBtn = SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        width: MediaQuery.of(context).size.width,
        child: Consumer<OtpProvider>(
          builder: (context, provider, _) {
            return CustomWidget.roundBtn(
              label: provider.stepIndex == 0
                  ? AppLocalizations.instance.text('TXT_SEND_OTP')
                  : AppLocalizations.instance.text('TXT_CONTINUE'),
              btnColor: CustomColor.SECONDARY,
              lblColor: CustomColor.MAIN,
              isBold: true,
              fontSize: 16,
              function: () async => await _provider.fnOnForwardTransition(provider.scaffoldKey.currentContext!),
            );
          }
        ),
      ),
    );

    return CustomWidget.loadingHud(
      isLoad: _isLoad,
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
        body: Consumer<OtpProvider>(
            child: Container(),
            builder: (context, provider, skeleton) {
              switch (provider.offsetAnimation) {
                case null:
                  return skeleton!;
                default:
                  return SlideTransition(
                    position: provider.offsetAnimation!,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: provider.stepIndex == 0
                          ? _emailForm
                          : _validationForm,
                    ),
                  );
              }
            }
        ),
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

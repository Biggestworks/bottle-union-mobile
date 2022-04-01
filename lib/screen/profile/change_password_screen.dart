import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/provider/profile/change_password_provider.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String tag = '/change-password-screen';
  final String? token;

  const ChangePasswordScreen({Key? key, this.token}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with TextValidation, LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<ChangePasswordProvider>(context, listen: false).fnGetView(this);
      Provider.of<ChangePasswordProvider>(context, listen: false).fnGetArguments(context);
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ChangePasswordProvider>(context, listen: false);

    Widget _mainContent = SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _provider.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(AppLocalizations.instance.text('TXT_CHANGE_PASSWORD_INFO'),
                style: TextStyle(
                  color: CustomColor.GREY_TXT,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Consumer<ChangePasswordProvider>(
                builder: (context, provider, _) {
                  switch (provider.token) {
                    case null:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.instance.text('TXT_OLD_PASSWORD'), style: TextStyle(
                            fontSize: 16,
                            color: CustomColor.GREY_TXT,
                          ),),
                          SizedBox(height: 5,),
                          TextFormField(
                            obscureText: _provider.isHidePassOld,
                            validator: validatePassword,
                            controller: _provider.oldPassController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: CustomColor.GREY_BG,),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: CustomColor.GREY_BG,),
                              ),
                              filled: true,
                              fillColor: CustomColor.GREY_BG,
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  _provider.isHidePassOld
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: CustomColor.MAIN,
                                  size: 24,
                                ),
                                onTap: () => _provider.fnToggleVisibleOld(context),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      );
                    default:
                      return SizedBox();
                  }
                }
              ),
              Text(AppLocalizations.instance.text('TXT_NEW_PASSWORD'), style: TextStyle(
                fontSize: 16,
                color: CustomColor.GREY_TXT,
              ),),
              SizedBox(height: 5,),
              TextFormField(
                obscureText: _provider.isHidePassNew,
                validator: validatePassword,
                controller: _provider.newPassController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: CustomColor.GREY_BG,),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: CustomColor.GREY_BG,),
                  ),
                  filled: true,
                  fillColor: CustomColor.GREY_BG,
                  suffixIcon: GestureDetector(
                    child: Icon(
                      _provider.isHidePassNew
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: CustomColor.MAIN,
                      size: 24,
                    ),
                    onTap: () => _provider.fnToggleVisibleNew(context),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(AppLocalizations.instance.text('TXT_CONFIRM_PASSWORD'), style: TextStyle(
                fontSize: 16,
                color: CustomColor.GREY_TXT,
              ),),
              SizedBox(height: 5,),
              TextFormField(
                obscureText: _provider.isHidePassConfirm,
                validator: validatePassword,
                controller: _provider.confirmPassController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: CustomColor.GREY_BG,),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: CustomColor.GREY_BG,),
                  ),
                  filled: true,
                  fillColor: CustomColor.GREY_BG,
                  suffixIcon: GestureDetector(
                    child: Icon(
                      _provider.isHidePassConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: CustomColor.MAIN,
                      size: 24,
                    ),
                    onTap: () => _provider.fnToggleVisibleConfirm(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget _submitBtn = SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        width: MediaQuery.of(context).size.width,
        child: CustomWidget.roundBtn(
          label: AppLocalizations.instance.text('TXT_SAVE'),
          btnColor: CustomColor.MAIN,
          lblColor: Colors.white,
          isBold: true,
          fontSize: 16,
          function: () async {
            if (_provider.token == null) {
              await _provider.fnChangePassword(_provider.scaffoldKey.currentContext!);
            } else {
              await _provider.fnResetPassword(_provider.scaffoldKey.currentContext!);
            }
          },
        ),
      ),
    );

    return CustomWidget.loadingHud(
      isLoad: _isLoad,
      child: Scaffold(
        key: _provider.scaffoldKey,
        appBar: AppBar(
          backgroundColor: CustomColor.MAIN,
          centerTitle: true,
          title: Text(AppLocalizations.instance.text('TXT_LBL_CHANGE_PASSWORD')),
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

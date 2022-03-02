import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/provider/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../widget/custom_widget.dart';

class RegisterScreen extends StatefulWidget {
  static String tag = '/register-screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TextValidation, SingleTickerProviderStateMixin implements LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<AuthProvider>(context, listen: false).fnInitAnimation(this);
      Provider.of<AuthProvider>(context, listen: false).fnGetView(this);
      Provider.of<AuthProvider>(context, listen: false).fnFetchRegionList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<AuthProvider>(context, listen: false);

    _showDobDialog() {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width * 0.95,
              height: 300,
              padding: EdgeInsets.all(10),
              child: SfDateRangePicker(
                onSelectionChanged: (value) {
                  Get.back();
                  _provider.fnOnSelectDate(value, context);
                },
              ),
            ),
          );
        },
      );
    }

    Widget _formPersonal = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: Colors.white38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Form(
              key: _provider.fKeyPersonal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.instance.text('TXT_LBL_NAME'), style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),),
                  TextFormField(
                    controller: _provider.nameController,
                    textInputAction: TextInputAction.next,
                    validator: validateField,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
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
                  Text('${AppLocalizations.instance.text('TXT_LBL_DOB')} *', style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),),
                  GestureDetector(
                    onTap: () => _showDobDialog(),
                    child: TextFormField(
                      enabled: false,
                      controller: _provider.dobController,
                      textInputAction: TextInputAction.next,
                      validator: validateField,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Consumer<AuthProvider>(
                                child: Container(),
                                builder: (context, provider, skeleton) {
                                  switch (provider.isAgeValid) {
                                    case true:
                                      return Icon(FontAwesomeIcons.solidCheckCircle, size: 24, color: Colors.greenAccent,);
                                    case false:
                                      return Icon(FontAwesomeIcons.exclamationCircle, size: 24, color: Colors.amberAccent,);
                                    default:
                                      return skeleton!;
                                  }
                                }
                              ),
                              SizedBox(width: 10,),
                              Icon(FontAwesomeIcons.calendarAlt, size: 24, color: Colors.white,),
                            ],
                          ),
                        ),
                        isDense: true,
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(AppLocalizations.instance.text('TXT_LBL_EMAIL'), style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),),
                  TextFormField(
                    controller: _provider.emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      String? valid = validateEmail(value);
                      if (valid == null) {
                        _provider.fnValidateEmail(context, value!);
                        return _provider.errEmail;
                      }
                      return valid;
                    },
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Consumer<AuthProvider>(
                                child: Container(),
                                builder: (context, provider, skeleton) {
                                  switch (provider.isEmailValid) {
                                    case false:
                                      return Icon(FontAwesomeIcons.solidCheckCircle, size: 24, color: Colors.greenAccent,);
                                    case true:
                                      return Icon(FontAwesomeIcons.exclamationCircle, size: 24, color: Colors.amberAccent,);
                                    default:
                                      return skeleton!;
                                  }
                                }
                            ),
                          ],
                        ),
                      ),
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
                  Text(AppLocalizations.instance.text('TXT_LBL_PHONE'), style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),),
                  TextFormField(
                    controller: _provider.phoneController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: validatePhoneNumber,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
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
                  Text(AppLocalizations.instance.text('TXT_LBL_GENDER'), style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),),
                  Consumer<AuthProvider>(
                      builder: (context, provider, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: provider.genderList[0],
                                  groupValue: provider.genderValue,
                                  onChanged: provider.fnOnChangeRadio,
                                  activeColor: Colors.white,
                                ),
                                Text(AppLocalizations.instance.text('TXT_LBL_MALE'), style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: provider.genderList[1],
                                  groupValue: provider.genderValue,
                                  onChanged: provider.fnOnChangeRadio,
                                  activeColor: Colors.white,
                                ),
                                Text(AppLocalizations.instance.text('TXT_LBL_FEMALE'), style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),),
                              ],
                            )
                          ],
                        );
                      }
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text('*${AppLocalizations.instance.text('TXT_AGE_INFO')}', style: TextStyle(
            color: Colors.white,
          ),),
        ),
      ],
    );

    Widget _formAddress = Form(
      key: _provider.fKeyAddress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.instance.text('TXT_REGISTER_ADDRESS'), style: TextStyle(
            color: Colors.white,
          ), textAlign: TextAlign.center,),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: () async => await _provider.fnShowPlacePicker(context),
            child: Card(
              color: Colors.white38,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.instance.text('TXT_LBL_ADDRESS'), style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),),
                    TextFormField(
                      enabled: false,
                      controller: _provider.addressController,
                      validator: validateField,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        suffixIcon: Icon(FontAwesomeIcons.mapMarkedAlt, size: 24, color: Colors.white,),
                        isDense: true,
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
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
          SizedBox(height: 20,),
          Consumer<AuthProvider>(
              child: Container(),
              builder: (context, provider, skeleton) {
                switch (provider.addressController.text) {
                  case '':
                    return skeleton!;
                  default:
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(AppLocalizations.instance.text('TXT_REGISTER_REGION'), style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),),
                        ),
                        SizedBox(height: 10,),
                        Card(
                          color: Colors.white38,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                errorStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              validator: validateField,
                              items: provider.regionList,
                              isExpanded: true,
                              value: provider.selectedRegion,
                              iconEnabledColor: Colors.white,
                              menuMaxHeight: 250,
                              onChanged: (value) => provider.fnOnSelectRegion(value!),
                              selectedItemBuilder: (BuildContext context) {
                                return provider.regionData.map<Widget>((item) {
                                  return Text(
                                      item.name!,
                                      style: TextStyle(color: Colors.white,)
                                  );
                                }).toList();
                              },
                              hint: Text('-- ${AppLocalizations.instance.text('TXT_REGISTER_REGION')} --', style: TextStyle(
                                color: Colors.white,
                              ),),
                            ),
                          ),
                        ),
                      ],
                    );
                }
              }
          ),
        ],
      ),
    );

    Widget _formPassword = Card(
      color: Colors.white38,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Form(
          key: _provider.fKeyPassword,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.instance.text('TXT_LBL_PASS'), style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),),
              TextFormField(
                controller: _provider.passController,
                textInputAction: TextInputAction.next,
                validator: validatePassword,
                obscureText: _provider.isHidePassRegis,
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
                      _provider.isHidePassRegis
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                      size: 24,
                    ),
                    onTap: () => _provider.fnPassVblRegis(context),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text(AppLocalizations.instance.text('TXT_LBL_PASS_CONFIRM'), style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),),
              TextFormField(
                controller: _provider.confirmPassController,
                textInputAction: TextInputAction.next,
                validator: (value) => validateConfirmPassword(_provider.passController.text, value),
                obscureText: _provider.isHidePassRegisConfirm,
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
                      _provider.isHidePassRegisConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                      size: 24,
                    ),
                    onTap: () => _provider.fnPassVblRegisConfirm(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget _mainContent = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(AppLocalizations.instance.text('TXT_SIGN_UP'), style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),),
          ),
          Consumer<AuthProvider>(
              builder: (context, provider, _) {
                return Flexible(
                  child: provider.stepProgressBar(context: context),
                );
              }
          ),
          Consumer<AuthProvider>(
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
                            ? _formPersonal
                            : provider.stepIndex == 1
                            ? _formAddress
                            : _formPassword,
                      ),
                    );
                }
              }
          )
        ],
      ),
    );

    Widget _submitBtn = Consumer<AuthProvider>(
        builder: (context, provider, _) {
          return Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            child: CustomWidget.roundBtn(
              label: provider.stepIndex != 2
                  ? AppLocalizations.instance.text('TXT_CONTINUE')
                  : AppLocalizations.instance.text('TXT_JOIN'),
              btnColor: CustomColor.SECONDARY,
              lblColor: CustomColor.MAIN,
              isBold: true,
              fontSize: 16,
              function: () async => await provider.fnOnForwardTransition(context),
            ),
          );
        }
    );

    return ModalProgressHUD(
      inAsyncCall: _isLoad,
      progressIndicator: SpinKitFadingCube(color: CustomColor.MAIN,),
      opacity: 0.5,
      child: GestureDetector(
        onTap: () => _provider.fnKeyboardUnFocus(context),
        child: Scaffold(
          key: _provider.scaffoldKey,
          backgroundColor: CustomColor.MAIN,
          appBar: AppBar(
            backgroundColor: CustomColor.MAIN,
            elevation: 0,
            title: null,
            centerTitle: false,
            leading: GestureDetector(
                onTap: () async => await _provider.fnOnBackTransition(context),
                child: Icon(Icons.arrow_back_ios)),
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

import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/provider/auth/register_provider.dart';
import 'package:eight_barrels/screen/auth/tac_webview_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
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
    with TextValidation, SingleTickerProviderStateMixin, LoadingView {
  bool _isLoad = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<RegisterProvider>(context, listen: false)
          .fnInitAnimation(this);
      Provider.of<RegisterProvider>(context, listen: false).fnGetView(this);
      Provider.of<RegisterProvider>(context, listen: false).fnFetchRegionList();
      Provider.of<RegisterProvider>(context, listen: false)
          .fnFetchProvinceList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<RegisterProvider>(context, listen: false);

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
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _provider.fKeyPersonal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.instance.text('TXT_LBL_NAME'),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
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
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${AppLocalizations.instance.text('TXT_LBL_DOB')} *',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
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
                              Consumer<RegisterProvider>(
                                  child: Container(),
                                  builder: (context, provider, skeleton) {
                                    switch (provider.isAgeValid) {
                                      case true:
                                        return Icon(
                                          FontAwesomeIcons.solidCircleCheck,
                                          size: 20,
                                          color: Colors.greenAccent,
                                        );
                                      case false:
                                        return Icon(
                                          FontAwesomeIcons.circleExclamation,
                                          size: 20,
                                          color: Colors.amberAccent,
                                        );
                                      default:
                                        return skeleton!;
                                    }
                                  }),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                FontAwesomeIcons.calendarDays,
                                size: 20,
                                color: Colors.white,
                              ),
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
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.instance.text('TXT_LBL_EMAIL'),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Consumer<RegisterProvider>(builder: (context, provider, _) {
                    return TextFormField(
                      controller: provider.emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) async =>
                          await provider.fnValidateEmail(context, value),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        errorText: provider.errEmail,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Consumer<RegisterProvider>(
                                  child: Container(),
                                  builder: (context, provider, skeleton) {
                                    switch (provider.isEmailValid) {
                                      case false:
                                        return Icon(
                                          FontAwesomeIcons.solidCircleCheck,
                                          size: 20,
                                          color: Colors.greenAccent,
                                        );
                                      case true:
                                        return Icon(
                                          FontAwesomeIcons.circleExclamation,
                                          size: 20,
                                          color: Colors.amberAccent,
                                        );
                                      default:
                                        return skeleton!;
                                    }
                                  }),
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
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.instance.text('TXT_LBL_PHONE'),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
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
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.instance.text('TXT_LBL_GENDER'),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Consumer<RegisterProvider>(builder: (context, provider, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: provider.genderList.map((item) {
                        return Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio(
                                value: item.gender,
                                groupValue: provider.genderValue,
                                onChanged: provider.fnOnChangeGender,
                                activeColor: Colors.white,
                                visualDensity: VisualDensity.compact,
                              ),
                              Flexible(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            '*${AppLocalizations.instance.text('TXT_AGE_INFO')}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );

    Widget _formAddress = Form(
      key: _provider.fKeyAddress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.instance.text('TXT_REGISTER_ADDRESS'),
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            color: Colors.white38,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.instance.text('TXT_LBL_ADDRESS'),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async =>
                        await _provider.fnShowPlacePicker(context),
                    child: TextFormField(
                      enabled: false,
                      controller: _provider.addressController,
                      validator: validateField,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        suffixIcon: Icon(
                          FontAwesomeIcons.mapLocationDot,
                          size: 20,
                          color: Colors.white,
                        ),
                        isDense: true,
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.instance.text('TXT_REGISTER_PROVINCE'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => CustomWidget.showSheet(
                      context: context,
                      isScroll: true,
                      child: ChangeNotifierProvider.value(
                        value: Provider.of<RegisterProvider>(context,
                            listen: false),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Consumer<RegisterProvider>(
                            child: Container(),
                            builder: (context, provider, skeleton) {
                              switch (provider.provinceList.rajaongkir) {
                                case null:
                                  return skeleton!;
                                default:
                                  switch (provider
                                      .provinceList.rajaongkir?.results) {
                                    case null:
                                      return skeleton!;
                                    default:
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: provider.provinceList
                                            .rajaongkir!.results!.length,
                                        itemBuilder: (context, index) {
                                          var _data = provider.provinceList
                                              .rajaongkir!.results![index];
                                          return GestureDetector(
                                            onTap: () async {
                                              Get.back();
                                              await provider.fnOnSelectProvince(
                                                name: _data.province!,
                                                id: _data.provinceId!,
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 15),
                                              child: Text(
                                                _data.province ?? '-',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Divider();
                                        },
                                      );
                                  }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    child: TextFormField(
                      enabled: false,
                      controller: _provider.provinceController,
                      validator: validateField,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        isDense: true,
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.instance.text('TXT_REGISTER_CITY'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_provider.provinceController.text.isNotEmpty) {
                        CustomWidget.showSheet(
                          context: context,
                          isScroll: true,
                          child: ChangeNotifierProvider.value(
                            value: Provider.of<RegisterProvider>(context,
                                listen: false),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Consumer<RegisterProvider>(
                                child: Container(),
                                builder: (context, provider, skeleton) {
                                  switch (provider.cityList.rajaongkir) {
                                    case null:
                                      return skeleton!;
                                    default:
                                      switch (provider
                                          .cityList.rajaongkir?.results) {
                                        case null:
                                          return skeleton!;
                                        default:
                                          return ListView.separated(
                                            shrinkWrap: true,
                                            itemCount: provider.cityList
                                                .rajaongkir!.results!.length,
                                            itemBuilder: (context, index) {
                                              var _data = provider.cityList
                                                  .rajaongkir!.results![index];
                                              return GestureDetector(
                                                onTap: () async {
                                                  Get.back();
                                                  await provider.fnOnSelectCity(
                                                    name: _data.cityName!,
                                                    id: _data.cityId!,
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 15),
                                                  child: Text(
                                                    _data.cityName ?? '-',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return Divider();
                                            },
                                          );
                                      }
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      } else {
                        CustomWidget.showSnackBar(
                            context: context,
                            content: Text(AppLocalizations.instance
                                .text('TXT_REGISTER_CITY_INFO')));
                      }
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _provider.cityController,
                      validator: validateField,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        isDense: true,
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.instance.text('TXT_REGISTER_REGION'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => CustomWidget.showSheet(
                      context: context,
                      isScroll: true,
                      child: ChangeNotifierProvider.value(
                        value: Provider.of<RegisterProvider>(context,
                            listen: false),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Consumer<RegisterProvider>(
                            child: Container(),
                            builder: (context, provider, skeleton) {
                              switch (provider.regionList.data) {
                                case null:
                                  return skeleton!;
                                default:
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: provider.regionList.data!.length,
                                    itemBuilder: (context, index) {
                                      var _data =
                                          provider.regionList.data![index];
                                      return GestureDetector(
                                        onTap: () async {
                                          Get.back();
                                          await provider.fnOnSelectRegion(
                                            name: _data.name!,
                                            id: _data.id!,
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: Text(
                                            _data.name ?? '-',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return Divider();
                                    },
                                  );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    child: TextFormField(
                      enabled: false,
                      controller: _provider.regionController,
                      validator: validateField,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        isDense: true,
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _provider.fKeyPassword,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.instance.text('TXT_LBL_PASS'),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              TextFormField(
                controller: _provider.passController,
                textInputAction: TextInputAction.next,
                validator: validatePassword,
                obscureText: _provider.isHidePass,
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
                      _provider.isHidePass
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                      size: 24,
                    ),
                    onTap: () => _provider.fnPassVblRegis(context),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.instance.text('TXT_LBL_PASS_CONFIRM'),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              TextFormField(
                controller: _provider.confirmPassController,
                textInputAction: TextInputAction.next,
                validator: (value) => validateConfirmPassword(
                    _provider.passController.text, value),
                obscureText: _provider.isHidePassConfirm,
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
                      _provider.isHidePassConfirm
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
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              AppLocalizations.instance.text('TXT_SIGN_UP'),
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          Consumer<RegisterProvider>(builder: (context, provider, _) {
            return Flexible(
              child: provider.stepProgressBar(context: context),
            );
          }),
          Consumer<RegisterProvider>(
              child: Container(),
              builder: (context, provider, skeleton) {
                switch (provider.offsetAnimation) {
                  case null:
                    return skeleton!;
                  default:
                    return SlideTransition(
                      position: provider.offsetAnimation!,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                        child: provider.stepIndex == 0
                            ? _formPersonal
                            : provider.stepIndex == 1
                                ? _formAddress
                                : _formPassword,
                      ),
                    );
                }
              }),
        ],
      ),
    );

    Widget _submitBtn =
        Consumer<RegisterProvider>(builder: (context, provider, _) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Theme(
                  data: ThemeData(
                    unselectedWidgetColor: Colors.white,
                  ),
                  child: Checkbox(
                    value: provider.isTacAccepted,
                    onChanged: provider.fnOnCheckTOC,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: Colors.blue,
                  ),
                ),
                Flexible(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: AppLocalizations.instance
                            .text('TXT_TERM_AND_CONDITION_INFO_1'),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' ${AppLocalizations.instance.text('TXT_TERM_AND_CONDITION')} ',
                        style: TextStyle(
                          color: Colors.orangeAccent,
                        ),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () => Get.toNamed(TacWebviewScreen.tag),
                      ),
                      TextSpan(
                        text: AppLocalizations.instance
                            .text('TXT_TERM_AND_CONDITION_INFO_2'),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ]),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              width: MediaQuery.of(context).size.width,
              child: CustomWidget.roundBtn(
                label: provider.stepIndex != 2
                    ? AppLocalizations.instance.text('TXT_CONTINUE')
                    : AppLocalizations.instance.text('TXT_JOIN'),
                btnColor: CustomColor.SECONDARY,
                lblColor: CustomColor.MAIN,
                isBold: true,
                fontSize: 16,
                function: () async =>
                    await provider.fnOnForwardTransition(context),
              ),
            ),
          ],
        ),
      );
    });

    return CustomWidget.loadingHud(
      isLoad: _isLoad,
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
                  child: Image.asset(
                    'assets/images/ic_logo_bu_white.png',
                  ),
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

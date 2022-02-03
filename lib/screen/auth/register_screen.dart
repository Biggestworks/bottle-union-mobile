import 'package:eight_barrels/helper/app-localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/validation.dart';
import 'package:eight_barrels/provider/auth/register_provider.dart';
import 'package:eight_barrels/screen/home/home_screen.dart';
import 'package:eight_barrels/screen/widget/state_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';

import '../widget/custom_widget.dart';

class RegisterScreen extends StatefulWidget {
  static String tag = '/register-screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TextValidation, SingleTickerProviderStateMixin {

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<RegisterProvider>(context, listen: false).initAnimation(vsync: this);
    });
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<RegisterProvider>(context, listen: false).animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<RegisterProvider>(context, listen: false);

    Widget formPersonal = Card(
      color: Colors.white38,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
              decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColor.MAIN),
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
              validator: validateField,
              decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColor.MAIN),
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
              validator: validateField,
              decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColor.MAIN),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text(AppLocalizations.instance.text('TXT_LBL_GENDER'), style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),),
            TextFormField(
              controller: _provider.nameController,
              textInputAction: TextInputAction.next,
              validator: validateField,
              decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColor.MAIN),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Widget formAddress = Column(
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
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      suffixIcon: Icon(FontAwesomeIcons.mapMarkedAlt, size: 24, color: Colors.white,),
                      isDense: true,
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Consumer<RegisterProvider>(
        //   child: Container(),
        //   builder: (context, provider, skeleton) {
        //     switch (provider.stepIndex) {
        //       case 1:
        //         return _provider.fnShowMapPicker();
        //       default:
        //         return skeleton!;
        //     }
        //   },
        // ),
      ],
    );

    Widget formPassword = Card(
      color: Colors.white38,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
              validator: validateField,
              decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColor.MAIN),
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
              validator: validateField,
              decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColor.MAIN),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Widget mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Text(AppLocalizations.instance.text('TXT_SIGN_UP'), style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),),
        ),
        Consumer<RegisterProvider>(
            builder: (context, provider, _) {
              return Flexible(
                child: provider.stepProgressBar(context: context),
              );
            }
        ),
        SingleChildScrollView(
          child: Consumer<RegisterProvider>(
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
                            ? formPersonal
                            : provider.stepIndex == 1
                            ? formAddress
                            : formPassword,
                      ),
                    );
                }
              }
          ),
        )
      ],
    );

    Widget submitBtn = Consumer<RegisterProvider>(
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
              function: () => provider.forwardTransition(context: context),
            ),
          );
        }
    );

    return Scaffold(
      backgroundColor: CustomColor.MAIN,
      appBar: AppBar(
        backgroundColor: CustomColor.MAIN,
        elevation: 0,
        title: null,
        centerTitle: false,
        leading: GestureDetector(
            onTap: () {
              _provider.backTransition(context: context);
            },
            child: Icon(Icons.arrow_back_ios)),
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
      bottomNavigationBar: submitBtn,
      // floatingActionButton: submitBtn,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

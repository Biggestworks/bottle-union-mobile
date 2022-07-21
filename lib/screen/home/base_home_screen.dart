import 'dart:async';

import 'package:badges/badges.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class BaseHomeScreen extends StatefulWidget {
  static String tag = '/base-home-screen';
  final int? pageIndex;

  const BaseHomeScreen({Key? key, this.pageIndex}) : super(key: key);

  @override
  _BaseHomeScreenState createState() => _BaseHomeScreenState();
}

class _BaseHomeScreenState extends State<BaseHomeScreen> {
  UserPreferences _userPreferences = new UserPreferences();
  final _storage = new FlutterSecureStorage();
  var _period;

  Future _fnCheckUserToken(BuildContext context, String isGuest) async {
    if (isGuest != 'true') {
      _period = new Timer.periodic(Duration(seconds: 10), (timer) async {
        var _res = await _userPreferences.getUserData();
        if (_res?.status == 'Token is Invalid') {
          timer.cancel();
          CustomWidget.showSuccessDialog(
            context,
            title: '[Error 401] Token is invalid',
            desc: 'You will be logged out from the application',
            function: () async {
              await _userPreferences.removeUserToken();
              await _userPreferences.removeFcmToken();
              await _storage.delete(key: KeyHelper.KEY_USER_REGION_ID);
              await _storage.delete(key: KeyHelper.KEY_USER_REGION_NAME);
              Get.offNamedUntil(StartScreen.tag, (route) => false);
            },
          );
        }
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<BaseHomeProvider>(context, listen: false).fnGetArguments(context)
          .whenComplete(() => _fnCheckUserToken(context, (Provider.of<BaseHomeProvider>(context, listen: false).isGuest ?? 'false')));
      Provider.of<BaseHomeProvider>(context, listen: false).fnIsFirstTime()
          .whenComplete(() => WidgetsBinding.instance!.addPostFrameCallback(
              (_) => Provider.of<BaseHomeProvider>(context, listen: false).fnStartShowcase(context)));
      Provider.of<BaseHomeProvider>(context, listen: false).fnGetCartCount();
    },);
    super.initState();
  }

  @override
  void dispose() {
    _period?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget _bottomNavBar = Consumer<BaseHomeProvider>(
      child: Container(),
      builder: (context, provider, skeleton) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: CustomColor.GREY_TXT,
                blurRadius: 8,
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              // canvasColor: Colors.white,
              canvasColor: CustomColor.MAIN,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              currentIndex: provider.pageIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              showUnselectedLabels: false,
              iconSize: 18,
              selectedFontSize: 12,
              onTap: provider.fnOnNavBarSelected,
              items: provider.isGuest == 'true'
                  ? provider.guestNavBarItems()
                  : provider.navBarItems(),
            ),
          ),
        );
      },
    );

    Widget _showcaseBottomNavBar = Consumer<BaseHomeProvider>(
      child: Container(),
      builder: (context, provider, skeleton) {
        return Showcase(
          description: AppLocalizations.instance.text('TXT_SHOW_INTRO_INFO'),
          key: provider.showIntro,
          blurValue: 1,
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: CustomColor.MAIN,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              currentIndex: provider.pageIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              showUnselectedLabels: false,
              iconSize: 18,
              selectedFontSize: 12,
              onTap: provider.fnOnNavBarSelected,
              items: provider.isGuest == 'true'
                  ? provider.showCaseGuestNavItems()
                  : provider.showCaseNavItems(),
            ),
          ),
        );
      },
    );

    return Scaffold(
      body: Consumer<BaseHomeProvider>(
        builder: (context, provider, _) => provider.isGuest == 'true'
            ? provider.guestScreenList()
            : provider.screenList(),
      ),
      bottomNavigationBar: Consumer<BaseHomeProvider>(
        builder: (context, provider, _) {
          switch (provider.firstTime) {
            case 'false':
              return _bottomNavBar;
            default:
              return _showcaseBottomNavBar;
          }
        }
      ),
    );
  }
}

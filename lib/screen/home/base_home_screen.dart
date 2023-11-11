import 'dart:async';

import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/provider/home/base_home_provider.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:eight_barrels/screen/home/choose_country_page.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

class _BaseHomeScreenState extends State<BaseHomeScreen> with LoadingView {
  var _period;
  bool _isLoad = false;

  Future _fnCheckUserToken(BuildContext context, String isGuest) async {
    UserPreferences _userPreferences = new UserPreferences();
    FlutterSecureStorage _storage = new FlutterSecureStorage();

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
    Future.delayed(
      Duration.zero,
      () {
        Provider.of<BaseHomeProvider>(context, listen: false).fnGetView(this);
        Provider.of<BaseHomeProvider>(context, listen: false)
            .fnGetArguments(context)
            .whenComplete(() {
          _fnCheckUserToken(
              context,
              (Provider.of<BaseHomeProvider>(context, listen: false).isGuest ??
                  'false'));
          Provider.of<BaseHomeProvider>(context, listen: false)
              .fnStartShowcase(context);
        });
        Provider.of<BaseHomeProvider>(context, listen: false).fnGetCartCount();
      },
    );
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
          child: Container(),
          builder: (context, provider, skeleton) {
            if (_isLoad) {
              return Text('ini');
              return skeleton!;
            } else {
              if (provider.isGuest == 'true') {
                return provider.guestScreenList();
              } else {
                if (provider.selectedCountry != null &&
                    provider.selectedCity != null &&
                    provider.selectedBranch != null) {
                  return provider.screenList();
                } else {
                  return ChooseCountryPage();
                }
              }
              // switch (provider.isGuest) {
              //   case 'true':
              //     return provider.guestScreenList();
              //   default:
              //     return ChooseCountryPage();
              //   // return provider.screenList();
              // }
            }
            // switch (_isLoad) {
            //   case true:
            //     return skeleton!;
            //   default:
            //     // return provider.screenList2();
            //     switch (provider.isGuest) {
            //       case 'true':
            //         return provider.guestScreenList();
            //       default:
            //         return ChooseCountryPage();
            //         return provider.screenList();
            //     }
            // }
          }),
      bottomNavigationBar: Consumer<BaseHomeProvider>(
          child: Container(),
          builder: (context, provider, skeleton) {
            if (_isLoad) {
              return skeleton!;
            } else {
              if (provider.firstTime == 'false') {
                if (provider.selectedCountry != null &&
                    provider.selectedCity != null &&
                    provider.selectedBranch != null) {
                  return _bottomNavBar;
                } else {
                  return Container(
                    height: 0,
                  );
                }
              } else {
                return _showcaseBottomNavBar;
              }
              // switch (provider.firstTime) {
              //   case 'false':
              //     return _bottomNavBar;
              //   default:
              //     return _showcaseBottomNavBar;
              // }
            }
            // switch (_isLoad) {
            //   case true:
            //     return skeleton!;
            //   default:
            //     switch (provider.firstTime) {
            //       case 'false':
            //         return _bottomNavBar;
            //       default:
            //         return _showcaseBottomNavBar;
            //     }
            // }
          }),
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

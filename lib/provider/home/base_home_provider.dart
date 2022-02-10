import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/screen/home/home_screen.dart';
import 'package:eight_barrels/screen/product/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BaseHomeProvider extends ChangeNotifier {

  List<PersistentBottomNavBarItem> navBarItem = [
    PersistentBottomNavBarItem(
      icon: Icon(
        FontAwesomeIcons.home,
        size: 20,
      ),
      title: AppLocalizations.instance.text('TXT_NAV_HOME'),
      activeColorPrimary: Colors.white,
      activeColorSecondary: CustomColor.MAIN,
      inactiveColorPrimary: Colors.white,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(
        FontAwesomeIcons.wineBottle,
        size: 20,
      ),
      title: AppLocalizations.instance.text('TXT_NAV_PRODUCT'),
      activeColorPrimary: Colors.white,
      activeColorSecondary: CustomColor.MAIN,
      inactiveColorPrimary: Colors.white,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(
        FontAwesomeIcons.shoppingCart,
        size: 20,
      ),
      title: AppLocalizations.instance.text('TXT_NAV_CART'),
      activeColorPrimary: Colors.white,
      activeColorSecondary: CustomColor.MAIN,
      inactiveColorPrimary: Colors.white,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(
        FontAwesomeIcons.history,
        size: 20,
      ),
      title: AppLocalizations.instance.text('TXT_NAV_TRANSACTION'),
      activeColorPrimary: Colors.white,
      activeColorSecondary: CustomColor.MAIN,
      inactiveColorPrimary: Colors.white,
    ),
  ];

  Widget _underConstructionPage() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: Image.asset('assets/images/ic_under_construction.jpg'),
          ),
          SizedBox(height: 10,),
          Text('Under Construction ...', style: TextStyle(
            fontSize: 20,
          ),),
        ],
      ),
    );
  }

  List<Widget> screenList() {
    return [
      HomeScreen(),
      ProductListScreen(),
      _underConstructionPage(),
      _underConstructionPage(),
    ];
  }
}
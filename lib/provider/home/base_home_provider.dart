// ignore_for_file: unused_import, deprecated_member_use

import 'dart:async';

import 'package:badges/badges.dart' as BadgeWidget;
import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/screen/auth/guest_start_screen.dart';
import 'package:eight_barrels/screen/cart/cart_list_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/home/guest_home_screen.dart';
import 'package:eight_barrels/screen/home/home_screen.dart';
import 'package:eight_barrels/screen/product/product_list_screen.dart';
import 'package:eight_barrels/screen/transaction/transaction_screen.dart';
import 'package:eight_barrels/service/cart/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:showcaseview/showcaseview.dart';

class BaseHomeProvider extends ChangeNotifier {
  CartService _cartService = new CartService();
  final _storage = new FlutterSecureStorage();
  UserPreferences _userPreferences = new UserPreferences();

  int pageIndex = 0;
  int cartCount = 0;

  final GlobalKey showIntro = new GlobalKey();
  final GlobalKey showHome = new GlobalKey();
  final GlobalKey showProduct = new GlobalKey();
  final GlobalKey showCart = new GlobalKey();
  final GlobalKey showTransaction = new GlobalKey();

  String? firstTime;
  String? isGuest;
  String? selectedCountry;
  String? selectedCity;
  String? selectedBranch;

  LoadingView? _view;

  fnGetView(LoadingView view) {
    this._view = view;
  }

  saveBranchSelection(
      bool isSave,
      String selectedCountries,
      String selectedCities,
      String selectedBranchs,
      String selectedBranchName) async {
    if (isSave) {
      final _storage = new FlutterSecureStorage();
      _storage.write(
          key: KeyHelper.SELECTED_COUNTRY_KEY, value: selectedCountries);
      _storage.write(key: KeyHelper.SELECTED_CITY_KEY, value: selectedCities);
      _storage.write(
          key: KeyHelper.SELECTED_BRANCH_KEY, value: selectedBranchs);
      _storage.write(key: KeyHelper.KEY_USER_REGION_ID, value: selectedBranchs);
      _storage.write(
          key: KeyHelper.KEY_USER_REGION_NAME, value: selectedBranchName);
    }
    selectedCountry = selectedCountries;
    selectedCity = selectedCities;
    selectedBranch = selectedBranchs;
    notifyListeners();
  }

  checkBranchSelection() async {
    final _storage = new FlutterSecureStorage();
    final country = await _storage.read(key: KeyHelper.SELECTED_COUNTRY_KEY);
    final city = await _storage.read(key: KeyHelper.SELECTED_CITY_KEY);
    final branch = await _storage.read(key: KeyHelper.SELECTED_BRANCH_KEY);

    selectedCountry = country;
    selectedCity = city;
    selectedBranch = branch;
    notifyListeners();
  }

  Future fnGetArguments(BuildContext context) async {
    _view!.onProgressStart();
    final _args = ModalRoute.of(context)!.settings.arguments as BaseHomeScreen;
    pageIndex = _args.pageIndex ?? 0;
    isGuest = await _userPreferences.getGuestStatus();
    firstTime = await _storage.read(key: KeyHelper.KEY_IS_FIRST_TIME);
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnGetCartCount() async {
    if (isGuest != 'true') {
      var _res = await _cartService.cartList();
      cartCount = _res!.result != null ? _res.result!.total! : 0;
    }
    notifyListeners();
  }

  Widget screenList() {
    switch (pageIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return ProductListScreen();
      case 2:
        return CartListScreen();
      case 3:
        return TransactionScreen();
      default:
        return Container();
    }
  }

  Widget guestScreenList() {
    switch (pageIndex) {
      case 0:
        return GuestHomeScreen();
      case 1:
        return GuestStartScreen();
      default:
        return Container();
    }
  }

  List<BottomNavigationBarItem> navBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Icon(FontAwesomeIcons.house),
        ),
        label: AppLocalizations.instance.text('TXT_NAV_HOME'),
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Icon(FontAwesomeIcons.wineBottle),
        ),
        label: AppLocalizations.instance.text('TXT_NAV_PRODUCT'),
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: BadgeWidget.Badge(
            badgeContent: Text(
              cartCount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            // badgeColor: CustomColor.BROWN_TXT,
            // padding: EdgeInsets.all(6),
            position: BadgeWidget.BadgePosition.topEnd(top: -12, end: -15),
            child: Icon(FontAwesomeIcons.cartShopping),
          ),
        ),
        label: AppLocalizations.instance.text('TXT_NAV_CART'),
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Icon(FontAwesomeIcons.receipt),
        ),
        label: AppLocalizations.instance.text('TXT_NAV_TRANSACTION'),
      ),
    ];
  }

  List<BottomNavigationBarItem> guestNavBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Icon(FontAwesomeIcons.house),
        ),
        label: AppLocalizations.instance.text('TXT_NAV_HOME'),
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Icon(FontAwesomeIcons.solidUser),
        ),
        label: AppLocalizations.instance.text('TXT_NAV_ACCOUNT'),
      ),
    ];
  }

  List<BottomNavigationBarItem> showCaseNavItems() {
    return [
      BottomNavigationBarItem(
        icon: Showcase.withWidget(
          key: showHome,
          height: 200,
          width: 300,
          // overlayPadding: EdgeInsets.all(20),
          container: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.instance.text('TXT_NAV_HOME'),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppLocalizations.instance.text('TXT_NAV_HOME_INFO'),
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Icon(FontAwesomeIcons.home),
          ),
        ),
        label: AppLocalizations.instance.text('TXT_NAV_HOME'),
      ),
      BottomNavigationBarItem(
        icon: Showcase.withWidget(
          key: showProduct,
          height: 200,
          width: 300,
          // overlayPadding: EdgeInsets.all(10),
          container: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.instance.text('TXT_NAV_PRODUCT'),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppLocalizations.instance.text('TXT_NAV_PRODUCT_INFO'),
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Icon(FontAwesomeIcons.wineBottle),
          ),
        ),
        label: AppLocalizations.instance.text('TXT_NAV_PRODUCT'),
      ),
      BottomNavigationBarItem(
        icon: Showcase.withWidget(
          key: showCart,
          height: 200,
          width: 300,
          // overlayPadding: EdgeInsets.all(15),
          container: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.instance.text('TXT_NAV_CART'),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppLocalizations.instance.text('TXT_NAV_CART_INFO'),
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: BadgeWidget.Badge(
              badgeContent: Text(
                cartCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
              // badgeColor: CustomColor.BROWN_TXT,
              // padding: EdgeInsets.all(6),
              child: Icon(FontAwesomeIcons.cartShopping),
            ),
          ),
        ),
        label: AppLocalizations.instance.text('TXT_NAV_CART'),
      ),
      BottomNavigationBarItem(
        icon: Showcase.withWidget(
          key: showTransaction,
          height: 200,
          width: 300,
          // overlayPadding: EdgeInsets.all(10),
          container: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.instance.text('TXT_NAV_TRANSACTION'),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppLocalizations.instance.text('TXT_NAV_TRANSACTION_INFO'),
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Icon(FontAwesomeIcons.receipt),
          ),
        ),
        label: AppLocalizations.instance.text('TXT_NAV_TRANSACTION'),
      ),
    ];
  }

  List<BottomNavigationBarItem> showCaseGuestNavItems() {
    return [
      BottomNavigationBarItem(
        icon: Showcase.withWidget(
          key: showHome,
          height: 200,
          width: 300,
          // overlayPadding: EdgeInsets.all(20),
          container: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.instance.text('TXT_NAV_HOME'),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppLocalizations.instance.text('TXT_NAV_HOME_INFO'),
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Icon(FontAwesomeIcons.home),
          ),
        ),
        label: AppLocalizations.instance.text('TXT_NAV_HOME'),
      ),
      BottomNavigationBarItem(
        icon: Showcase.withWidget(
          key: showProduct,
          height: 200,
          width: 300,
          // overlayPadding: EdgeInsets.all(10),
          container: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.instance.text('TXT_NAV_PRODUCT'),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppLocalizations.instance.text('TXT_NAV_PRODUCT_INFO'),
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Icon(FontAwesomeIcons.wineBottle),
          ),
        ),
        label: AppLocalizations.instance.text('TXT_NAV_PRODUCT'),
      ),
    ];
  }

  fnOnNavBarSelected(int val) {
    this.pageIndex = val;
    notifyListeners();
  }

  fnStartShowcase(BuildContext context) async {
    if (firstTime != 'false')
      ShowCaseWidget.of(context).startShowCase(
          [showIntro, showHome, showProduct, showCart, showTransaction]);
    notifyListeners();
  }
}

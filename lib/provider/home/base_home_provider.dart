import 'package:badges/badges.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/screen/cart/base_cart_screen.dart';
import 'package:eight_barrels/screen/home/home_screen.dart';
import 'package:eight_barrels/screen/product/product_list_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/cart/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BaseHomeProvider extends ChangeNotifier {
  CartService _cartService = new CartService();

  int pageIndex = 0;
  int cartCount = 0;

  Future fnGetCartCount() async {
    var _res = await _cartService.cartList();
    cartCount = _res!.result!.total!;
    notifyListeners();
  }

  BaseHomeProvider() {
    fnGetCartCount();
  }

  List<BottomNavigationBarItem> navBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Icon(FontAwesomeIcons.home),
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
          child: Badge(
            badgeContent: Text(cartCount.toString(), style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),),
            badgeColor: CustomColor.BROWN_TXT,
            padding: EdgeInsets.all(6),
            child: Icon(FontAwesomeIcons.shoppingCart),
          ),
        ),
        label: AppLocalizations.instance.text('TXT_NAV_CART'),
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Icon(FontAwesomeIcons.history),
        ),
        label: AppLocalizations.instance.text('TXT_NAV_TRANSACTION'),
      ),
    ];
  }

  Widget screenList() {
    switch (pageIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return ProductListScreen();
      case 2:
        return BaseCartScreen();
      case 3:
        return CustomWidget.underConstructionPage();
      default:
        return Container();
    }
  }

  fnOnNavBarSelected(int val) {
    this.pageIndex = val;
    notifyListeners();
  }

}
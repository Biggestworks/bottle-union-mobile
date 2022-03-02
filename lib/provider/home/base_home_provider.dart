import 'package:eight_barrels/screen/cart/base_cart_screen.dart';
import 'package:eight_barrels/screen/home/home_screen.dart';
import 'package:eight_barrels/screen/product/product_list_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/cart/cart_service.dart';
import 'package:flutter/material.dart';

class BaseHomeProvider extends ChangeNotifier {
  CartService _cartService = new CartService();

  int pageIndex = 0;
  int cartCount = 0;

  Future fnGetCartCount() async {
    var _res = await _cartService.cartList();
    cartCount = _res!.result!.total!;
    print(cartCount);
    notifyListeners();
  }

  BaseHomeProvider() {
    fnGetCartCount();
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
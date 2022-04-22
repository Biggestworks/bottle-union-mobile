import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/screen/cart/cart_list_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/home/home_screen.dart';
import 'package:eight_barrels/screen/product/product_list_screen.dart';
import 'package:eight_barrels/screen/transaction/transaction_screen.dart';
import 'package:eight_barrels/service/cart/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:showcaseview/showcaseview.dart';

class BaseHomeProvider extends ChangeNotifier {
  CartService _cartService = new CartService();
  final _storage = new FlutterSecureStorage();

  int pageIndex = 0;
  int cartCount = 0;

  final GlobalKey showIntro = new GlobalKey();
  final GlobalKey showHome = new GlobalKey();
  final GlobalKey showProduct = new GlobalKey();
  final GlobalKey showCart = new GlobalKey();
  final GlobalKey showTransaction = new GlobalKey();

  String? firstTime;

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as BaseHomeScreen;
    pageIndex = _args.pageIndex ?? 0;
    notifyListeners();
  }

  Future fnGetCartCount() async {
    var _res = await _cartService.cartList();
    cartCount = _res!.result != null ? _res.result!.total! : 0;
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

  fnOnNavBarSelected(int val) {
    this.pageIndex = val;
    notifyListeners();
  }

  Future fnIsFirstTime() async {
    firstTime = await _storage.read(key: KeyHelper.KEY_IS_FIRST_TIME);
    notifyListeners();
  }

  fnStartShowcase(BuildContext context) async {
    if (firstTime != 'false')
      ShowCaseWidget.of(context)?.startShowCase([showIntro, showHome, showProduct, showCart, showTransaction]);
    notifyListeners();
  }

}
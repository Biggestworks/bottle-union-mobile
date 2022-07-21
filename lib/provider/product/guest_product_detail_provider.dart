import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/product_log.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/screen/product/guest_product_detail_screen.dart';
import 'package:eight_barrels/service/product/product_service.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

class GuestProductDetailProvider extends ChangeNotifier with ProductLog {
  ProductService _productService = new ProductService();
  ProductDetailModel product = new ProductDetailModel();
  UserPreferences _userPreferences = new UserPreferences();

  int? productId;
  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as GuestProductDetailScreen;
    productId = _args.productId!;
    notifyListeners();
  }

  Future fnFetchProduct() async {
    _view!.onProgressStart();
    product = (await _productService.getProductDetail(id: productId))!;
    _view!.onProgressFinish();
    notifyListeners();
  }

  fnConvertHtmlString(String text) => parse(text).documentElement?.text;

}
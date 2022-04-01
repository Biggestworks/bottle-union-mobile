import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/product_log.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/model/product/discussion_list_model.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/cart/cart_service.dart';
import 'package:eight_barrels/service/discussion/discussion_service.dart';
import 'package:eight_barrels/service/product/product_service.dart';
import 'package:eight_barrels/service/product/wishlist_service.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

class ProductDetailProvider extends ChangeNotifier with ProductLog {
  ProductService _productService = new ProductService();
  WishlistService _wishlistService = new WishlistService();
  DiscussionService _discussionService = new DiscussionService();
  CartService _cartService = new CartService();
  ProductDetailModel product = new ProductDetailModel();
  DiscussionListModel discussionList = new DiscussionListModel();

  bool isWishlist = false;
  int? id;

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as ProductDetailScreen;
    id = _args.id!;
    notifyListeners();
  }

  Future fnFetchProduct() async {
    _view!.onProgressStart();
    product = (await _productService.productDetail(id: id))!;
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnCheckWishlist() async {
    var _res = await _wishlistService.checkWishlist(
      productId: product.data!.id!,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        isWishlist = true;
      } else {
        isWishlist = false;
      }
    }
    notifyListeners();
  }

  Future fnStoreWishlist(BuildContext context) async {
    var _res = await _wishlistService.storeWishlist(
      productId: product.data!.id!,
    );

    if (_res!.status != null) {
      if (_res.status == true && _res.message == 'Save Success') {
        await fnStoreLog(
          productId: [product.data?.id ?? 0],
          categoryId: null,
          notes: KeyHelper.SAVE_WISHLIST_KEY,
        );
        await fnCheckWishlist();
        await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_WISHLIST_ADD')));
      } else if (_res.status == true && _res.message == 'Success remove wishlist') {
        await fnStoreLog(
          productId: [product.data?.id ?? 0],
          categoryId: null,
          notes: KeyHelper.REMOVE_WISHLIST_KEY,
        );
        await fnCheckWishlist();
        await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_WISHLIST_DELETE_SUCCESS')));
      } else {
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message.toString()));
      }
    } else {
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
  }

  Future fnStoreCart(BuildContext context) async {
    var _res = await _cartService.storeCart(
      productId: product.data!.id!,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        await fnStoreLog(
          productId: [product.data?.id ?? 0],
          categoryId: null,
          notes: KeyHelper.SAVE_CART_KEY,
        );
        await fnCheckWishlist();
        await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_CART_ADD_INFO')));
      } else {
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message.toString()));
      }
    } else {
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
  }

  Future fnFetchDiscussionList(BuildContext context) async {
    _view!.onProgressStart();
    discussionList = (await _discussionService.getDiscussionList(productId: product.data!.id!))!;
    _view!.onProgressFinish();
    notifyListeners();
  }

  fnConvertHtmlString(String text) {
    return parse(text).documentElement?.text;
  }

}
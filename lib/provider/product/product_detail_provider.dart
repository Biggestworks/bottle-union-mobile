import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/cart/cart_service.dart';
import 'package:eight_barrels/service/product/product_service.dart';
import 'package:eight_barrels/service/product/wishlist_service.dart';
import 'package:flutter/material.dart';

class ProductDetailProvider extends ChangeNotifier {
  ProductService _productService = new ProductService();
  WishlistService _wishlistService = new WishlistService();
  CartService _cartService = new CartService();
  UserPreferences _userPreferences = new UserPreferences();
  ProductDetailModel product = new ProductDetailModel();

  bool isWishlist = false;
  int? id;
  // bool isVisible = true;
  // ScrollController scrollController = new ScrollController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // bool fnHideOnScroll(UserScrollNotification notification) {
  //   final ScrollDirection direction = notification.direction;
  //   if (direction == ScrollDirection.reverse) {
  //     isVisible = false;
  //     notifyListeners();
  //   } else if (direction == ScrollDirection.forward) {
  //     isVisible = true;
  //     notifyListeners();
  //   }
  //   return true;
  // }

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as ProductDetailScreen;
    id = _args.id!;
    notifyListeners();
  }

  Future fnGetProduct() async {
    product = (await _productService.productDetail(id: id))!;
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
        await fnCheckWishlist();
        await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_WISHLIST_ADD')));
      } else if (_res.status == true && _res.message == 'Success remove wishlist') {
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
        await fnCheckWishlist();
        await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_CART_ADD_INFO')));
      } else {
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message.toString()));
      }
    } else {
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
  }

}
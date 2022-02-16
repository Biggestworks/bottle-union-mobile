import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/product/product_model.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/service/product/wishlist_service.dart';
import 'package:flutter/material.dart';

class ProductDetailProvider extends ChangeNotifier {
  WishlistService _wishlistService = new WishlistService();
  UserPreferences _userPreferences = new UserPreferences();
  bool isWishlist = false;
  Data product = new Data();

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as ProductDetailScreen;
    product = _args.product!;
  }

  Future fnCheckWishlist() async {
    var _user = await _userPreferences.getUserData();

    var _res = await _wishlistService.checkWishlist(
      uid: _user!.data!.id!,
      productId: product.id!,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        isWishlist = true;
      }
    }
    notifyListeners();
  }

}
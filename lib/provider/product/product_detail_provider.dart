import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/product_log.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/product/discussion_list_model.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/product/product_detail_screen.dart';
import 'package:eight_barrels/screen/product/wishlist_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/cart/cart_service.dart';
import 'package:eight_barrels/service/discussion/discussion_service.dart';
import 'package:eight_barrels/service/product/product_service.dart';
import 'package:eight_barrels/service/product/wishlist_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:html/parser.dart' show parse;

class ProductDetailProvider extends ChangeNotifier with ProductLog {
  ProductService _productService = new ProductService();
  WishlistService _wishlistService = new WishlistService();
  DiscussionService _discussionService = new DiscussionService();
  CartService _cartService = new CartService();
  ProductDetailModel product = new ProductDetailModel();
  DiscussionListModel discussionList = new DiscussionListModel();

  UserPreferences _userPreferences = new UserPreferences();

  bool isWishlist = false;
  int? productId;
  SelectedRegion selectedRegion = new SelectedRegion();

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as ProductDetailScreen;
    productId = _args.productId!;
    notifyListeners();
  }

  Future fnFetchProduct() async {
    _view!.onProgressStart();
    product = (await _productService.getProductDetail(id: productId))!;
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnCheckWishlist() async {
    var _res = await _wishlistService.checkWishlist(
      productId: product.data?.id ?? 0,
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
      productId: product.data?.id ?? 0,
      regionId: selectedRegion.selectedRegionId ?? 0,
    );

    if (_res!.status != null) {
      if (_res.status == true && _res.message == 'Save Success') {
        await fnStoreLog(
          productId: [product.data?.id ?? 0],
          categoryId: null,
          notes: KeyHelper.SAVE_WISHLIST_KEY,
        );
        await fnCheckWishlist();
        await CustomWidget.showSnackBar(
          context: context,
          content: Text(AppLocalizations.instance.text('TXT_WISHLIST_ADD')),
          duration: 4,
          action: SnackBarAction(
            label: 'Go to wishlist',
            textColor: Colors.white,
            onPressed: () => Get.toNamed(WishListScreen.tag),
          ),
        );
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
      productIds: [product.data?.id ?? 0],
      regionIds: [selectedRegion.selectedRegionId ?? 0],
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        await fnStoreLog(
          productId: [product.data?.id ?? 0],
          categoryId: null,
          notes: KeyHelper.SAVE_CART_KEY,
        );
        await fnCheckWishlist();
        await CustomWidget.showSnackBar(
          context: context,
          content: Text(AppLocalizations.instance.text('TXT_CART_ADD_INFO')),
          duration: 4,
          action: SnackBarAction(
            label: 'Go to cart',
            textColor: Colors.white,
            onPressed: () => Get.offNamedUntil(BaseHomeScreen.tag, (route) => false, arguments: BaseHomeScreen(pageIndex: 2,)),
          ),
        );
      } else {
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message.toString()));
      }
    } else {
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
  }

  Future fnFetchDiscussionList() async {
    _view!.onProgressStart();
    discussionList = (await _discussionService.getDiscussionList(productId: product.data?.id ?? 0))!;
    _view!.onProgressFinish();
    notifyListeners();
  }

  fnConvertHtmlString(String text) => parse(text).documentElement?.text;

  Future fnGetSelectedRegionProduct() async {
    await _userPreferences.getUserData().then((value) {
      if (product.data?.productRegion?.length != 0) {
        selectedRegion.selectedRegionId = product.data?.productRegion?.singleWhere(
                (i) => i.idRegion == (value?.region?.id ?? 0), orElse: null).idRegion;
        selectedRegion.selectedProvinceId = product.data?.productRegion?.singleWhere(
                (i) => i.idRegion == (value?.region?.id ?? 0), orElse: null).region?.idProvince;
        selectedRegion.stock = product.data?.productRegion?.singleWhere(
                (i) => i.idRegion == (value?.region?.id ?? 0), orElse: null).stock ?? 0;
      }
    });
    notifyListeners();
  }

  fnOnSelectRegionProduct({required int regionId, required int provinceId, required int stock}) {
    selectedRegion.selectedRegionId = regionId;
    selectedRegion.selectedProvinceId = provinceId;
    selectedRegion.stock = stock;
    notifyListeners();
  }

}

class SelectedRegion {
  int? selectedRegionId;
  int? selectedProvinceId;
  int? stock;

  SelectedRegion({this.selectedRegionId, this.selectedProvinceId, this.stock});
}
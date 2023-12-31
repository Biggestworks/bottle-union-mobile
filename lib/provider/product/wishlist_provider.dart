import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/pagination_interface.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/model/product/user_wishlist_model.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/cart/cart_service.dart';
import 'package:eight_barrels/service/product/wishlist_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class WishListProvider extends ChangeNotifier with PaginationInterface {
  WishlistService _service = new WishlistService();
  CartService _cartService = new CartService();
  UserWishlistModel wishlist = new UserWishlistModel();

  bool isPaginateLoad = false;
  bool isSelection = false;

  List<ItemSelect> selectionList = [];
  List<int> idList = [];

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  Future fnFetchWishlist() async {
    _view!.onProgressStart();

    super.currentPage = 1;

    wishlist = (await _service.getWishlist(
      page: super.currentPage.toString(),
    ))!;

    selectionList.clear();

    List.generate(wishlist.result?.data?.length ?? 0, (index) {
      selectionList.add(
        ItemSelect(wishlist.result?.data?[index].id ?? 0, false,),
      );
    });

    _view!.onProgressFinish();
    notifyListeners();
  }

  fnToggleSelection() {
    isSelection = !isSelection;
    notifyListeners();
  }

  fnOnChangedCkBox(bool value, int index) {
    selectionList[index].status = value;
    notifyListeners();
  }

  fnGetSelectionList() => List.generate(selectionList.length, (index) {
    if (selectionList[index].status == true) {
      idList.add(selectionList[index].id);
    }
  });

  Future fnDeleteMultiWishlist(BuildContext context) async {
    var _res = await _service.deleteWishlist(
        idList: this.idList
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        idList.clear();
        notifyListeners();
        await fnFetchWishlist();
        await CustomWidget.showSnackBar(
          context: context,
          content: Text(AppLocalizations.instance.text('TXT_WISHLIST_DELETE_SUCCESS')),
        );
      } else {
        await CustomWidget.showSnackBar(
          context: context,
          content: Text(_res.message.toString()),
        );
      }
    } else {
      await CustomWidget.showSnackBar(
        context: context,
        content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')),
      );
    }
  }

  Future fnDeleteWishlist(BuildContext context, int id) async {
    var _res = await _service.deleteWishlist(
        idList: [id]
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        await fnFetchWishlist();
        await CustomWidget.showSnackBar(
          context: context,
          content: Text(AppLocalizations.instance.text('TXT_WISHLIST_DELETE_SUCCESS')),
        );
      } else {
        await CustomWidget.showSnackBar(
          context: context,
          content: Text(_res.message.toString()),
        );
      }
    } else {
      await CustomWidget.showSnackBar(
        context: context,
        content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')),
      );
    }
  }

  Future fnStoreCart(BuildContext context, int? productId, int? regionId) async {
    var _res = await _cartService.storeCart(
      productIds: [productId ?? 0],
      regionIds: [regionId ?? 0],
    );

    if (_res!.status != null) {
      if (_res.status == true) {
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

  @override
  Future fnShowNextPage() async {
    onPaginationLoadStart();
    super.currentPage++;
    List<ItemSelect> _selectList = [];

    var _list = await _service.getWishlist(
      page: super.currentPage.toString(),
    );

    wishlist.result!.data!.addAll(_list!.result!.data!);

    List.generate(_list.result!.data!.length, (index) {
      _selectList.add(
        ItemSelect(_list.result!.data![index].id!, false,),
      );
    });

    selectionList.addAll(_selectList);

    if (_list.result!.data!.length == 0) {
      onPaginationLoadFinish();
    }
    notifyListeners();
  }

  @override
  void onPaginationLoadFinish() {
    isPaginateLoad = false;
    notifyListeners();
  }

  @override
  void onPaginationLoadStart() {
    isPaginateLoad = true;
    notifyListeners();
  }

}

class ItemSelect {
  final int id;
  bool status;

  ItemSelect(this.id, this.status);
}
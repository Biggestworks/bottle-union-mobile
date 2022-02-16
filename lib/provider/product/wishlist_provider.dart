import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/pagination_interface.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/model/product/user_wishlist_model.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/product/wishlist_service.dart';
import 'package:flutter/material.dart';

class WishListProvider extends ChangeNotifier with PaginationInterface {
  WishlistService _service = new WishlistService();
  UserWishlistModel wishlist = new UserWishlistModel();

  bool isPaginateLoad = false;
  bool isSelection = false;

  List<ItemSelect> selectionList = [];
  List<int> idList = [];

  LoadingView? _view;

  fnGetView(LoadingView view) {
    this._view = view;
  }

  Future fnFetchWishlist() async {
    _view!.onProgressStart();

    wishlist = (await _service.getWishlist(
      page: super.currentPage.toString(),
    ))!;

    selectionList.clear();

    List.generate(wishlist.result!.data!.length, (index) {
      selectionList.add(
        ItemSelect(wishlist.result!.data![index].id!, false,),
      );
    });

    _view!.onProgressFinish();
    notifyListeners();
  }

  fnToggleSelection() {
    isSelection = !isSelection;
    notifyListeners();
  }

  fnOnChangedCkBox(bool? value, int index) {
    selectionList[index].status = value!;
    notifyListeners();
  }

  Future fnDeleteWishlist(BuildContext context) async {
    List.generate(selectionList.length, (index) {
      if (selectionList[index].status == true) {
        idList.add(selectionList[index].id);
      }
    });

    if (idList.isNotEmpty) {
      CustomWidget.showConfirmationDialog(
        context,
        desc: AppLocalizations.instance.text('TXT_REMOVE_WISHLIST_INFO'),
        function: () async {
          var _res = await _service.deleteWishlist(
              idList: this.idList
          );

          if (_res!.status != null) {
            if (_res.status == true) {
              await fnFetchWishlist();
              CustomWidget.showSnackBar(
                context: context,
                content: Text(AppLocalizations.instance.text('TXT_WISHLIST_DELETE')),
              );
            } else {
              CustomWidget.showSnackBar(
                context: context,
                content: Text(_res.message.toString()),
              );
            }
          } else {
            CustomWidget.showSnackBar(
              context: context,
              content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')),
            );
          }
        },
      );
    } else {
      CustomWidget.showSnackBar(
        context: context,
        content: Text(AppLocalizations.instance.text('TXT_SELECT_ITEM_INFO')),
      );
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
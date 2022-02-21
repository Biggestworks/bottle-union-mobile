import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/pagination_interface.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/cart/cart_list_model.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/cart/cart_service.dart';
import 'package:flutter/material.dart';

class CartListProvider extends ChangeNotifier with PaginationInterface {
  CartService _service = new CartService();
  CartListModel cartList = new CartListModel();
  
  LoadingView? _view;

  bool isPaginateLoad = false;

  String totalPay = '0';
  int totalCart = 0;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }
  
  Future fnFetchCartList() async {
    _view!.onProgressStart();

    super.currentPage = 1;

    cartList = (await _service.cartList(
      page: super.currentPage.toString(),
    ))!;

    totalCart = cartList.result!.data!.where((i) => i.isSelected == 1).length;

    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnDeleteCart(BuildContext context, int id) async {
    CustomWidget.showConfirmationDialog(
      context,
      desc: AppLocalizations.instance.text('TXT_REMOVE_CART_INFO'),
      function: () async {
        var _res = await _service.deleteCart(
            idList: [id]
        );

        if (_res!.status != null) {
          if (_res.status == true) {
            cartList = (await _service.cartList())!;
            notifyListeners();
            await CustomWidget.showSnackBar(
              context: context,
              content: Text(AppLocalizations.instance.text('TXT_CART_DELETE_SUCCESS')),
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
      },
    );
    notifyListeners();
  }

  Future fnGetTotalPay() async {
    var _res = await _service.getTotalPayCart();
    if (_res!.status != null) {
      if (_res.status == true && _res.total != null) {
        totalPay = FormatterHelper.moneyFormatter(_res.total);
        totalCart = cartList.result!.data!.where((i) => i.isSelected == 1).length;
      }
    }
    notifyListeners();
  }

  Future fnSelectCart(int cartId, bool value) async {
    var _res = await _service.selectCart(cartId: cartId, isSelected: value);
    if (_res!.status != null) {
      if (_res.status == true) {
        cartList = (await _service.cartList())!;
        await fnGetTotalPay();
      }
    }
    notifyListeners();
  }

  Future fnUpdateCartQty(int cartId, String flag) async {
    var _res = await _service.updateCartQty(cartId: cartId, flag: flag);

    if (_res!.status != null) {
      if (_res.status == true) {
        cartList = (await _service.cartList())!;
        await fnGetTotalPay();
      }
    }
    notifyListeners();
  }

  @override
  Future fnShowNextPage() async {
    onPaginationLoadStart();
    super.currentPage++;

    var _carts = await _service.cartList(
      page: super.currentPage.toString(),
    );

    cartList.result!.data!.addAll(_carts!.result!.data!);

    if (_carts.result!.data!.length == 0) {
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
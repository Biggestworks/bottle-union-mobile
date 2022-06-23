import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/address/address_list_model.dart' as address;
import 'package:eight_barrels/model/cart/cart_total_model.dart';
import 'package:eight_barrels/model/checkout/courier_list_model.dart' as courier;
import 'package:eight_barrels/model/checkout/delivery_courier_model.dart';
import 'package:eight_barrels/model/checkout/order_summary_model.dart';
import 'package:eight_barrels/screen/checkout/delivery_cart_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/address/address_service.dart';
import 'package:eight_barrels/service/checkout/delivery_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class DeliveryCartProvider extends ChangeNotifier {
  DeliveryService _deliveryService = new DeliveryService();
  AddressService _addressService = new AddressService();
  TextEditingController searchController = new TextEditingController();

  address.AddressListModel addressList = new address.AddressListModel();
  address.Data? selectedAddress;
  CartTotalModel? cartList;
  OrderSummaryModel orderSummary = new OrderSummaryModel();
  courier.CourierListModel courierList = new courier.CourierListModel();

  List<int> _prices = [];
  double _totalWeight = 0;
  int? destination;
  List<DeliveryCourier> selectedCourierList = [];
  bool? isCart;
  int productQty = 1;

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  LoadingView? _view;

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as DeliveryCartScreen;
    cartList = _args.cartList;
    isCart = _args.isCart;
    notifyListeners();
  }

  Future fnFetchAddressList() async {
    _view!.onProgressStart();
    addressList = (await _addressService.getAddress(search: searchController.text))!;
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnFetchSelectedAddress() async {
    _view!.onProgressStart();
    await fnFetchAddressList();
    if (addressList.data != null && addressList.data?.length != 0) {
      selectedAddress = addressList.data!.firstWhere((item) => item.isChoosed == 1, orElse: null);
      destination = selectedAddress?.cityCode;
    }
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnOnSelectAddress(BuildContext context, int id) async {
    _view!.onProgressStart();
    var _res = (await _addressService.selectAddress(id: id))!;

    if (_res.status != null) {
      if (_res.status == true) {
        _view!.onProgressFinish();
        Get.back();
        await fnFetchSelectedAddress();
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message.toString()));
      }
    } else {
      _view!.onProgressFinish();
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
    _view!.onProgressFinish();
    notifyListeners();
  }

  fnGetSubtotal(int price, int qty) {
    return FormatterHelper.moneyFormatter((price * qty));
  }

  Future fnCalculateOrder() async {
    await Future.delayed(Duration.zero).then((value) {
      _prices.clear();
      _totalWeight = 0;
      List.generate(cartList?.result?.length ?? 0, (i) {
        var _data = cartList?.result?[i];
        List.generate(cartList?.result?[i].data?.length ?? 0, (j) {
          var _product = _data?.data?[j];
          int _regPrice = _product?.product?.regularPrice ?? 0;
          int _weight = _product?.product?.weight ?? 0;
          int _qty = _product?.qty ?? 0;
          int _itemPrices = _regPrice * _qty;
          _prices.add(_itemPrices);
          _totalWeight += _weight;
        });
      });
    });
    notifyListeners();
  }

  Future fnGetOrderSummary() async {
    List<int> _deliveryCostList = [];
    if (selectedCourierList.isNotEmpty) {
      List.generate(selectedCourierList.length,
              (index) => _deliveryCostList.add(selectedCourierList[index].courierData?.price ?? 0));
    }
    orderSummary = (await _deliveryService.getOrderSummary(
      itemPrices: _prices,
      deliveryCosts: _deliveryCostList,
    ))!;
    notifyListeners();
  }

  Future fnInitOrderSummary() async {
    await fnCalculateOrder().then((_) async => await fnGetOrderSummary());
    notifyListeners();
  }
  
  fnInitCourierList() {
    selectedCourierList.clear();
    if (cartList?.result != null) {
      List.generate(cartList?.result?.length ?? 0, (index) {
        selectedCourierList.add(DeliveryCourier(cartList?.result?[index].idRegion ?? 0, null));
      }) ;
    }
    notifyListeners();
  }

  Future fnFetchCourierList(int provinceId) async {
    print(provinceId);
    _view!.onProgressStart();
    courierList = (await _deliveryService.getCourierList(
      provinceId: provinceId,
      destination: destination ?? 0,
      weight: _totalWeight,
    ))!;
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnOnSelectCourier({required int regionId, required courier.Data value}) async {
    _view!.onProgressStart();
    Get.back();
    final _item = selectedCourierList.firstWhere((i) => i.regionId == regionId);
    _item.courierData = value;
    await fnGetOrderSummary();
    _view!.onProgressFinish();
    notifyListeners();
  }

}
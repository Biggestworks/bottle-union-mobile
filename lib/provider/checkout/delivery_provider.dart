import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/address/address_list_model.dart' as address;
import 'package:eight_barrels/model/cart/cart_total_model.dart';
import 'package:eight_barrels/model/checkout/courier_list_model.dart';
import 'package:eight_barrels/model/checkout/courier_select_model.dart' as courierSelect;
import 'package:eight_barrels/model/checkout/order_summary_model.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/screen/checkout/delivery_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/address/address_service.dart';
import 'package:eight_barrels/service/checkout/delivery_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class DeliveryProvider extends ChangeNotifier {
  DeliveryService _deliveryService = new DeliveryService();
  AddressService _addressService = new AddressService();
  TextEditingController searchController = new TextEditingController();

  address.AddressListModel addressList = new address.AddressListModel();
  address.Data? selectedAddress;
  ProductDetailModel? product;
  CartTotalModel? cartList;
  OrderSummaryModel orderSummary = new OrderSummaryModel();
  CourierListModel courierList = new CourierListModel();
  courierSelect.CourierSelectModel courierServiceList = new courierSelect.CourierSelectModel();

  List<int> _prices = [];
  double _totalWeight = 0;
  int? deliveryCost;
  String? destination;
  String? selectedCourier;
  courierSelect.Data? selectedCourierService;

  LoadingView? _view;

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as DeliveryScreen;
    product = _args.product;
    cartList = _args.cartList;
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
    if (addressList.data != null) {
      selectedAddress = addressList.data!.firstWhere((item) => item.isChoosed == 1, orElse: null);
      destination = selectedAddress?.cityCode.toString();
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
      if (cartList != null) {
        List.generate(cartList?.data?.length ?? 0, (index) {
          int _regPrice = cartList?.data?[index].product?.regularPrice ?? 0;
          int _qty = cartList?.data?[index].qty ?? 0;
          int _weight = cartList?.data?[index].product?.weight ?? 0;
          int _itemPrices = _regPrice * _qty;
          _prices.add(_itemPrices);
          _totalWeight += _weight;
        });
      } else {
        _prices.add(product?.data?.regularPrice ?? 0);
      }
    });
    notifyListeners();
  }

  Future fnGetOrderSummary() async {
    _view!.onProgressStart();
    orderSummary = (await _deliveryService.getOrderSummary(
      itemPrices: _prices,
      deliveryCost: this.deliveryCost,
    ))!;
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnInitOrderSummary() async {
    await fnCalculateOrder().then((_) async => await fnGetOrderSummary());
    notifyListeners();
  }

  Future fnFetchCourierList() async {
    _view!.onProgressStart();
    courierList = (await _deliveryService.getCourierList())!;
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnFetchCourierServiceList() async {
    _view!.onProgressStart();
    courierServiceList = (await _deliveryService.chooseCourier(
      destination: destination ?? '',
      weight: _totalWeight.toString(),
      courier: selectedCourier ?? '',
    ))!;
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnOnSelectCourier(String value) async {
    _view!.onProgressStart();
    Get.back();
    selectedCourier = value;
    await fnFetchCourierServiceList();
    if (courierServiceList.data != null) {
      selectedCourierService = courierServiceList.data?[0];
      deliveryCost = selectedCourierService?.price ?? 0;
      await fnGetOrderSummary();
    }
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnOnSelectCourierService(courierSelect.Data value) async {
    Get.back();
    selectedCourierService = value;
    deliveryCost = selectedCourierService?.price ?? 0;
    await fnGetOrderSummary();
    notifyListeners();
  }

}
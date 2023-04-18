import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/address/address_list_model.dart' as address;
import 'package:eight_barrels/model/checkout/courier_list_model.dart'
    as courier;
import 'package:eight_barrels/model/checkout/delivery_courier_model.dart';
import 'package:eight_barrels/model/checkout/order_summary_model.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/screen/checkout/delivery_buy_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/address/address_service.dart';
import 'package:eight_barrels/service/checkout/delivery_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class DeliveryBuyProvider extends ChangeNotifier {
  DeliveryService _deliveryService = new DeliveryService();
  AddressService _addressService = new AddressService();
  TextEditingController searchController = new TextEditingController();

  address.AddressListModel addressList = new address.AddressListModel();
  address.Data? selectedAddress;
  ProductDetailModel? product;
  OrderSummaryModel orderSummary = new OrderSummaryModel();
  courier.CourierListModel courierList = new courier.CourierListModel();

  List<int> _prices = [];
  double _totalWeight = 0;
  int? destination;
  DeliveryCourier? selectedCourier;
  bool? isCart;
  int? selectedRegionId;
  int? selectedProvinceId;

  int productQty = 1;

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args =
        ModalRoute.of(context)!.settings.arguments as DeliveryBuyScreen;
    product = _args.product;
    isCart = _args.isCart;
    selectedRegionId = _args.selectedRegionId;
    selectedProvinceId = _args.selectedProvinceId;
    notifyListeners();
  }

  Future fnFetchAddressList() async {
    _view!.onProgressStart();
    addressList =
        (await _addressService.getAddress(search: searchController.text))!;
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnFetchSelectedAddress() async {
    _view!.onProgressStart();
    await fnFetchAddressList();
    if (addressList.data != null && addressList.data?.length != 0) {
      selectedAddress = addressList.data!
          .firstWhere((item) => item.isChoosed == 1, orElse: null);
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
        await CustomWidget.showSnackBar(
            context: context, content: Text(_res.message.toString()));
      }
    } else {
      _view!.onProgressFinish();
      await CustomWidget.showSnackBar(
          context: context,
          content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
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
      int _price = product?.data?.salePrice ?? 0;
      _prices.add(_price * productQty);
      _totalWeight = ((product?.data?.weight ?? 0) * productQty).toDouble();
    });
    notifyListeners();
  }

  Future fnGetOrderSummary() async {
    int _deliveryCost = selectedCourier?.courierData?.price ?? 0;
    orderSummary = (await _deliveryService.getOrderSummary(
      itemPrices: _prices,
      deliveryCosts: [_deliveryCost],
    ))!;
    notifyListeners();
  }

  Future fnInitOrderSummary() async {
    await fnCalculateOrder().then((_) async => await fnGetOrderSummary());
    notifyListeners();
  }

  Future fnFetchCourierList() async {
    _view!.onProgressStart();

    courierList = (await _deliveryService.getCourierList(
      idRegion: selectedRegionId ?? 0,
      idAddress: selectedAddress != null ? selectedAddress!.id! : 0,
      destination: destination ?? 0,
      provinceId: int.parse(selectedAddress!.provinceCode.toString()),
      weight: _totalWeight,
    ))!;
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnOnSelectCourier({required courier.Data value}) async {
    _view!.onProgressStart();
    Get.back();
    selectedCourier = DeliveryCourier(selectedRegionId ?? 0, value);
    await fnGetOrderSummary();
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnUpdateProductQty(bool isIncrease) async {
    if (isIncrease) {
      productQty++;
      await fnInitOrderSummary();
    } else {
      if (productQty != 1) {
        productQty--;
        await fnInitOrderSummary();
      }
    }
    notifyListeners();
  }
}

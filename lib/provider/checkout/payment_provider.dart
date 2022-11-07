import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/model/checkout/delivery_courier_model.dart';
import 'package:eight_barrels/model/checkout/order_summary_model.dart'
    as summary;
import 'package:eight_barrels/model/checkout/payment_list_model.dart';
import 'package:eight_barrels/model/checkout/product_order_model.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart'
    as productDetail;
import 'package:eight_barrels/screen/checkout/order_finish_screen.dart';
import 'package:eight_barrels/screen/checkout/payment_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/checkout/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class PaymentProvider extends ChangeNotifier {
  PaymentService _service = new PaymentService();
  PaymentListModel paymentList = new PaymentListModel();

  Data? selectedPayment;
  summary.Data? orderSummary;
  int? addressId;
  productDetail.ProductDetailModel? product;
  int? productQty;
  List<DeliveryCourier> selectedCourierList = [];
  bool? isCart;
  ProductOrderModel productOrder = new ProductOrderModel();

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as PaymentScreen;
    orderSummary = _args.orderSummary;
    addressId = _args.addressId;
    product = _args.product;
    productQty = _args.productQty;
    selectedCourierList = _args.selectedCourierList ?? [];
    isCart = _args.isCart;
    notifyListeners();
  }

  Future fnFetchPaymentList() async {
    paymentList = (await _service.getPaymentMethodList())!;

    if (paymentList.data != null) {
      selectedPayment = paymentList.data?.first;
    }
    notifyListeners();
  }

  fnOnSelectPayment(Data value) {
    Get.back();
    selectedPayment = value;
    notifyListeners();
  }

  Future fnStoreOrderCart(BuildContext context) async {
    _view!.onProgressStart();

    await Future.delayed(Duration(seconds: 1));

    List<Map<String, dynamic>> _courierList = [];

    List.generate(
        selectedCourierList.length,
        (index) => _courierList.add({
              'id_region': selectedCourierList[index].regionId,
              'courier_name': selectedCourierList[index].courierData?.courier,
              'courier_desc':
                  selectedCourierList[index].courierData?.description,
              'courier_etd': selectedCourierList[index].courierData?.etd,
              'courier_cost': selectedCourierList[index].courierData?.price
            }));

    var _res = await _service.storeOrderCart(
      addressId: addressId,
      deliveries: _courierList,
      paymentMethod: selectedPayment?.name,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        _view!.onProgressFinish();
        Get.offNamedUntil(OrderFinishScreen.tag, (route) => route.isFirst,
            arguments: OrderFinishScreen(
              orderCart: _res,
            ));
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(
            context: context, content: Text(_res.message ?? '-'));
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

  Future fnStoreOrderBuyNow(BuildContext context) async {
    _view!.onProgressStart();

    await Future.delayed(Duration(seconds: 1));

    if (product != null) {
      productOrder = ProductOrderModel(
        idProduct: product?.data?.id,
        idRegion: selectedCourierList[0].regionId,
        qty: productQty,
      );
    }

    var _res = await _service.storeOrderBuyNow(
      addressId: addressId,
      product: productOrder,
      paymentMethod: selectedPayment?.name,
      courierName: selectedCourierList[0].courierData?.courier,
      courierDesc: selectedCourierList[0].courierData?.description,
      courierEtd: selectedCourierList[0].courierData?.etd,
      courierCost: selectedCourierList[0].courierData?.price,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        _view!.onProgressFinish();
        Get.offNamedUntil(OrderFinishScreen.tag, (route) => route.isFirst,
            arguments: OrderFinishScreen(
              orderNow: _res,
            ));
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(
            context: context, content: Text(_res.message ?? '-'));
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
}

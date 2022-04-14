import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/model/checkout/courier_list_model.dart' as courier;
import 'package:eight_barrels/model/checkout/order_summary_model.dart' as summary;
import 'package:eight_barrels/model/checkout/payment_list_model.dart';
import 'package:eight_barrels/model/checkout/product_order_model.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart' as productDetail;
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
  courier.Data? selectedCourier;
  bool? isCart;
  List<ProductOrderModel> productOrder = [];

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
    selectedCourier = _args.selectedCourier;
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

  Future fnStoreOrder(BuildContext context) async {
    _view!.onProgressStart();

    if (product != null) {
      productOrder.clear();
      productOrder.add(ProductOrderModel(
        idProduct: product?.data?.id,
        qty: productQty,
      ));
    }

    var _res = await _service.storeOrder(
      addressId: addressId,
      isCart: isCart,
      products: productOrder,
      paymentMethod: selectedPayment?.name,
      courierName: selectedCourier?.courier,
      courierDesc: selectedCourier?.description,
      courierEtd: selectedCourier?.etd,
      courierCost: selectedCourier?.price,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        _view!.onProgressFinish();
        Get.offNamedUntil(OrderFinishScreen.tag, (route) => route.isFirst, arguments: OrderFinishScreen(order: _res,));
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message ?? '-'));
      }
    } else {
      _view!.onProgressFinish();
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
    _view!.onProgressFinish();
    notifyListeners();
  }

}
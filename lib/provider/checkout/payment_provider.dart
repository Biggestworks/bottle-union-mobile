import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/model/checkout/delivery_courier_model.dart';
import 'package:eight_barrels/model/checkout/order_cart_model.dart'
    as orderCart;
import 'package:eight_barrels/model/checkout/order_now_model.dart' as order;
import 'package:eight_barrels/model/checkout/order_summary_model.dart'
    as summary;
import 'package:eight_barrels/model/checkout/payment_list_model.dart';
import 'package:eight_barrels/model/checkout/product_order_model.dart';
import 'package:eight_barrels/model/checkout/xendit_token_id.dart';
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

  order.OrderNowModel? orderNowModel;
  orderCart.OrderCartModel? orderCartModel;

  /// CC ENV
  String? tokenId;
  String? amount;
  String? cvn;
  String? authenticationId;
  String? webViewUrl;

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

    if (selectedPayment!.name == "credit-card" ||
        selectedPayment?.name == "CREDIT") {
      var _auth = await _service.fetchCreditCardAuthorizationId(
          amount: orderSummary!.totalPay.toString(),
          cvn: cvn.toString(),
          tokenId: tokenId.toString());

      print(_auth);

      webViewUrl = _auth['data']['payer_authentication_url'];
      authenticationId = _auth['data']['id'];
    } else if (selectedPayment!.name.toString().contains("dana")) {
      var _res = await _service.purchaseEwalletCart(
          idAddress: addressId.toString(),
          deliveries: _courierList,
          payment_method: "${selectedPayment?.name}",
          channel_code: "${selectedPayment?.name}",
          phone: '');

      if (_res['status']) {
        orderCartModel = orderCart.OrderCartModel.fromJson(_res);

        print(_res['result_dana']['actions']['mobile_web_checkout_url']
            .toString());
        webViewUrl = _res['result_dana']['actions']['mobile_web_checkout_url']
            .toString();
        notifyListeners();
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(
            context: context,
            content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
      }
    } else if (selectedPayment?.name == "shopee-pay") {
      var _res = await _service.purchaseEwalletCart(
          idAddress: addressId.toString(),
          deliveries: _courierList,
          payment_method: "${selectedPayment?.name}",
          channel_code: "${selectedPayment?.name}",
          phone: '');

      print(_res);

      if (_res['status']) {
        orderCartModel = orderCart.OrderCartModel.fromJson(_res);

        webViewUrl = _res['result_shopee']['actions']
                ['mobile_deeplink_checkout_url']
            .toString();
        notifyListeners();
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(
            context: context,
            content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
      }
    } else {
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
    }

    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnStoreOrderBuyNowCreditCard(context) async {
    var _res = await _service.storeOrderBuyNowCreditCard(
      addressId: addressId,
      product: productOrder,
      paymentMethod: 'credit-card',
      courierName: selectedCourierList[0].courierData?.courier,
      courierDesc: selectedCourierList[0].courierData?.description,
      courierEtd: selectedCourierList[0].courierData?.etd,
      courierCost: selectedCourierList[0].courierData?.price,
      tokenId: tokenId.toString(),
      authenticationId: authenticationId.toString(),
      card_cvn: cvn.toString(),
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        authenticationId = null;
        tokenId = null;
        cvn = null;
        notifyListeners();
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

    if (selectedPayment?.name == "credit-card" ||
        selectedPayment?.name == "CREDIT") {
      var _auth = await _service.fetchCreditCardAuthorizationId(
          amount: orderSummary!.totalPay.toString(),
          cvn: cvn.toString(),
          tokenId: tokenId.toString());

      webViewUrl = _auth['data']['payer_authentication_url'];
      authenticationId = _auth['data']['id'];
    } else if (selectedPayment?.name == "dana") {
      var res = await _service.purchaseEwallet(
          idAddress: addressId.toString(),
          product: productOrder,
          payment_method: "${selectedPayment?.name}",
          courier_name: "${selectedCourierList[0].courierData?.courier}",
          courier_desc: "${selectedCourierList[0].courierData?.description}",
          courier_etd: "${selectedCourierList[0].courierData?.etd}",
          courier_cost:
              int.parse("${selectedCourierList[0].courierData?.price}"),
          channel_code: "${selectedPayment?.name}",
          phone: "");

      orderNowModel = order.OrderNowModel.fromJson(res);

      webViewUrl =
          res['result_dana']['actions']['mobile_web_checkout_url'].toString();
      notifyListeners();
    } else if (selectedPayment?.name == "shopee-pay") {
      var res = await _service.purchaseEwallet(
          idAddress: addressId.toString(),
          product: productOrder,
          payment_method: "${selectedPayment?.name}",
          courier_name: "${selectedCourierList[0].courierData?.courier}",
          courier_desc: "${selectedCourierList[0].courierData?.description}",
          courier_etd: "${selectedCourierList[0].courierData?.etd}",
          courier_cost:
              int.parse("${selectedCourierList[0].courierData?.price}"),
          channel_code: "${selectedPayment?.name}",
          phone: "");

      orderNowModel = order.OrderNowModel.fromJson(res);

      webViewUrl = res['result_shopee']['actions']
              ['mobile_deeplink_checkout_url']
          .toString();
      notifyListeners();
    } else {
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
    }

    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnStoreOrderCreditCardChart(context) async {
    _view!.onProgressStart();

    await Future.delayed(Duration(seconds: 1));

    if (product != null) {
      productOrder = ProductOrderModel(
        idProduct: product?.data?.id,
        idRegion: selectedCourierList[0].regionId,
        qty: productQty,
      );
    }

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

    var _res = await _service.storeOrderCreditCardCart(
      addressId: addressId,
      deliveries: _courierList,
      paymentMethod: 'credit-card',
      authenticationId: authenticationId.toString(),
      cvn: cvn.toString(),
      tokenId: tokenId.toString(),
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        authenticationId = null;
        tokenId = null;
        cvn = null;
        notifyListeners();
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

  fnFetchXenditTokenId(
    BuildContext context, {
    required String card_number,
    required String expiry_month,
    required String expiry_year,
    required String cvv,
  }) async {
    try {
      Get.back();
      _view!.onProgressStart();

      final response = await _service.fetchCreditCardTokenId(
          cardNumber: card_number,
          expiryMonth: expiry_month,
          expiryYear: expiry_year,
          cvv: cvv);

      print(response);

      if (!response['status']) {
        await CustomWidget.showSnackBar(
            context: context, content: Text('Failure'));
      }
      print(response);

      var data = XenditTokenId.fromJson(response);

      tokenId = data.data.card.cardInformation.tokenId;
      cvn = cvv;

      selectedPayment = Data(
        id: 10,
        name: data.data.card.cardInformation.type,
        description: data.data.card.cardInformation.network +
            ' ' +
            data.data.card.cardInformation.issuer +
            ' ' +
            data.data.card.cardInformation.cardholderName,
      );
      notifyListeners();

      _view!.onProgressFinish();
    } catch (e) {
      print(e);
      await CustomWidget.showSnackBar(
          context: context, content: Text('Failed to validate credit card.'));
      _view!.onProgressFinish();
    }
  }

  fnEwalletOrderNow(
    context, {
    required String phone_number,
  }) async {
    _view!.onProgressStart();

    await Future.delayed(Duration(seconds: 1));

    if (product != null) {
      productOrder = ProductOrderModel(
        idProduct: product?.data?.id,
        idRegion: selectedCourierList[0].regionId,
        qty: productQty,
      );
    }

    var _res = await _service.purchaseEwallet(
        idAddress: "$addressId",
        product: productOrder,
        payment_method: "${selectedPayment?.name}",
        courier_name: "${selectedCourierList[0].courierData?.courier}",
        courier_desc: "${selectedCourierList[0].courierData?.description}",
        courier_etd: "${selectedCourierList[0].courierData?.etd}",
        courier_cost: int.parse("${selectedCourierList[0].courierData?.price}"),
        channel_code: "${selectedPayment?.name}",
        phone: phone_number);

    if (_res['status'] != null) {
      if (_res['status'] == true) {
        print(_res);
        _view!.onProgressFinish();
        Get.offNamedUntil(OrderFinishScreen.tag, (route) => route.isFirst,
            arguments: OrderFinishScreen(
              orderNow: order.OrderNowModel.fromJson(_res),
            ));
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(
            context: context, content: Text(_res['message'] ?? '-'));
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

  fnEwalletOrderCart(
    context, {
    required String phone,
  }) async {
    _view!.onProgressStart();

    await Future.delayed(Duration(seconds: 1));

    List<Map<String, dynamic>> _courierList = [];

    List.generate(
      selectedCourierList.length,
      (index) => _courierList.add(
        {
          'id_region': selectedCourierList[index].regionId,
          'courier_name': selectedCourierList[index].courierData?.courier,
          'courier_desc': selectedCourierList[index].courierData?.description,
          'courier_etd': selectedCourierList[index].courierData?.etd,
          'courier_cost': selectedCourierList[index].courierData?.price
        },
      ),
    );

    var _res = await _service.purchaseEwalletCart(
      idAddress: addressId.toString(),
      deliveries: _courierList,
      payment_method: "${selectedPayment?.name}",
      channel_code: "${selectedPayment?.name}",
      phone: phone,
    );

    print(_res);

    if (_res['status'] != null) {
      if (_res['status'] == true) {
        _view!.onProgressFinish();
        Get.offNamedUntil(OrderFinishScreen.tag, (route) => route.isFirst,
            arguments: OrderFinishScreen(
              orderCart: orderCart.OrderCartModel.fromJson(_res),
            ));
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(
            context: context, content: Text(_res['message'] ?? '-'));
      }
    } else {
      _view!.onProgressFinish();
      await CustomWidget.showSnackBar(
          context: context,
          content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
  }

  fnWebViewOtpVerified(context) {
    _view!.onProgressStart();
    webViewUrl = null;
    if (product != null) {
      fnStoreOrderBuyNowCreditCard(context);
    } else {
      fnStoreOrderCreditCardChart(context);
    }
  }

  fnDataPaymentVerified(context) {
    _view!.onProgressStart();

    webViewUrl = null;

    Get.offNamedUntil(OrderFinishScreen.tag, (route) => route.isFirst,
        arguments: OrderFinishScreen(
          orderNow: orderNowModel,
          orderCart: orderCartModel,
        ));
    notifyListeners();
    _view!.onProgressFinish();
  }
}

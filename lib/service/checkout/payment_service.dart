import 'dart:convert';

import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/checkout/midtrans_payment_model.dart';
import 'package:eight_barrels/model/checkout/order_cart_model.dart';
import 'package:eight_barrels/model/checkout/order_now_model.dart';
import 'package:eight_barrels/model/checkout/payment_list_model.dart';
import 'package:eight_barrels/model/checkout/product_order_model.dart';
import 'package:get/get_connect.dart';
import 'package:http/http.dart' as http;

class PaymentService extends GetConnect {
  UserPreferences _userPreferences = new UserPreferences();

  Future<Map<String, String>?> _headersAuth() async {
    var _token = await _userPreferences.getUserToken();

    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  Future<PaymentListModel?> getPaymentMethodList() async {
    PaymentListModel _model = new PaymentListModel();

    try {
      Response _response = await get(
        URLHelper.paymentMethodUrl,
        headers: await _headersAuth(),
      );
      _model = PaymentListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<OrderCartModel?> storeOrderCart({
    required int? addressId,
    required List<Map<String,dynamic>> deliveries,
    required String? paymentMethod,
  }) async {
    OrderCartModel _model = new OrderCartModel();


    final Map<String, dynamic> _data = {
      "id_address": addressId,
      "deliveries": deliveries,
      "payment_method": paymentMethod,
    };

    try {
      http.Response _response = await http.post(
        Uri.parse(URLHelper.storeOrderCartUrl),
        body: json.encode(_data),
        headers: await _headersAuth(),
      );
      ///GET CONNECT BUG
      // Response _response = await post(
      //   URLHelper.storeOrderUrl,
      //   _data,
      //   headers: await _headersAuth(),
      // );
      _model = OrderCartModel.fromJson(json.decode(_response.body));
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<OrderNowModel?> storeOrderBuyNow({
    required int? addressId,
    required ProductOrderModel? product,
    required String? paymentMethod,
    required String? courierName,
    required String? courierDesc,
    required String? courierEtd,
    required int? courierCost,
  }) async {
    OrderNowModel _model = new OrderNowModel();

    final Map<String, dynamic> _data = {
      "id_address": addressId,
      "products": product?.toJson(),
      "payment_method": paymentMethod,
      "courier_name": courierName,
      "courier_desc": courierDesc,
      "courier_etd": courierEtd,
      "courier_cost": courierCost
    };

    print(_data.entries);

    try {
      http.Response _response = await http.post(
        Uri.parse(URLHelper.storeOrderNowUrl),
        body: json.encode(_data),
        headers: await _headersAuth(),
      );
      ///GET CONNECT BUG
      // Response _response = await post(
      //   URLHelper.storeOrderUrl,
      //   _data,
      //   headers: await _headersAuth(),
      // );
      print(_response.body);
      _model = OrderNowModel.fromJson(json.decode(_response.body));
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<MidtransPaymentModel?> midtransPayment({
    required String? code,
  }) async {
    MidtransPaymentModel _model = new MidtransPaymentModel();

    final Map<String, dynamic> _data = {
      "code_transaction": code,
    };

    try {
      Response _response = await post(
        URLHelper.midtransPaymentUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = MidtransPaymentModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

}
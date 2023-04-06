// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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
    required List<Map<String, dynamic>> deliveries,
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

      print(URLHelper.storeOrderCartUrl);

      print(_response.body);

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

  Future<OrderCartModel?> storeOrderCreditCardCart({
    required int? addressId,
    required List<Map<String, dynamic>> deliveries,
    required String tokenId,
    required String authenticationId,
    required String? paymentMethod,
    required String cvn,
  }) async {
    OrderCartModel _model = new OrderCartModel();

    final Map<String, dynamic> _data = {
      "id_address": addressId,
      "deliveries": deliveries,
      "payment_method": paymentMethod,
      "token_id": tokenId,
      "authentication_id": authenticationId,
      "card_cvn": '123',
    };

    try {
      http.Response _response = await http.post(
        Uri.parse(URLHelper.storeOrderCartUrl),
        body: json.encode(_data),
        headers: await _headersAuth(),
      );

      print(_data);

      print(_response.body);

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

    // final test = await _headersAuth();
    // log(test.toString());

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
      log(_response.body.toString());
      _model = OrderNowModel.fromJson(json.decode(_response.body));
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<OrderNowModel?> storeOrderBuyNowCreditCard({
    required int? addressId,
    required ProductOrderModel? product,
    required String? paymentMethod,
    required String? courierName,
    required String? courierDesc,
    required String? courierEtd,
    required int? courierCost,
    required String tokenId,
    required String authenticationId,
    required String card_cvn,
  }) async {
    OrderNowModel _model = new OrderNowModel();

    final Map<String, dynamic> _data = {
      "id_address": addressId,
      "products": product?.toJson(),
      "payment_method": paymentMethod,
      "courier_name": courierName,
      "courier_desc": courierDesc,
      "courier_etd": courierEtd,
      "courier_cost": courierCost,
      "token_id": tokenId,
      "authentication_id": authenticationId,
      "card_cvn": card_cvn
    };

    print(json.encode(_data));

    // final test = await _headersAuth();
    // log(test.toString());

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
      log(_response.body.toString());
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

  Future<Map<String, dynamic>> fetchCreditCardTokenId({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  }) async {
    try {
      var _token = await _userPreferences.getUserToken();
      final Map<String, dynamic> payload = {
        "card_number": cardNumber,
        "expiry_month": expiryMonth,
        "expiry_year": expiryYear,
        "cvv": cvv,
      };

      final response = await http.post(
        Uri.parse(URLHelper.tokenIdUrl),
        headers: await _headersAuth(),
        body: json.encode(payload),
      );

      print(response.body);

      return json.decode(response.body);
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchCreditCardMultipleUse({
    required String cardNumber,
    required String expYear,
    required String expMonth,
    required String cvv,
    required String holderName,
  }) async {
    try {
      final response = await http.post(Uri.parse(URLHelper.ccMultipleUrl),
          headers: await _headersAuth(),
          body: json.encode({
            "card_number": cardNumber,
            "exp_year": expYear,
            "exp_month": expMonth,
            "cvv": cvv,
            "holder_name": holderName
          }));

      return json.decode(response.body) as Map<String, dynamic>;
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchCreditCardAuthorizationId({
    required String amount,
    required String cvn,
    required String tokenId,
  }) async {
    try {
      final response = await http.post(Uri.parse(URLHelper.authorizationIdUrl),
          headers: await _headersAuth(),
          body: json.encode({
            "amount": amount,
            "card_cvn": cvn,
            "currency": "IDR",
            "token_id": tokenId,
          }));

      print(response.body);
      return json.decode(response.body) as Map<String, dynamic>;
    } on SocketException {
      print('exception');
      rethrow;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> purchaseEwallet({
    required String idAddress,
    required ProductOrderModel product,
    required String payment_method,
    required String courier_name,
    required String courier_etd,
    required String courier_desc,
    required int courier_cost,
    required String channel_code,
    required String phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(URLHelper.storeOrderNowUrl),
        headers: await _headersAuth(),
        body: json.encode({
          "id_address": idAddress,
          "products": product.toJson(),
          "payment_method": payment_method,
          "courier_name": courier_name,
          "courier_desc": courier_desc,
          "courier_etd": courier_etd,
          "courier_cost": courier_cost,
          "channel_code": channel_code,
          "phone": phone.toString()
        }),
      );

      return json.decode(response.body);
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> purchaseEwalletCart({
    required String idAddress,
    required List<Map<String, dynamic>> deliveries,
    required String payment_method,
    required String channel_code,
    required String phone,
  }) async {
    try {
      print(URLHelper.storeOrderCartUrl);
      final response = await http.post(
        Uri.parse(URLHelper.storeOrderCartUrl),
        headers: await _headersAuth(),
        body: json.encode({
          "deliveries": deliveries,
          "id_address": idAddress,
          "payment_method": payment_method,
          "channel_code": channel_code,
          "phone": phone.toString()
        }),
      );

      return json.decode(response.body);
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}

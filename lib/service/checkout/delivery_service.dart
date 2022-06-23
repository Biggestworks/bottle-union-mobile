import 'dart:async';
import 'dart:convert';

import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/checkout/courier_list_model.dart';
import 'package:eight_barrels/model/checkout/order_summary_model.dart';
import 'package:get/get_connect.dart';
import 'package:http/http.dart' as http;

class DeliveryService extends GetConnect {
  UserPreferences _userPreferences = new UserPreferences();

  Future<Map<String, String>?> _headersAuth() async {
    var _token = await _userPreferences.getUserToken();

    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  Future<OrderSummaryModel?> getOrderSummary({
    required List<int> itemPrices,
    required List<int> deliveryCosts,
  }) async {
    OrderSummaryModel _model = new OrderSummaryModel();

    final Map<String, dynamic> _data = {
      "item_price": itemPrices,
      "delivery_cost": deliveryCosts,
    };

    try {
      Response _response = await post(
        URLHelper.orderSummaryUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = OrderSummaryModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<CourierListModel?> getCourierList({
    required int provinceId,
    required int destination,
    required double weight,
  }) async {
    CourierListModel _model = new CourierListModel();

    final Map<String, dynamic> _data = {
      "id_province": provinceId.toString(),
      "destination": destination.toString(),
      "weight": weight
    };

    print(_data.entries);

    try {
      http.Response _response = await http.post(
        Uri.parse(URLHelper.chooseCourierUrl),
        body: json.encode(_data),
        headers: await _headersAuth(),
      );
      print(_response.body);
      _model = CourierListModel.fromJson(json.decode(_response.body));
      ///GET CONNECT BUG
      // Response _response = await post(
      //   URLHelper.chooseCourierUrl,
      //   _data,
      //   headers: await _headersAuth(),
      // );
      // _model = CourierListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

}
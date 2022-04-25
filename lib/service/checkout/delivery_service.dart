import 'dart:async';

import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/checkout/courier_list_model.dart';
import 'package:eight_barrels/model/checkout/order_summary_model.dart';
import 'package:get/get_connect.dart';

class DeliveryService extends GetConnect {
  UserPreferences _userPreferences = new UserPreferences();

  Future<Map<String, String>?> _headersAuth() async {
    var _token = await _userPreferences.getUserToken();

    return {
      "Accept": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  Future<OrderSummaryModel?> getOrderSummary({
    required List<int> itemPrices,
    int? deliveryCost,
  }) async {
    OrderSummaryModel _model = new OrderSummaryModel();

    final Map<String, dynamic> _data = {
      "item_price": itemPrices,
      "delivery_cost": deliveryCost,
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
    required String destination,
    required double weight,
  }) async {
    CourierListModel _model = new CourierListModel();

    final Map<String, dynamic> _data = {
      "destination": destination,
      "weight": weight
    };

    try {
      Response _response = await post(
        URLHelper.chooseCourierUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = CourierListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

}
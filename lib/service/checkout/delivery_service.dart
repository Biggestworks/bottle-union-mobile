import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/model/checkout/courier_list_model.dart';
import 'package:eight_barrels/model/checkout/courier_select_model.dart';
import 'package:eight_barrels/model/checkout/order_summary_model.dart';
import 'package:get/get_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryService extends GetConnect {

  Future<Map<String, String>?> _headersAuth() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _token = _prefs.getString(KeyHelper.KEY_TOKEN);

    return {
      "Accept": "application/json",
      "User-Agent": "Persada Apps 1.0",
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
        URLHelper.ORDER_SUMMARY_URL,
        _data,
        headers: await _headersAuth(),
      );
      _model = OrderSummaryModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<CourierListModel?> getCourierList() async {
    CourierListModel _model = new CourierListModel();

    try {
      Response _response = await get(
        URLHelper.COURIER_URL,
        headers: await _headersAuth(),
      );
      _model = CourierListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<CourierSelectModel?> chooseCourier({
    required String destination,
    required String weight,
    required String courier,
  }) async {
    CourierSelectModel _model = new CourierSelectModel();

    final Map<String, dynamic> _data = {
      "destination": destination,
      "weight": weight,
      "courier": courier
    };

    try {
      Response _response = await post(
        URLHelper.CHOOSE_COURIER_URL,
        _data,
        headers: await _headersAuth(),
      );
      _model = CourierSelectModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

}
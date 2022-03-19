import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/model/checkout/payment_list_model.dart';
import 'package:get/get_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService extends GetConnect {

  Future<Map<String, String>?> _headersAuth() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _token = _prefs.getString(KeyHelper.KEY_TOKEN);

    return {
      "Accept": "application/json",
      "User-Agent": "Persada Apps 1.0",
      "Authorization": "Bearer $_token",
    };
  }

  Future<PaymentListModel?> getPaymentMethodList() async {
    PaymentListModel _model = new PaymentListModel();

    try {
      Response _response = await get(
        URLHelper.PAYMENT_METHOD_URL,
        headers: await _headersAuth(),
      );
      _model = PaymentListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }
}
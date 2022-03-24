import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/model/checkout/midtrans_payment_model.dart';
import 'package:eight_barrels/model/checkout/order_model.dart';
import 'package:eight_barrels/model/checkout/payment_list_model.dart';
import 'package:eight_barrels/model/checkout/product_order_model.dart';
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

  Future<OrderModel?> storeOrder({
    required int? addressId,
    required bool? isCart,
    List<ProductOrderModel>? products,
    required String? paymentMethod,
    required String? courierName,
    required String? courierDesc,
    required String? courierEtd,
    required int? courierCost,
  }) async {
    OrderModel _model = new OrderModel();

    final Map<String, dynamic> _data = {
      "id_address": addressId,
      "is_cart": isCart,
      "products": products,
      "payment_method": paymentMethod,
      "courier_name": courierName,
      "courier_desc": courierDesc,
      "courier_etd": courierEtd,
      "courier_cost": courierCost
    };

    try {
      Response _response = await post(
        URLHelper.STORE_ORDER_URL,
        _data,
        headers: await _headersAuth(),
      );
      _model = OrderModel.fromJson(_response.body);
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
        URLHelper.MIDTRANS_PAYMENT_URL,
        _data,
        headers: await _headersAuth(),
      );
      print(_response.body);
      _model = MidtransPaymentModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

}
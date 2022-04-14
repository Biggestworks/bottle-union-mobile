import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/model/transaction/transaction_detail_model.dart';
import 'package:eight_barrels/model/transaction/transaction_list_dart.dart';
import 'package:get/get_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionService extends GetConnect {

  Future<Map<String, String>?> _headersAuth() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _token = _prefs.getString(KeyHelper.KEY_TOKEN);

    return {
      "Accept": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  Future<TransactionListModel?> getTransactionList({
    String? startDate,
    String? endDate,
    required int? status,
    required String? page,
  }) async {
    TransactionListModel _model = new TransactionListModel();

    final Map<String, dynamic> _data = {
      "start_date_buy": startDate ?? null,
      "end_date_buy": endDate ?? null,
      "status_transaction": status,
      "page": page,
      "per_page": 6,
    };

    try {
      Response _response = await post(
        URLHelper.TRANSACTION_URL,
        _data,
        headers: await _headersAuth(),
      );
      _model = TransactionListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<TransactionDetailModel?> getTransactionDetail({required String orderId}) async {
    TransactionDetailModel _model = new TransactionDetailModel();

    try {
      Response _response = await get(
        URLHelper.transactionDetailUrl(orderId),
        headers: await _headersAuth(),
      );
      _model = TransactionDetailModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }
}
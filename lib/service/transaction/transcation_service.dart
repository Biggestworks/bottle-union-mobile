import 'dart:io';

import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/model/transaction/track_order_model.dart';
import 'package:eight_barrels/model/transaction/transaction_detail_model.dart';
import 'package:eight_barrels/model/transaction/transaction_list_dart.dart';
import 'package:eight_barrels/model/transaction/upload_payment_model.dart';
import 'package:get/get_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

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

  Future<UploadPaymentModel?> uploadPayment({
    required String orderId,
    required File image,
  }) async {
    UploadPaymentModel _model = new UploadPaymentModel();
    MultipartFile? _imageFile;

    try {
      _imageFile = MultipartFile(
        image.path,
        filename: basename(image.path),
        contentType: MediaType(
          "image",
          basename(image.path),
        ).type,
      );

      FormData _data = new FormData({
        "code_transaction": orderId,
        "image": _imageFile
      });

      Response _response = await post(
        URLHelper.UPLOAD_PAYMENT_URL,
        _data,
        headers: await _headersAuth(),
      );
      _model = UploadPaymentModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<TrackOrderModel?> getTrackOrder({required String? orderId}) async {
    TrackOrderModel _model = new TrackOrderModel();

    try {
      Response _response = await get(
        URLHelper.trackOrderUrl(orderId ?? ''),
        headers: await _headersAuth(),
      );
      _model = TrackOrderModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

}
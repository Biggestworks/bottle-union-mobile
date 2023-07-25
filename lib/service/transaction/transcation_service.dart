import 'dart:convert';
import 'dart:io';

import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/default_model.dart';
import 'package:eight_barrels/model/transaction/track_order_model.dart';
import 'package:eight_barrels/model/transaction/transaction_detail_model.dart';
import 'package:eight_barrels/model/transaction/transaction_list_model.dart';
import 'package:eight_barrels/model/transaction/upload_payment_model.dart';
import 'package:get/get_connect.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class TransactionService extends GetConnect {
  UserPreferences _userPreferences = new UserPreferences();

  Future<Map<String, String>?> _headersAuth() async {
    var _token = await _userPreferences.getUserToken();

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
    TransactionListModel _model;

    final Map<String, dynamic> _data = {
      "start_date_buy": startDate ?? null,
      "end_date_buy": endDate ?? null,
      "status_transaction": status,
      "page": page,
      "per_page": 6,
    };

    try {
      Response _response = await post(
        URLHelper.transactionUrl,
        _data,
        headers: await _headersAuth(),
      );

      // print(json.encode(_data));
      // print(URLHelper.transactionUrl);
      // print(await _headersAuth());

      print(_response.body);

      return TransactionListModel.fromJson(_response.body);
    } catch (e) {
      rethrow;
    }

    // return _model;
  }

  Future<TransactionDetailModel?> getTransactionDetail(
      {required String orderId, required int regionId}) async {
    TransactionDetailModel _model = new TransactionDetailModel();

    final Map<String, dynamic> _data = {
      "code_transaction": orderId,
      "id_region": regionId,
    };

    try {
      Response _response = await post(
        URLHelper.transactionDetailUrl,
        _data,
        headers: await _headersAuth(),
      );

      print(_response.body);

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

      FormData _data =
          new FormData({"code_transaction": orderId, "image": _imageFile});

      Response _response = await post(
        URLHelper.uploadPaymentUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = UploadPaymentModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<TrackOrderModel?> getTrackOrder(
      {required String? orderId, required int? regionId}) async {
    TrackOrderModel _model = new TrackOrderModel();

    final Map<String, dynamic> _data = {
      "code_transaction": orderId,
      "id_region": regionId,
    };

    try {
      Response _response = await post(
        URLHelper.trackOrderUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = TrackOrderModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<DefaultModel?> finishOrder(
      {required String? orderId, required int? regionId}) async {
    DefaultModel _model = new DefaultModel();

    final Map<String, dynamic> _data = {
      "code_transaction": orderId,
      "id_region": regionId
    };

    try {
      Response _response = await post(
        URLHelper.finishOrderUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = DefaultModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }
}

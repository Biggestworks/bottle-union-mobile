import 'package:eight_barrels/service/log/log_service.dart';

abstract class ProductLog {
  LogService _service = new LogService();

  Future fnStoreLog({
    required List<int>? productId,
    required int? categoryId,
    required String? notes,
}) async =>
      await _service.storeLog(productId: productId, categoryId: categoryId, notes: notes,);
}
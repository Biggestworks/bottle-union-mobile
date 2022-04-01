import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/url_helper.dart';
import 'package:get/get_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogService extends GetConnect {

  Future<Map<String, String>?> _headersAuth() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _token = _prefs.getString(KeyHelper.KEY_TOKEN);

    return {
      "Accept": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  Future storeLog({
    required List<int>? productId,
    required int? categoryId,
    required String? notes,
  }) async {

    final Map<String, dynamic> _data = {
      "id_product": productId,
      "id_category": categoryId,
      "from_device": "mobile",
      "notes": notes
    };

    try {
      Response _response = await post(
        URLHelper.PRODUCT_LOG,
        _data,
        headers: await _headersAuth(),
      );
      print(_response.body);
    } catch (e) {
      print(e);
    }
  }

}
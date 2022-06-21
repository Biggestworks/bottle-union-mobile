import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:get/get_connect.dart';

class LogService extends GetConnect {
  UserPreferences _userPreferences = new UserPreferences();

  Future<Map<String, String>?> _headersAuth() async {
    var _token = await _userPreferences.getUserToken();

    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
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
        URLHelper.productLogUrl,
        _data,
        headers: await _headersAuth(),
      );
    } catch (e) {
      print(e);
    }
  }

}
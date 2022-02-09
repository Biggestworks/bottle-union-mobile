import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/product/product_model.dart';
import 'package:get/get_connect.dart';

class ProductService extends GetConnect {
  UserPreferences? _userPreferences = new UserPreferences();

  Future<Map<String, String>?> _headersAuth() async {
    var _user = await _userPreferences?.getUserData();
    var _token = _user?.token;

    return {
      "Accept": "application/json",
      "User-Agent": "Persada Apps 1.0",
      "Authorization": "Bearer $_token",
    };
  }

  Future<ProductListModel?> productList() async {
    ProductListModel _product = new ProductListModel();

    try {
      Response _response = await get(
        URLHelper.PRODUCT_LIST_URL,
        headers: await _headersAuth(),
      );
      print(_response.body);
      _product = ProductListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _product;
  }
}
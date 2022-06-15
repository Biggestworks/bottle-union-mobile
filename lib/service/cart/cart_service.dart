import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/cart/cart_list_model.dart';
import 'package:eight_barrels/model/cart/cart_model.dart';
import 'package:eight_barrels/model/cart/cart_total_model.dart';
import 'package:eight_barrels/model/default_model.dart';
import 'package:get/get_connect.dart';

class CartService extends GetConnect {
  UserPreferences _userPreferences = new UserPreferences();

  Future<Map<String, String>?> _headersAuth() async {
    var _token = await _userPreferences.getUserToken();

    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  Future<CartListModel?> cartList({
    String? page,
  }) async {
    CartListModel _model = new CartListModel();

    final Map<String, dynamic> _query = {
      "page": page ?? '1',
      "per_page": '6',
    };

    try {
      Response _response = await get(
        URLHelper.cartUrl,
        query: _query,
        headers: await _headersAuth(),
      );
      _model = CartListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<CartModel?> storeCart({
    required List<int> productIds,
    required List<int> regionIds,
  }) async {
    CartModel _model = new CartModel();

    final Map<String, dynamic> _data = {
      "id_product": productIds,
      "id_region": regionIds
    };

    try {
      Response _response = await post(
        URLHelper.cartUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = CartModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<DefaultModel?> deleteCart({required List<int> idList}) async {
    DefaultModel _model = new DefaultModel();

    final Map<String, dynamic> _data = {
      "id": idList,
    };

    try {
      Response _response = await post(
        URLHelper.deleteCartUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = DefaultModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<CartModel?> updateCartQty({
    required int cartId,
    required String flag,
  }) async {
    CartModel _model = new CartModel();

    final Map<String, dynamic> _data = {
      "cart_id": cartId,
      "flag": flag,
    };

    try {
      Response _response = await post(
        URLHelper.updateCartQtyUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = CartModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<CartTotalModel?> getTotalPayCart() async {
    CartTotalModel _model = new CartTotalModel();

    try {
      Response _response = await get(
        URLHelper.totalCartUrl,
        headers: await _headersAuth(),
      );
      _model = CartTotalModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<DefaultModel?> selectCart({
    required int cartId,
    required bool isSelected,
  }) async {
    DefaultModel _model = new DefaultModel();

    final Map<String, dynamic> _data = {
      "cart_id": cartId,
      "is_selected": isSelected,
    };

    try {
      Response _response = await post(
        URLHelper.selectCartUrl,
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
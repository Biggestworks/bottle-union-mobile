import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/default_model.dart';
import 'package:eight_barrels/model/product/user_wishlist_model.dart';
import 'package:eight_barrels/model/product/wishlist_model.dart';
import 'package:get/get_connect.dart';

class WishlistService extends GetConnect {
  UserPreferences _userPreferences = new UserPreferences();

  Future<Map<String, String>?> _headersAuth() async {
    var _token = await _userPreferences.getUserToken();

    return {
      "Accept": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  Future<WishlistModel?> storeWishlist({
    required int productId,
    required int regionId,
  }) async {
    WishlistModel _model = new WishlistModel();

    final Map<String, dynamic> _data = {
      "id_product": productId,
      "id_region": regionId,
      "flag": 'wishlist',
    };

    try {
      Response _response = await post(
        URLHelper.wishlistUrl,
        _data,
        headers: await _headersAuth(),
      );
      print(_response.body);
      _model = WishlistModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<UserWishlistModel?> getWishlist({required String page}) async {
    UserWishlistModel _model = new UserWishlistModel();

    final Map<String, dynamic> _query = {
      "page": page,
      "per_page": '6',
    };

    try {
      Response _response = await get(
        URLHelper.wishlistUrl,
        query: _query,
        headers: await _headersAuth(),
      );
      _model = UserWishlistModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<UserWishlistModel?> deleteWishlist({required List<int> idList}) async {
    UserWishlistModel _model = new UserWishlistModel();

    final Map<String, dynamic> _data = {
      "id": idList,
    };

    try {
      Response _response = await post(
        URLHelper.deleteWishlistUrl,
        _data,
        headers: await _headersAuth(),
      );
      _model = UserWishlistModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<DefaultModel?> checkWishlist({
    required int productId,
  }) async {
    DefaultModel _model = new DefaultModel();

    final Map<String, dynamic> _data = {
      "id_product": productId,
    };

    try {
      Response _response = await post(
        URLHelper.checkWishlistUrl,
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
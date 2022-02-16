import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/default_model.dart';
import 'package:eight_barrels/model/product/user_wishlist_model.dart';
import 'package:eight_barrels/model/product/wishlist_model.dart';
import 'package:get/get_connect.dart';

class WishlistService extends GetConnect {
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

  Future<WishlistModel?> storeWishlist({
    required int uid,
    required int productId,
  }) async {
    WishlistModel _model = new WishlistModel();

    final Map<String, dynamic> _data = {
      "id_user": uid,
      "id_product": productId,
      "flag": 'wishlist',
    };

    try {
      Response _response = await post(
        URLHelper.WISHLIST_URL,
        _data,
        headers: await _headersAuth(),
      );
      _model = WishlistModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<UserWishlistModel?> getWishlist({String? page}) async {
    UserWishlistModel _model = new UserWishlistModel();

    final Map<String, dynamic> _query = {
      "page": page,
      "per_page": '6',
    };

    try {
      Response _response = await get(
        URLHelper.WISHLIST_URL,
        query: _query,
        headers: await _headersAuth(),
      );
      _model = UserWishlistModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<UserWishlistModel?> deleteWishlist({List<int>? idList}) async {
    UserWishlistModel _model = new UserWishlistModel();

    final Map<String, dynamic> _data = {
      "id": idList,
    };

    try {
      Response _response = await post(
        URLHelper.DELETE_WISHLIST_URL,
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
    required int uid,
    required int productId,
  }) async {
    DefaultModel _model = new DefaultModel();

    final Map<String, dynamic> _data = {
      "id_user": uid,
      "id_product": productId,
    };

    try {
      Response _response = await post(
        URLHelper.CHECK_WISHLIST_URL,
        _data,
        headers: await _headersAuth(),
      );
      print(_response.body);
      _model = DefaultModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

}
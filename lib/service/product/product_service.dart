import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/model/product/brand_model.dart';
import 'package:eight_barrels/model/product/category_model.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/model/product/product_model.dart';
import 'package:get/get_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService extends GetConnect {

  Future<Map<String, String>?> _headersAuth() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _token = _prefs.getString(KeyHelper.KEY_TOKEN);

    return {
      "Accept": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  Future<ProductListModel?> productList({
    String? name,
    String? brand,
    String? category,
    String? manufactureCountry,
    String? originCountry,
    String? year,
    String? minPrice,
    String? maxPrice,
    String? page,
  }) async {
    ProductListModel _model = new ProductListModel();

    final Map<String, dynamic> _query = {
      "name": name,
      "brand": brand,
      "category": category,
      "manufacture_country": manufactureCountry,
      "origin_country": originCountry,
      "year": year,
      "min_price": minPrice,
      "max_price": maxPrice,
      "page": page,
      "per_page": '6',
    };

    try {
      Response _response = await get(
        URLHelper.PRODUCT_LIST_URL,
        query: _query,
        headers: await _headersAuth(),
      );
      // print(_response.body);
      _model = ProductListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<BrandListModel?> brandList() async {
    BrandListModel _model = new BrandListModel();

    try {
      Response _response = await get(
        URLHelper.BRAND_LIST_URL,
        headers: await _headersAuth(),
      );
      _model = BrandListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<CategoryListModel?> categoryList() async {
    CategoryListModel _model = new CategoryListModel();

    try {
      Response _response = await get(
        URLHelper.CATEGORY_LIST_URL,
        headers: await _headersAuth(),
      );
      _model = CategoryListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<ProductDetailModel?> productDetail({
    int? id,
  }) async {
    ProductDetailModel _model = new ProductDetailModel();

    try {
      Response _response = await get(
        URLHelper.productDetailUrl(id.toString()),
        headers: await _headersAuth(),
      );
      _model = ProductDetailModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

}
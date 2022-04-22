import 'package:eight_barrels/helper/url_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/product/brand_model.dart';
import 'package:eight_barrels/model/product/category_model.dart';
import 'package:eight_barrels/model/product/popular_product_list_model.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/model/product/product_model.dart';
import 'package:get/get_connect.dart';

class ProductService extends GetConnect {
  UserPreferences _userPreferences = new UserPreferences();

  Future<Map<String, String>?> _headersAuth() async {
    var _token = await _userPreferences.getUserToken();

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
      _model = ProductListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<BrandListModel?> getBrandList() async {
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

  Future<CategoryListModel?> getCategoryList() async {
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

  Future<ProductDetailModel?> getProductDetail({
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

  Future<PopularProductListModel?> getPopularProductList({
    String? regionId,
    String? page,
  }) async {
    PopularProductListModel _model = new PopularProductListModel();

    final Map<String, dynamic> _query = {
      "id_region": regionId ?? null,
      "page": page,
      "perPage": '6',
    };

    try {
      Response _response = await get(
        URLHelper.POPULAR_PRODUCT_LIST_URL,
        query: _query,
        headers: await _headersAuth(),
      );
      _model = PopularProductListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

  Future<PopularProductListModel?> getProductByRegionList({
    String? regionId,
    String? page,
  }) async {
    PopularProductListModel _model = new PopularProductListModel();

    final Map<String, dynamic> _query = {
      "id_region": regionId ?? null,
      "page": page,
      "perPage": '6',
    };

    try {
      Response _response = await get(
        URLHelper.PRODUCT_BY_REGION_LIST_URL,
        query: _query,
        headers: await _headersAuth(),
      );
      _model = PopularProductListModel.fromJson(_response.body);
    } catch (e) {
      print(e);
    }

    return _model;
  }

}
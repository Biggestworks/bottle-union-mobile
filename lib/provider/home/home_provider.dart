import 'package:eight_barrels/abstract/pagination_interface.dart';
import 'package:eight_barrels/abstract/product_card_interface.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/helper/push_notification_manager.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/user_detail_model.dart';
import 'package:eight_barrels/model/banner/banner_list_model.dart';
import 'package:eight_barrels/model/product/category_model.dart';
import 'package:eight_barrels/model/product/popular_product_list_model.dart';
import 'package:eight_barrels/service/banner/banner_service.dart';
import 'package:eight_barrels/service/product/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeProvider extends ChangeNotifier
    with PaginationInterface, ProductCardInterface{
  UserPreferences _userPreferences = new UserPreferences();
  UserDetailModel userModel = new UserDetailModel();
  int currBanner = 0;

  BannerService _bannerService = new BannerService();
  ProductService _productService = new ProductService();

  CategoryListModel categoryList = new CategoryListModel();
  BannerListModel bannerList = new BannerListModel();
  PopularProductListModel popularProductList = new PopularProductListModel();
  PopularProductListModel regionProductList = new PopularProductListModel();

  final _storage = new FlutterSecureStorage();
  PushNotificationManager _pushNotificationManager = new PushNotificationManager();

  bool isPaginateLoad = false;
  int? userRegionId;
  String? userRegion;

  Future fnFetchUserInfo() async {
    this.userModel = (await _userPreferences.getUserData())!;
    var _regionId = await _storage.read(key: KeyHelper.KEY_USER_REGION_ID) ?? null;
    var _regionName = await _storage.read(key: KeyHelper.KEY_USER_REGION_NAME) ?? null;

    if (_regionId != null && _regionName != null) {
      userRegionId = int.parse(_regionId);
      userRegion = _regionName;
    } else {
      userRegionId = userModel.region?.id;
      userRegion = userModel.region?.name;
    }
    notifyListeners();
  }

  onBannerChanged(int value) {
    this.currBanner = value;
    notifyListeners();
  }

  Future fnFetchCategoryList() async {
    categoryList = (await _productService.getCategoryList())!;
    notifyListeners();
  }

  Future onRefresh() async {
    super.currentPage = 1;
    await fnFetchUserInfo().then((_) async {
      await fnFetchRegionProductList();
      await fnFetchBannerList();
    });
    await fnFetchCategoryList();
    await fnFetchPopularProductList();
    notifyListeners();
  }

  Future fnFetchBannerList() async {
    bannerList = (await _bannerService.getBannerList(
      regionId: userRegionId.toString()
    ))!;
    notifyListeners();
  }

  Future fnFetchPopularProductList() async {
    super.currentPage = 1;
    popularProductList = (await _productService.getPopularProductList(
      page: super.currentPage.toString(),
    ))!;
    notifyListeners();
  }

  Future fnFetchRegionProductList() async {
    super.currentPage = 1;
    regionProductList = (await _productService.getPopularProductList(
      regionId: userRegionId.toString(),
      page: super.currentPage.toString(),
    ))!;
    notifyListeners();
  }

  Future fnSaveFcmToken() async {
    String _token = await _storage.read(key: KeyHelper.KEY_FCM_TOKEN) ?? '';
    if (_token.isEmpty)
      await _pushNotificationManager.saveFcmToken();
  }

  @override
  Future fnShowNextPage() async {
    onPaginationLoadStart();
    super.currentPage++;

    var _products = await _productService.getPopularProductList(
      page: super.currentPage.toString(),
    );

    if (_products?.result != null) {
      popularProductList.result?.data?.addAll(_products!.result!.data!);

      if (_products?.result?.data?.length == 0) {
        onPaginationLoadFinish();
      }
    }
    notifyListeners();
  }

  @override
  void onPaginationLoadFinish() {
    isPaginateLoad = false;
    notifyListeners();
  }

  @override
  void onPaginationLoadStart() {
    isPaginateLoad = true;
    notifyListeners();
  }

}
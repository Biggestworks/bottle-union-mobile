import 'package:eight_barrels/abstract/pagination_interface.dart';
import 'package:eight_barrels/abstract/product_card_interface.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/user_detail_model.dart';
import 'package:eight_barrels/model/banner/banner_list_model.dart';
import 'package:eight_barrels/model/product/category_model.dart';
import 'package:eight_barrels/model/product/popular_product_list_model.dart';
import 'package:eight_barrels/service/banner/banner_service.dart';
import 'package:eight_barrels/service/product/product_service.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier
    with PaginationInterface, ProductCardInterface{
  UserPreferences _userPreferences = new UserPreferences();
  UserDetailModel userModel = new UserDetailModel();
  int currBanner = 0;

  BannerService _bannerService = new BannerService();
  ProductService _productService = new ProductService();

  CategoryListModel categoryList = new CategoryListModel();
  BannerListModel bannerList = new BannerListModel();
  PopularProductListModel productList = new PopularProductListModel();

  bool isPaginateLoad = false;

  HomeProvider() {
    fnFetchUserInfo();
    _fnFetchCategoryList();
    _fnFetchBannerList();
    _fnFetchPopularProductList();
  }

  Future fnFetchUserInfo() async {
    this.userModel = (await _userPreferences.getUserData())!;
    notifyListeners();
  }

  onBannerChanged(int value) {
    this.currBanner = value;
    notifyListeners();
  }

  Future _fnFetchCategoryList() async {
    categoryList = (await _productService.getCategoryList())!;
    notifyListeners();
  }

  Future onRefresh() async {
    super.currentPage = 1;
    await fnFetchUserInfo();
    await _fnFetchCategoryList();
    await _fnFetchBannerList();
    await _fnFetchPopularProductList();
    notifyListeners();
  }

  Future _fnFetchBannerList() async {
    bannerList = (await _bannerService.getBannerList())!;
    notifyListeners();
  }

  Future _fnFetchPopularProductList() async {
    productList = (await _productService.getPopularProductList(
      page: super.currentPage.toString(),
    ))!;
    notifyListeners();
  }

  @override
  Future fnShowNextPage() async {
    onPaginationLoadStart();
    super.currentPage++;

    var _products = await _productService.getPopularProductList(
      page: super.currentPage.toString(),
    );

    if (_products?.result != null) {
      productList.result?.data!.addAll(_products!.result!.data!);

      if (_products?.result?.data!.length == 0) {
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
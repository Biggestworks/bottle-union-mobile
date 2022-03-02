import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/user_detail_model.dart';
import 'package:eight_barrels/model/banner/banner_list_model.dart';
import 'package:eight_barrels/model/product/category_model.dart';
import 'package:eight_barrels/service/banner/banner_service.dart';
import 'package:eight_barrels/service/product/product_service.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  UserPreferences _userPreferences = new UserPreferences();
  UserDetailModel userModel = new UserDetailModel();
  int currBanner = 0;

  BannerService _bannerService = new BannerService();
  ProductService _productService = new ProductService();

  CategoryListModel categoryList = new CategoryListModel();
  BannerListModel bannerList = new BannerListModel();

  HomeProvider() {
    fnFetchUserInfo();
    _fnFetchCategoryList();
    _fnFetchBannerList();
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
    categoryList = (await _productService.categoryList())!;
    notifyListeners();
  }

  Future onRefresh() async {
    await fnFetchUserInfo();
    await _fnFetchCategoryList();
    await _fnFetchBannerList();
  }

  Future _fnFetchBannerList() async {
    bannerList = (await _bannerService.getBannerList())!;
    notifyListeners();
  }

}
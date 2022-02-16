import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/auth/user_model.dart';
import 'package:eight_barrels/model/product/category_model.dart';
import 'package:eight_barrels/service/product/product_service.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  UserPreferences _userPreferences = new UserPreferences();
  UserModel userModel = new UserModel();
  int currBanner = 0;

  ProductService _productService = new ProductService();
  CategoryListModel categoryList = new CategoryListModel();

  final List<String> bannerList = [
    'assets/images/banner_1.jpg',
    'assets/images/banner_2.webp',
    'assets/images/banner_3.webp',
  ];

  HomeProvider() {
    _fnFetchUserInfo();
    _fnFetchCategoryList();
  }

  Future _fnFetchUserInfo() async {
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
    await _fnFetchUserInfo();
    await _fnFetchCategoryList();
  }

}
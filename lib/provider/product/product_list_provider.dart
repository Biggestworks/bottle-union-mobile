import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/pagination_interface.dart';
import 'package:eight_barrels/abstract/product_card_interface.dart';
import 'package:eight_barrels/abstract/product_filter_interface.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/model/product/brand_model.dart';
import 'package:eight_barrels/model/product/category_model.dart';
import 'package:eight_barrels/model/product/product_model.dart';
import 'package:eight_barrels/service/product/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/route_manager.dart';

class ProductListProvider extends ChangeNotifier
    with PaginationInterface, ProductCardInterface, ProductFilterInterface {
  ProductService _service = new ProductService();
  ProductListModel productList = new ProductListModel();
  BrandListModel brandList = new BrandListModel();
  var _storage = new FlutterSecureStorage();
  CategoryListModel categoryList = new CategoryListModel();

  final TextEditingController searchController = new TextEditingController();
  final TextEditingController yearController = new TextEditingController();
  final TextEditingController minPriceController = new TextEditingController();
  final TextEditingController maxPriceController = new TextEditingController();

  List<String> yearList = [];
  List<FilterChips> filterVal = [];

  int? selectedBrandIndex;
  String? regionId;
  bool isBrandSelected = false;
  int? selectedCategoryIndex;
  bool isCategorySelected = false;
  bool isFiltered = false;

  LoadingView? _view;

  bool isPaginateLoad = false;

  fnGetView(LoadingView view) {
    this._view = view;
  }

  Future fnFetchProductList() async {
    _view!.onProgressStart();

    super.currentPage = 1;
    regionId = await _storage.read(key: KeyHelper.KEY_USER_REGION_ID);
    productList = (await _service.productList(
      name: searchController.text,
      brand: selectedBrandIndex != null
          ? brandList.data![selectedBrandIndex!].name
          : null,
      category: selectedCategoryIndex != null
          ? categoryList.data![selectedCategoryIndex!].name
          : null,
      year: yearController.text,
      minPrice: toNumericString(minPriceController.text),
      maxPrice: toNumericString(maxPriceController.text),
      page: super.currentPage.toString(),
    ))!;

    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnOnSearchProduct(String value) async {
    _view!.onProgressStart();

    productList = (await _service.productList(
      name: value,
      brand: selectedBrandIndex != null
          ? brandList.data![selectedBrandIndex!].name
          : null,
      category: selectedCategoryIndex != null
          ? categoryList.data![selectedCategoryIndex!].name
          : null,
      year: yearController.text,
      minPrice: toNumericString(minPriceController.text),
      maxPrice: toNumericString(maxPriceController.text),
    ))!;

    isFiltered = true;

    _view!.onProgressFinish();
    notifyListeners();
  }

  fnOnFiltered() {
    super.isFiltered = true;
    notifyListeners();
  }

  fnOnSelectBrand(int index) {
    super.onSelectBrand(index);
    notifyListeners();
  }

  fnOnSelectCategory(int index) {
    super.onSelectCategory(index);
    notifyListeners();
  }

  fnAddBrandChip() {
    super.addBrandChip();
    notifyListeners();
  }

  fnAddCategoryChip() {
    super.addCategoryChip();
    notifyListeners();
  }

  fnAddYearChip() {
    super.addYearChip();
    notifyListeners();
  }

  fnAddMinPriceChip() {
    super.addMinPriceChip();
    notifyListeners();
  }

  fnAddMaxPriceChip() {
    super.addMaxPriceChip();
    notifyListeners();
  }

  Future fnInitFilter() async {
    await super.initFilter();
    notifyListeners();
  }

  Future fnOnSubmitFilter() async {
    if (formKey.currentState!.validate()) {
      Get.back();
      super.onSubmitFilter();
      await fnFetchProductList();
    }
    notifyListeners();
  }

  Future fnOnResetFilter() async {
    await Future.delayed(Duration.zero, () => super.onResetFilter())
        .whenComplete(() async => await fnFetchProductList());
    notifyListeners();
  }

  @override
  Future fnShowNextPage() async {
    onPaginationLoadStart();
    super.currentPage++;

    var _products = await _service.productList(
      name: searchController.text,
      brand: selectedBrandIndex != null
          ? brandList.data![selectedBrandIndex!].name
          : null,
      category: selectedCategoryIndex != null
          ? categoryList.data![selectedCategoryIndex!].name
          : null,
      year: yearController.text,
      minPrice: toNumericString(minPriceController.text),
      maxPrice: toNumericString(maxPriceController.text),
      page: super.currentPage.toString(),
    );

    if (_products?.result != null) {
      productList.result?.data?.addAll(_products!.result!.data!);
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

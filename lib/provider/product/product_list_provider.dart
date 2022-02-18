import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/pagination_interface.dart';
import 'package:eight_barrels/abstract/product_card_interface.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/product/brand_model.dart';
import 'package:eight_barrels/model/product/category_model.dart';
import 'package:eight_barrels/model/product/product_model.dart';
import 'package:eight_barrels/service/product/product_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductListProvider extends ChangeNotifier
    with PaginationInterface, ProductCardInterface {
  ProductService _service = new ProductService();
  ProductListModel productList = new ProductListModel();
  BrandListModel brandList = new BrandListModel();
  CategoryListModel categoryList = new CategoryListModel();
  final TextEditingController searchController = new TextEditingController();
  final TextEditingController minPriceController = new TextEditingController();
  final TextEditingController maxPriceController = new TextEditingController();

  UserPreferences _userPreferences = new UserPreferences();

  List<Widget> brandChips = [];

  int? selectedBrandIndex;
  bool isBrandSelected = false;
  int? selectedCategoryIndex;
  bool isCategorySelected = false;
  DateTime selectedDate = DateTime.now();
  String? selectedYear;
  bool isFiltered = false;

  LoadingView? _view;

  bool isPaginateLoad = false;

  fnGetView(LoadingView view) {
    this._view = view;
  }

  Future fnFetchProductList() async {
    _view!.onProgressStart();

    productList = (await _service.productList(
      name: searchController.text,
      brand: selectedBrandIndex != null
          ? brandList.data![selectedBrandIndex!].name
          : null,
      category: selectedCategoryIndex != null
          ? categoryList.data![selectedCategoryIndex!].name
          : null,
      year: selectedYear ?? null,
      minPrice: minPriceController.text,
      maxPrice: maxPriceController.text,
      page: super.currentPage.toString(),
    ))!;

    _view!.onProgressFinish();
    notifyListeners();
  }

  fnOnSelectBrand(int index) {
    selectedBrandIndex = index;
    isBrandSelected = !isBrandSelected;
    if (isBrandSelected == false) {
      selectedBrandIndex = null;
    }
    isFiltered = true;
    notifyListeners();
  }

  fnOnSelectCategory(int index) {
    selectedCategoryIndex = index;
    isCategorySelected = !isCategorySelected;
    if (isCategorySelected == false) {
      selectedCategoryIndex = null;
    }
    isFiltered = true;
    notifyListeners();
  }

  fnOnSelectYear(DateTime value) {
    selectedDate = value;
    selectedYear = DateFormat('yyyy').format(value);
    isFiltered = true;
    notifyListeners();
  }

  // fnOnSelectYear(DateRangePickerSelectionChangedArgs args) {
  //   selectedYear = DateFormat('yyyy').format(args.value);
  //   isFiltered = true;
  //   notifyListeners();
  // }

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
      year: selectedYear,
      minPrice: minPriceController.text,
      maxPrice: maxPriceController.text,
    ))!;

    isFiltered = true;

    _view!.onProgressFinish();
    notifyListeners();
  }

  fnOnChangedPrice() {
    isFiltered = true;
    notifyListeners();
  }

  Future fnInitFilter() async {
    brandList = (await _service.brandList())!;
    categoryList = (await _service.categoryList())!;
    isFiltered = false;
    notifyListeners();
  }

  Future fnOnSubmitFilter() async {
    await fnFetchProductList();
    notifyListeners();
  }

  Future onResetFilter() async {
    selectedBrandIndex = null;
    selectedCategoryIndex = null;
    selectedYear = null;
    selectedDate = DateTime.now();
    searchController.clear();
    minPriceController.clear();
    maxPriceController.clear();
    isFiltered = false;
    await fnFetchProductList();
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
      year: selectedYear ?? null,
      minPrice: minPriceController.text,
      maxPrice: maxPriceController.text,
      page: super.currentPage.toString(),
    );

    productList.result!.data!.addAll(_products!.result!.data!);

    if (_products.result!.data!.length == 0) {
      onPaginationLoadFinish();
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
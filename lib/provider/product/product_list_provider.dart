import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/pagination_interface.dart';
import 'package:eight_barrels/model/product/brand_model.dart';
import 'package:eight_barrels/model/product/category_model.dart';
import 'package:eight_barrels/model/product/product_model.dart';
import 'package:eight_barrels/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ProductListProvider extends ChangeNotifier with PaginationInterface {
  ProductService _service = new ProductService();
  ProductListModel productList = new ProductListModel();
  BrandListModel brandList = new BrandListModel();
  CategoryListModel categoryList = new CategoryListModel();
  final TextEditingController searchController = new TextEditingController();
  final TextEditingController minPriceController = new TextEditingController();
  final TextEditingController maxPriceController = new TextEditingController();

  List<Widget> brandChips = [];

  int? selectedBrandIndex;
  bool isBrandSelected = false;
  int? selectedCategoryIndex;
  bool isCategorySelected = false;
  String? selectedYear;
  bool isFiltered = false;

  LoadingView? _loadView;

  bool isPaginateLoad = false;

  fnGetView(LoadingView view) {
    this._loadView = view;
  }

  Future fnFetchProductList() async {
    _loadView!.onProgressStart();

    productList = (await _service.productList(
      page: super.currentPage.toString(),
    ))!;

    _loadView!.onProgressFinish();
    notifyListeners();
  }

  @override
  Future fnShowNextPage() async {
    onPaginationLoadStart();
    super.currentPage++;

    var _products = await _service.productList(
      name: searchController.text,
      page: super.currentPage.toString(),
    );

    productList.result!.data!.addAll(_products!.result!.data!);

    if (_products.result!.data!.length == 0) {
      onPaginationLoadFinish();
    }
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

  fnOnSelectYear(DateRangePickerSelectionChangedArgs args) {
    selectedYear = DateFormat('yyyy').format(args.value);
    isFiltered = true;
    notifyListeners();
  }

  Future fnOnSearchProduct(String value) async {
    _loadView!.onProgressStart();

    productList = (await _service.productList(
      name: value,
      page: super.currentPage.toString(),
    ))!;

    _loadView!.onProgressFinish();
    notifyListeners();
  }

  Future fnFetchBrandList() async {
    brandList = (await _service.brandList())!;
    notifyListeners();
  }

  Future fnFetchCategoryList() async {
    categoryList = (await _service.categoryList())!;
    notifyListeners();
  }

  Future fnOnSubmitFilter() async {
    _loadView!.onProgressStart();

    productList = (await _service.productList(
      name: searchController.text,
      brand: selectedBrandIndex != null
          ? brandList.data![selectedBrandIndex!].name
          : null,
      category: selectedCategoryIndex != null
          ? categoryList.data![selectedCategoryIndex!].name
          : null,
      year: selectedYear,
      minPrice: minPriceController.text,
      maxPrice: maxPriceController.text,
      page: super.currentPage.toString(),
    ))!;

    _loadView!.onProgressFinish();
    notifyListeners();
  }

  Future onResetFilter() async {
    selectedBrandIndex = null;
    selectedCategoryIndex = null;
    selectedYear = null;
    searchController.clear();
    await fnFetchProductList();
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
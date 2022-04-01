import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/pagination_interface.dart';
import 'package:eight_barrels/abstract/product_card_interface.dart';
import 'package:eight_barrels/model/product/brand_model.dart';
import 'package:eight_barrels/model/product/category_model.dart';
import 'package:eight_barrels/model/product/product_model.dart';
import 'package:eight_barrels/service/product/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/route_manager.dart';

class ProductListProvider extends ChangeNotifier
    with PaginationInterface, ProductCardInterface {
  ProductService _service = new ProductService();
  ProductListModel productList = new ProductListModel();
  BrandListModel brandList = new BrandListModel();
  CategoryListModel categoryList = new CategoryListModel();

  final TextEditingController searchController = new TextEditingController();
  final TextEditingController yearController = new TextEditingController();
  final TextEditingController minPriceController = new TextEditingController();
  final TextEditingController maxPriceController = new TextEditingController();

  List<String> yearList = [];
  List<FilterChips> filterVal = [];

  int? selectedBrandIndex;
  bool isBrandSelected = false;
  int? selectedCategoryIndex;
  bool isCategorySelected = false;
  bool isFiltered = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoadingView? _view;

  bool isPaginateLoad = false;

  fnGetView(LoadingView view) {
    this._view = view;
  }

  Future fnFetchProductList() async {
    _view!.onProgressStart();

    super.currentPage = 1;

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

  Widget filterChips() {
    return Container(
      height: 50,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: filterVal.length,
        itemBuilder: (context, index) {
          return Chip(
            label: Text(filterVal[index].value),
          );
        },
      ),
    );
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

  fnOnChangedYear(String value) {
    isFiltered = true;
    notifyListeners();
  }

  fnAddBrandChip() {
    if (selectedBrandIndex != null) {
      if (filterVal.where((i) => i.flag == 'brand').length == 0) {
        filterVal.add(FilterChips(brandList.data![selectedBrandIndex!].name!, 'brand'));
      }
    } else {
      filterVal.removeWhere((item) => item.flag == 'brand');
    }
    notifyListeners();
  }

  fnAddCategoryChip() {
    if (selectedCategoryIndex != null) {
      if (filterVal.where((i) => i.flag == 'category').length == 0) {
        filterVal.add(FilterChips(categoryList.data![selectedCategoryIndex!].name!, 'category'));
      }
    } else {
      filterVal.removeWhere((item) => item.flag == 'category');
    }
    notifyListeners();
  }

  fnAddYearChip() {
    if (yearController.text.isNotEmpty) {
      if (filterVal.where((item) => item.flag == 'year').length == 0) {
        filterVal.add(FilterChips(yearController.text, 'year'));
      } else {
        filterVal.removeWhere((item) => item.flag == 'year');
        filterVal.add(FilterChips(yearController.text, 'year'));
      }
    } else {
      filterVal.removeWhere((item) => item.flag == 'year');
    }
    notifyListeners();
  }

  fnAddMinPriceChip() {
    if (minPriceController.text.isNotEmpty) {
      if (filterVal.where((item) => item.flag == 'min').length == 0) {
        filterVal.add(FilterChips('Min: Rp${minPriceController.text}', 'min'));
      } else {
        filterVal.removeWhere((item) => item.flag == 'min');
        filterVal.add(FilterChips('Min: Rp${minPriceController.text}', 'min'));
      }
    } else {
      filterVal.removeWhere((item) => item.flag == 'min');
    }
    notifyListeners();
  }

  fnAddMaxPriceChip() {
    if (maxPriceController.text.isNotEmpty) {
      if (filterVal.where((item) => item.flag == 'max').length == 0) {
        filterVal.add(FilterChips('Max: Rp${maxPriceController.text}', 'max'));
      } else {
        filterVal.removeWhere((item) => item.flag == 'max');
        filterVal.add(FilterChips('Max: Rp${maxPriceController.text}', 'max'));
      }
    } else {
      filterVal.removeWhere((item) => item.flag == 'max');
    }
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

  fnOnChangedPrice() {
    isFiltered = true;
    notifyListeners();
  }

  fnGenerateYearList() {
    DateTime _start = DateTime(DateTime.now().year - 100, 1);
    DateTime _end = DateTime(DateTime.now().year);
    final daysToGenerate = _end.difference(_start).inDays ~/ 365;
    yearList.clear();
    yearList = List.generate(daysToGenerate, (i) => DateTime(_start.year + (i + 1)).year.toString());
  }

  Future fnInitFilter() async {
    brandList = (await _service.brandList())!;
    categoryList = (await _service.categoryList())!;
    fnGenerateYearList();
    isFiltered = false;
    notifyListeners();
  }

  Future fnOnSubmitFilter() async {
    if (formKey.currentState!.validate()) {
      Get.back();
      fnAddBrandChip();
      fnAddCategoryChip();
      fnAddYearChip();
      fnAddMinPriceChip();
      fnAddMaxPriceChip();
      await fnFetchProductList();
    }
    notifyListeners();
  }

  Future onResetFilter() async {
    selectedBrandIndex = null;
    selectedCategoryIndex = null;
    yearController.clear();
    searchController.clear();
    minPriceController.clear();
    maxPriceController.clear();
    isFiltered = false;
    filterVal.clear();
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
      year: yearController.text,
      minPrice: toNumericString(minPriceController.text),
      maxPrice: toNumericString(maxPriceController.text),
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

class FilterChips {
  final String value;
  final String flag;

  FilterChips(this.value, this.flag);
}
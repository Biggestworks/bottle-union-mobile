import 'package:eight_barrels/model/product/brand_model.dart';
import 'package:eight_barrels/model/product/category_model.dart';
import 'package:eight_barrels/service/product/product_service.dart';
import 'package:flutter/material.dart';

abstract class ProductFilterInterface {
  ProductService _service = new ProductService();
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

  onSelectBrand(int index) {
    selectedBrandIndex = index;
    isBrandSelected = !isBrandSelected;
    if (isBrandSelected == false) {
      selectedBrandIndex = null;
    }
    isFiltered = true;
  }

  onSelectCategory(int index) {
    selectedCategoryIndex = index;
    isCategorySelected = !isCategorySelected;
    if (isCategorySelected == false) {
      selectedCategoryIndex = null;
    }
    isFiltered = true;
  }

  addBrandChip() {
    if (selectedBrandIndex != null) {
      if (filterVal.where((i) => i.flag == 'brand').length == 0) {
        filterVal.add(FilterChips(brandList.data![selectedBrandIndex!].name!, 'brand'));
      }
    } else {
      filterVal.removeWhere((item) => item.flag == 'brand');
    }
  }

  addCategoryChip() {
    if (selectedCategoryIndex != null) {
      if (filterVal.where((i) => i.flag == 'category').length == 0) {
        filterVal.add(FilterChips(categoryList.data![selectedCategoryIndex!].name!, 'category'));
      }
    } else {
      filterVal.removeWhere((item) => item.flag == 'category');
    }
  }

  addYearChip() {
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
  }

  addMinPriceChip() {
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
  }

  addMaxPriceChip() {
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
  }

  generateYearList() {
    DateTime _start = DateTime(DateTime.now().year - 100, 1);
    DateTime _end = DateTime(DateTime.now().year);
    final daysToGenerate = _end.difference(_start).inDays ~/ 365;
    yearList.clear();
    yearList = List.generate(daysToGenerate, (i) => DateTime(_start.year + (i + 1)).year.toString());
  }

  Future initFilter() async {
    brandList = (await _service.getBrandList())!;
    categoryList = (await _service.getCategoryList())!;
    generateYearList();
    isFiltered = false;
  }

  onSubmitFilter() async {
    addBrandChip();
    addCategoryChip();
    addYearChip();
    addMinPriceChip();
    addMaxPriceChip();
  }

  onResetFilter() async {
    selectedBrandIndex = null;
    selectedCategoryIndex = null;
    yearController.clear();
    searchController.clear();
    minPriceController.clear();
    maxPriceController.clear();
    isFiltered = false;
    filterVal.clear();
  }

}

class FilterChips {
  final String value;
  final String flag;

  FilterChips(this.value, this.flag);
}
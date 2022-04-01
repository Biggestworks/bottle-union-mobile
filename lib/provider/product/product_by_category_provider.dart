import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/pagination_interface.dart';
import 'package:eight_barrels/model/product/product_model.dart';
import 'package:eight_barrels/screen/product/product_by_category_screen.dart';
import 'package:eight_barrels/service/product/product_service.dart';
import 'package:flutter/material.dart';

class ProductByCategoryProvider extends ChangeNotifier
    with PaginationInterface {
  ProductService _productService = new ProductService();
  ProductListModel productList = new ProductListModel();
  final TextEditingController searchController = new TextEditingController();
  String? category;

  bool isPaginateLoad = false;

  LoadingView? _view;

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as ProductByCategoryScreen;
    category = _args.category;
    notifyListeners();
  }

  Future fnFetchProductList() async {
    _view!.onProgressStart();

    productList = (await _productService.productList(
      category: category ?? null,
      page: super.currentPage.toString(),
    ))!;

    _view!.onProgressFinish();
    notifyListeners();
  }

  @override
  Future fnShowNextPage() async {
    onPaginationLoadStart();
    super.currentPage++;

    var _products = await _productService.productList(
      name: searchController.text,
      category: category ?? null,
      page: super.currentPage.toString(),
    );

    productList.result!.data!.addAll(_products!.result!.data!);

    if (_products.result!.data!.length == 0) {
      onPaginationLoadFinish();
    }
    notifyListeners();
  }

  Future fnOnSearchProduct(String value) async {
    _view!.onProgressStart();

    productList = (await _productService.productList(
      name: value,
      category: category ?? null,
      page: super.currentPage.toString(),
    ))!;

    _view!.onProgressFinish();
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
import 'package:eight_barrels/model/product/product_model.dart';
import 'package:eight_barrels/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductListProvider extends ChangeNotifier {
  ProductService _service = new ProductService();
  ProductListModel productList = new ProductListModel();

  Future fnFetchProductList() async {
    productList = (await _service.productList())!;
    notifyListeners();
  }

  fnMoneyFormatter(int? value) {
    final moneyFormatter = new NumberFormat.currency(
      locale: "id_ID",
      symbol: "IDR ",
      decimalDigits: 0,
    );
    return moneyFormatter.format(value);
  }

  ProductListProvider() {
    fnFetchProductList();
  }

}
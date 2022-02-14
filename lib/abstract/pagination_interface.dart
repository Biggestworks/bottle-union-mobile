import 'package:flutter/material.dart';

abstract class PaginationInterface {
  int currentPage = 1;

  bool fnOnNotification(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      fnShowNextPage();
      return true;
    } else {
      return false;
    }
  }

  Future fnShowNextPage();

  void onPaginationLoadStart();

  void onPaginationLoadFinish();
}
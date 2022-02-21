import 'package:eight_barrels/screen/cart/cart_list_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';

class BaseCartProvider extends ChangeNotifier {

  List<Widget> screenList() {
    return [
      CartListScreen(),
      CustomWidget.underConstructionPage(),
    ];
  }
}

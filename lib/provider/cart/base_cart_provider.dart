import 'package:eight_barrels/screen/cart/cart_list_screen.dart';
// import 'package:eight_barrels/screen/cart/track_order_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';

class BaseCartProvider extends ChangeNotifier {
  TabController? tabController;

  fnInitTabController(SingleTickerProviderStateMixin vsync) {
    tabController = new TabController(length: 2, vsync: vsync);
    notifyListeners();
  }

  fnOnChangeTab(int value) {
    print(value);
    tabController?.animateTo(value);
    notifyListeners();
  }

  List<Widget> screenList() {
    return [
      CartListScreen(),
      // TrackOrderScreen(),
    ];
  }
}

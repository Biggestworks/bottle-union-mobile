// ignore_for_file: unused_field

import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/checkout/order_cart_model.dart';
import 'package:eight_barrels/model/checkout/order_now_model.dart';
import 'package:eight_barrels/screen/checkout/order_finish_screen.dart';
import 'package:flutter/material.dart';

class OrderFinishProvider extends ChangeNotifier {
  // PaymentService _paymentService = new PaymentService();
  OrderNowModel? orderNow;
  OrderCartModel? orderCart;

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args =
        ModalRoute.of(context)!.settings.arguments as OrderFinishScreen;
    orderNow = _args.orderNow;
    orderCart = _args.orderCart;
    notifyListeners();
  }

  // Future fnFinishPayment(BuildContext context) async {
  //   _view!.onProgressStart();
  //   var _res = await _paymentService.midtransPayment(code: orderNow?.data?[0].order?[0].codeTransaction ?? null);
  //
  //   if (_res!.status != null) {
  //     if (_res.status == true) {
  //       _view!.onProgressFinish();
  //       await Get.offAndToNamed(MidtransWebviewScreen.tag, arguments: MidtransWebviewScreen(url: _res.data?.redirectUrl,));
  //     } else {
  //       _view!.onProgressFinish();
  //       await CustomWidget.showSnackBar(context: context, content: Text(_res.message ?? '-'));
  //     }
  //   } else {
  //     _view!.onProgressFinish();
  //     await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
  //   }
  //   _view!.onProgressFinish();
  //   notifyListeners();
  // }

  String fnGetSubtotal(int price, int qty) =>
      FormatterHelper.moneyFormatter((price * qty));

  String fnGetTotalCourierCost() {
    int _total = 0;
    for (int i = 0; i < (orderCart?.result?.length ?? 0); i++) {
      _total += orderCart?.result?[i].courierCost ?? 0;
    }
    return FormatterHelper.moneyFormatter(_total);
  }

  String fnGetTotalPrice(int pay, int deliveryCost) {
    int _total = 0;
    for (int i = 0; i < (orderCart?.result?.length ?? 0); i++) {
      _total += orderCart?.result?[i].courierCost ?? 0;
    }
    return FormatterHelper.moneyFormatter(pay - _total);
  }

  String fnGetTotalItem() {
    int _total = 0;
    for (int i = 0; i < (orderCart?.result?.length ?? 0); i++) {
      _total += orderCart?.result?[i].data?.length ?? 0;
    }
    return _total.toString();
  }
}

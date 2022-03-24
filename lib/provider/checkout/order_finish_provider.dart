import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/model/checkout/order_model.dart';
import 'package:eight_barrels/screen/checkout/midtrans_webview_screen.dart';
import 'package:eight_barrels/screen/checkout/order_finish_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/checkout/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class OrderFinishProvider extends ChangeNotifier {
  PaymentService _paymentService = new PaymentService();
  OrderModel? order;

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as OrderFinishScreen;
    order = _args.order;
    notifyListeners();
  }

  fnGetTotalPrice(int pay, int deliveryCost) => FormatterHelper.moneyFormatter(pay - deliveryCost);

  Future fnFinishPayment(BuildContext context) async {
    _view!.onProgressStart();
    var _res = await _paymentService.midtransPayment(code: order?.data?[0].order?[0].codeTransaction ?? null);

    if (_res!.status != null) {
      if (_res.status == true) {
        _view!.onProgressFinish();
        await Get.offAndToNamed(MidtransWebviewScreen.tag, arguments: MidtransWebviewScreen(url: _res.data?.redirectUrl,));
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message ?? '-'));
      }
    } else {
      _view!.onProgressFinish();
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
    _view!.onProgressFinish();
    notifyListeners();
  }

}
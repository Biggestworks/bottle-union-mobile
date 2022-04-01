import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/model/transaction/transaction_detail_model.dart';
import 'package:eight_barrels/screen/checkout/midtrans_webview_screen.dart';
import 'package:eight_barrels/screen/transaction/transaction_detail_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/checkout/payment_service.dart';
import 'package:eight_barrels/service/transaction/transcation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class TransactionDetailProvider extends ChangeNotifier {
  TransactionService _service = new TransactionService();
  PaymentService _paymentService = new PaymentService();
  String? orderId;
  TransactionDetailModel transactionDetail = new TransactionDetailModel();

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as TransactionDetailScreen;
    orderId = _args.orderId!;
    notifyListeners();
  }

  Future fnGetTransactionDetail() async {
    _view!.onProgressStart();
    transactionDetail = (await _service.getTransactionDetail(orderId: orderId!))!;
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnFinishPayment(BuildContext context) async {
    _view!.onProgressStart();
    var _res = await _paymentService.midtransPayment(code: transactionDetail.data?.codeTransaction ?? null);

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
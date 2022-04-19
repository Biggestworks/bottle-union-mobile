import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/model/transaction/track_order_model.dart';
import 'package:eight_barrels/screen/transaction/track_order_screen.dart';
import 'package:eight_barrels/service/transaction/transcation_service.dart';
import 'package:flutter/material.dart';

class TrackOrderProvider extends ChangeNotifier {
  TransactionService _service = new TransactionService();
  TrackOrderModel trackOrder = new TrackOrderModel();

  String? orderId;

  LoadingView? _view;

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as TrackOrderScreen;
    orderId = _args.orderId!;
    notifyListeners();
  }

  Future fnGetTrackOrder() async {
    _view!.onProgressStart();
    trackOrder = (await _service.getTrackOrder(orderId: orderId))!;
    _view!.onProgressFinish();
    notifyListeners();
  }

  String fnGetStatus(String status) {
    switch (status) {
      case '1':
        return AppLocalizations.instance.text('TXT_LBL_PAYMENT');
      case '2':
        return AppLocalizations.instance.text('TXT_LBL_CONFIRMATION');
      case '3':
        return AppLocalizations.instance.text('TXT_LBL_PROCESSED');
      case '4':
        return AppLocalizations.instance.text('TXT_LBL_DELIVERY');
      case '6':
        return AppLocalizations.instance.text('TXT_LBL_COMPLETE');
      default:
        return '-';
    }
  }

}
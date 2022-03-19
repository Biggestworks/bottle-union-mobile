import 'package:eight_barrels/model/checkout/order_summary_model.dart' as summary;
import 'package:eight_barrels/model/checkout/payment_list_model.dart';
import 'package:eight_barrels/screen/checkout/payment_screen.dart';
import 'package:eight_barrels/service/checkout/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class PaymentProvider extends ChangeNotifier {
  PaymentService _service = new PaymentService();
  PaymentListModel paymentList = new PaymentListModel();

  Data? selectedPayment;
  summary.Data? orderSummary;

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as PaymentScreen;
    orderSummary = _args.orderSummary;
    notifyListeners();
  }

  Future fnFetchPaymentList() async {
    paymentList = (await _service.getPaymentMethodList())!;

    if (paymentList.data != null) {
      selectedPayment = paymentList.data?.first;
    }
    notifyListeners();
  }

  fnOnSelectPayment(Data value) {
    Get.back();
    selectedPayment = value;
    notifyListeners();
  }

}
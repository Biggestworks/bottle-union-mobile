import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/pagination_interface.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/model/transaction/transaction_list_dart.dart';
import 'package:eight_barrels/screen/checkout/midtrans_webview_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/checkout/payment_service.dart';
import 'package:eight_barrels/service/transaction/transcation_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TransactionProvider extends ChangeNotifier with PaginationInterface {
  TransactionService _service = new TransactionService();
  PaymentService _paymentService = new PaymentService();
  TransactionListModel transactionList = new TransactionListModel();
  TextEditingController fromDateController = new TextEditingController();
  TextEditingController toDateController = new TextEditingController();

  DateTime? fromDate;
  DateTime? toDate;
  bool isFiltered = false;

  String status = 'waiting_for_payment';
  bool isPaginateLoad = false;
  List<TabLabel> tabLabel = [
    TabLabel(AppLocalizations.instance.text('TXT_LBL_PAYMENT'), 'waiting_for_payment', FontAwesomeIcons.creditCard),
    TabLabel(AppLocalizations.instance.text('TXT_LBL_PROCESSED'), 'process', FontAwesomeIcons.checkCircle),
    TabLabel(AppLocalizations.instance.text('TXT_LBL_DELIVERY'), 'on_deliveried', FontAwesomeIcons.truck),
    TabLabel(AppLocalizations.instance.text('TXT_LBL_COMPLETE'), 'completed', FontAwesomeIcons.solidStar),
    TabLabel(AppLocalizations.instance.text('TXT_LBL_COMPLAINT'), '', FontAwesomeIcons.exclamationCircle),
  ];

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnInitStatusOrder() {
    status = 'waiting_for_payment';
    notifyListeners();
  }

  Future fnFetchTransactionList() async {
    _view!.onProgressStart();

    super.currentPage = 1;

    transactionList = (await _service.getTransactionList(
      startDate: fromDate != null ? DateFormat('yyyy-MM-dd').format(fromDate ?? DateTime.now()) : null,
      endDate: toDate != null ? DateFormat('yyyy-MM-dd').format(toDate ?? DateTime.now()) : null,
      status: status,
      page: super.currentPage.toString(),
    ))!;

    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnOnTabSelected(String value) async {
    this.status = value;
    await fnFetchTransactionList();
    notifyListeners();
  }

  Future fnFinishPayment(BuildContext context) async {
    _view!.onProgressStart();
    var _res = await _paymentService.midtransPayment(code: transactionList.result?.data?[0].codeTransaction ?? null);

    if (_res!.status != null) {
      if (_res.status == true) {
        _view!.onProgressFinish();
        await Get.toNamed(MidtransWebviewScreen.tag, arguments: MidtransWebviewScreen(url: _res.data?.redirectUrl,));
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

  fnOnSelectDate(DateRangePickerSelectionChangedArgs args, String flag) {
    if (flag == 'from') {
      fromDateController.text = DateFormat('dd MMM yyyy').format(args.value);
      fromDate = args.value;
    } else {
      toDateController.text = DateFormat('dd MMM yyyy').format(args.value);
      toDate = args.value;
    }
    isFiltered = true;
    Get.back();
    notifyListeners();
  }

  Future fnOnResetFilter() async {
    fromDateController.clear();
    toDateController.clear();
    fromDate = null;
    toDate = null;
    isFiltered = false;
    await fnFetchTransactionList();
    notifyListeners();
  }

  fnInitFilter() {
    isFiltered = false;
    notifyListeners();
  }

  Future fnOnSubmitFilter(BuildContext context) async {
    DateTime _from = fromDate ?? DateTime.now();
    DateTime _to = toDate ?? DateTime.now();

    if (_from.isBefore(_to)) {
      Get.back();
      _view!.onProgressStart();
      transactionList = (await _service.getTransactionList(
        startDate: DateFormat('yyyy-MM-dd').format(fromDate ?? DateTime.now()),
        endDate: DateFormat('yyyy-MM-dd').format(toDate ?? DateTime.now()),
        status: status,
        page: super.currentPage.toString(),
      ))!;
      _view!.onProgressFinish();
    } else {
      CustomWidget.showSnackBar(context: context, content: Text('Invalid date'));
    }
    notifyListeners();
  }

  @override
  Future fnShowNextPage() async {
    onPaginationLoadStart();
    super.currentPage++;

    var _list = await _service.getTransactionList(
      startDate: fromDate != null ? DateFormat('yyyy-MM-dd').format(fromDate ?? DateTime.now()) : null,
      endDate: toDate != null ? DateFormat('yyyy-MM-dd').format(toDate ?? DateTime.now()) : null,
      status: status,
      page: super.currentPage.toString(),
    );

    transactionList.result!.data!.addAll(_list!.result!.data!);

    if (_list.result!.data!.length == 0) {
      onPaginationLoadFinish();
    }
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

class TabLabel {
  final String label;
  final String param;
  final IconData icon;

  TabLabel(this.label, this.param, this.icon);
}
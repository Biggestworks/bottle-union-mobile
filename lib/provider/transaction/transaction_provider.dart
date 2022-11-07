import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/abstract/pagination_interface.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/model/transaction/transaction_list_model.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/cart/cart_service.dart';
import 'package:eight_barrels/service/checkout/payment_service.dart';
import 'package:eight_barrels/service/transaction/transcation_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TransactionProvider extends ChangeNotifier with PaginationInterface {
  TransactionService _service = new TransactionService();
  PaymentService _paymentService = new PaymentService();
  CartService _cartService = new CartService();
  TransactionListModel transactionList = new TransactionListModel();
  TextEditingController fromDateController = new TextEditingController();
  TextEditingController toDateController = new TextEditingController();

  DateTime? fromDate;
  DateTime? toDate;
  bool isFiltered = false;

  int status = 1;
  bool isPaginateLoad = false;
  List<TabLabel> tabLabel = [
    TabLabel(AppLocalizations.instance.text('TXT_LBL_PAYMENT'), 1,
        FontAwesomeIcons.creditCard),
    TabLabel(AppLocalizations.instance.text('TXT_LBL_CONFIRMATION'), 2,
        FontAwesomeIcons.clock),
    TabLabel(AppLocalizations.instance.text('TXT_LBL_PROCESSED'), 3,
        FontAwesomeIcons.circleCheck),
    TabLabel(AppLocalizations.instance.text('TXT_LBL_DELIVERY'), 4,
        FontAwesomeIcons.truck),
    TabLabel(AppLocalizations.instance.text('TXT_LBL_COMPLETE'), 6,
        FontAwesomeIcons.solidStar),
    TabLabel(AppLocalizations.instance.text('TXT_LBL_CANCELED'), 7,
        FontAwesomeIcons.circleExclamation),
  ];

  List<DateFilter> dateFilter = [
    DateFilter(
      AppLocalizations.instance.text('TXT_ALL_DATE'),
      '',
    ),
    DateFilter(
      AppLocalizations.instance.text('TXT_TODAY'),
      DateFormat('dd MMM yyyy').format(DateTime.now()),
    ),
    DateFilter(
      AppLocalizations.instance.text('TXT_LAST_30_DAYS'),
      '${DateFormat('dd MMM').format(DateTime.now().subtract(Duration(days: 30)))} - ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
    ),
    DateFilter(
      AppLocalizations.instance.text('TXT_LAST_90_DAYS'),
      '${DateFormat('dd MMM').format(DateTime.now().subtract(Duration(days: 90)))} - ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
    ),
    DateFilter(
      AppLocalizations.instance.text('TXT_CHOOSE_DATE'),
      '',
    ),
  ];

  int selectedDateFilter = 0;
  bool isCustomDate = false;

  LoadingView? _view;

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnInitStatusOrder() {
    status = 1;
    notifyListeners();
  }

  Future fnFetchTransactionList() async {
    _view!.onProgressStart();

    super.currentPage = 1;

    transactionList = (await _service.getTransactionList(
      startDate: fromDate != null
          ? DateFormat('yyyy-MM-dd').format(fromDate ?? DateTime.now())
          : null,
      endDate: toDate != null
          ? DateFormat('yyyy-MM-dd').format(toDate ?? DateTime.now())
          : null,
      status: status,
      page: super.currentPage.toString(),
    ))!;

    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnOnTabSelected(int value) async {
    this.status = value;
    await fnFetchTransactionList();
    notifyListeners();
  }

  // Future fnFinishPayment(BuildContext context) async {
  //   _view!.onProgressStart();
  //   var _res = await _paymentService.midtransPayment(code: transactionList.result?.data?[0].codeTransaction ?? null);
  //
  //   if (_res!.status != null) {
  //     if (_res.status == true) {
  //       _view!.onProgressFinish();
  //       await Get.toNamed(MidtransWebviewScreen.tag, arguments: MidtransWebviewScreen(url: _res.data?.redirectUrl,));
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

  fnOnSelectDateFilter(int value) {
    this.selectedDateFilter = value;
    isFiltered = true;

    if (selectedDateFilter == 0) {
      isCustomDate = false;
      fromDateController.clear();
      toDateController.clear();
      fromDate = null;
      toDate = null;
    } else if (selectedDateFilter == 1) {
      isCustomDate = false;
      fromDateController.clear();
      toDateController.clear();
      fromDate = DateTime.now();
      toDate = DateTime.now();
    } else if (selectedDateFilter == 2) {
      isCustomDate = false;
      fromDateController.clear();
      toDateController.clear();
      fromDate = DateTime.now().subtract(Duration(days: 30));
      toDate = DateTime.now();
    } else if (selectedDateFilter == 3) {
      isCustomDate = false;
      fromDateController.clear();
      toDateController.clear();
      fromDate = DateTime.now().subtract(Duration(days: 90));
      toDate = DateTime.now();
    } else if (selectedDateFilter == 4) {
      isFiltered = false;
      isCustomDate = true;
      fromDateController.clear();
      toDateController.clear();
    } else {}
    notifyListeners();
  }

  fnOnSelectCustomDate(DateRangePickerSelectionChangedArgs args, String flag) {
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

  fnInitFilter() {
    isFiltered = false;
    notifyListeners();
  }

  Future fnOnSubmitFilter(BuildContext context) async {
    DateTime? _from = fromDate;
    DateTime? _to = toDate;

    if (_from != null || _to != null) {
      _from = _from ?? DateTime.now();
      _to = _to ?? DateTime.now();
      bool _isValid = (_from).isBefore((_to));

      if (_isValid) {
        Get.back();
        _view!.onProgressStart();
        transactionList = (await _service.getTransactionList(
          startDate: DateFormat('yyyy-MM-dd').format(_from),
          endDate: DateFormat('yyyy-MM-dd').format(_to),
          status: status,
          page: super.currentPage.toString(),
        ))!;
        _view!.onProgressFinish();
      } else {
        CustomWidget.showSnackBar(
            context: context, content: Text('Invalid date'));
      }
    } else {
      Get.back();
      _view!.onProgressStart();
      transactionList = (await _service.getTransactionList(
        startDate: null,
        endDate: null,
        status: status,
        page: super.currentPage.toString(),
      ))!;
      _view!.onProgressFinish();
    }
    notifyListeners();
  }

  String? fnGetDateFilterSubtitle() {
    if (selectedDateFilter == 1) {
      return DateFormat('dd MMM yyyy').format(DateTime.now());
    } else if (selectedDateFilter == 2) {
      return '${DateFormat('dd MMM').format(DateTime.now().subtract(Duration(days: 30)))} - ${DateFormat('dd MMM yyyy').format(DateTime.now())}';
    } else if (selectedDateFilter == 3) {
      return '${DateFormat('dd MMM').format(DateTime.now().subtract(Duration(days: 30)))} - ${DateFormat('dd MMM yyyy').format(DateTime.now())}';
    } else {
      return null;
    }
  }

  String fnGetStatus(int id) {
    switch (id) {
      case 1:
        return AppLocalizations.instance.text('TXT_LBL_PAYMENT');
      case 2:
        return AppLocalizations.instance.text('TXT_LBL_CONFIRMATION');
      case 3:
        return AppLocalizations.instance.text('TXT_LBL_PROCESSED');
      case 4:
        return AppLocalizations.instance.text('TXT_LBL_DELIVERY');
      case 6:
        return AppLocalizations.instance.text('TXT_LBL_COMPLETE');
      case 7:
        return AppLocalizations.instance.text('TXT_LBL_CANCELED');
      default:
        return '-';
    }
  }

  Future fnOnReceiveNotification() async {
    FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) async => await fnFetchTransactionList());
    notifyListeners();
  }

  Future fnStoreCart(BuildContext context, int index) async {
    List<int> _productIdList = [];
    var _detail = await _service.getTransactionDetail(
      regionId: transactionList.result?.data?[index].idRegion ?? 0,
      orderId: transactionList.result?.data?[index].codeTransaction ?? '',
    );
    List.generate(
        _detail?.result?.data?.length ?? 0,
        (index) =>
            _productIdList.add(_detail?.result?.data?[index].idProduct ?? 0));

    var _res = await _cartService.storeCart(
      regionIds: [transactionList.result?.data?[index].idRegion ?? 0],
      productIds: _productIdList,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        await CustomWidget.showSnackBar(
          context: context,
          content: Text(AppLocalizations.instance.text('TXT_CART_ADD_INFO')),
          duration: 4,
          action: SnackBarAction(
            label: 'Go to cart',
            textColor: Colors.white,
            onPressed: () =>
                Get.offNamedUntil(BaseHomeScreen.tag, (route) => false,
                    arguments: BaseHomeScreen(
                      pageIndex: 2,
                    )),
          ),
        );
      } else {
        await CustomWidget.showSnackBar(
            context: context, content: Text(_res.message.toString()));
      }
    } else {
      await CustomWidget.showSnackBar(
          context: context,
          content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
  }

  @override
  Future fnShowNextPage() async {
    onPaginationLoadStart();
    super.currentPage++;

    var _list = await _service.getTransactionList(
      startDate: fromDate != null
          ? DateFormat('yyyy-MM-dd').format(fromDate ?? DateTime.now())
          : null,
      endDate: toDate != null
          ? DateFormat('yyyy-MM-dd').format(toDate ?? DateTime.now())
          : null,
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
  final int id;
  final IconData icon;

  TabLabel(this.label, this.id, this.icon);
}

class DateFilter {
  final String title;
  final String subTitle;

  DateFilter(this.title, this.subTitle);
}

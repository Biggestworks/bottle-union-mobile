import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/formatter_helper.dart';
import 'package:eight_barrels/helper/key_helper.dart';
import 'package:eight_barrels/model/transaction/transaction_detail_model.dart';
import 'package:eight_barrels/screen/transaction/transaction_detail_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/review/review_service.dart';
import 'package:eight_barrels/service/transaction/transcation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TransactionDetailProvider extends ChangeNotifier {
  TransactionService _service = new TransactionService();
  // PaymentService _paymentService = new PaymentService();
  ReviewService _reviewService = new ReviewService();
  String? orderId;
  int? regionId;
  TransactionDetailModel transactionDetail = new TransactionDetailModel();

  double starRating = 0.0;
  String ratingInfo = '';
  TextEditingController commentController = new TextEditingController();

  String? locale;
  int? selectedProductId;

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as TransactionDetailScreen;
    orderId = _args.orderId!;
    regionId = _args.regionId!;
    notifyListeners();
  }

  Future fnGetTransactionDetail() async {
    _view!.onProgressStart();
    transactionDetail = (await _service.getTransactionDetail(orderId: orderId!, regionId: regionId!))!;
    _view!.onProgressFinish();
    notifyListeners();
  }

  // Future fnFinishPayment(BuildContext context) async {
  //   _view!.onProgressStart();
  //   var _res = await _paymentService.midtransPayment(code: transactionDetail.result?.codeTransaction ?? null);
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

  String fnGetSubtotal(int price, int qty) => FormatterHelper.moneyFormatter((price * qty));

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

  Future fnFinishOrder(BuildContext context) async {
    _view!.onProgressStart();
    var _res = await _service.finishOrder(orderId: orderId, regionId: regionId);
    if (_res!.status != null) {
      if (_res.status == true) {
        _view!.onProgressFinish();
        await fnGetTransactionDetail();
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

  fnOnChangeRating(double rating) {
    this.starRating = rating;
    notifyListeners();
  }

  Widget fnGetRatingInfo(BuildContext context) {
    if (starRating == 1.0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.white, CustomColor.STAR_1, CustomColor.STAR_1, CustomColor.STAR_1, Colors.white],
          ),
        ),
        child: Text(AppLocalizations.instance.text('TXT_STAR_REVIEW_1'), style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ), textAlign: TextAlign.center,),
      );
    } else if (starRating == 2.0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.white, CustomColor.STAR_1, CustomColor.STAR_1, CustomColor.STAR_1, Colors.white],
          ),
        ),
        child: Text(AppLocalizations.instance.text('TXT_STAR_REVIEW_2'), style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ), textAlign: TextAlign.center,),
      );
    } else if (starRating == 3.0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.white, CustomColor.STAR_3, CustomColor.STAR_3, CustomColor.STAR_3, Colors.white],
          ),
        ),
        child: Text(AppLocalizations.instance.text('TXT_STAR_REVIEW_3'), style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ), textAlign: TextAlign.center,),
      );
    } else if (starRating == 4.0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.white, CustomColor.STAR_5, CustomColor.STAR_5, CustomColor.STAR_5, Colors.white],
          ),
        ),
        child: Text(AppLocalizations.instance.text('TXT_STAR_REVIEW_4'), style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ), textAlign: TextAlign.center,),
      );
    } else if (starRating == 5.0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.white, CustomColor.STAR_5, CustomColor.STAR_5, CustomColor.STAR_5, Colors.white],
          ),
        ),
        child: Text(AppLocalizations.instance.text('TXT_STAR_REVIEW_5'), style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ), textAlign: TextAlign.center,),
      );
    } else {
      return SizedBox();
    }
  }

  fnGetTotalPrice(int pay, int deliveryCost) => FormatterHelper.moneyFormatter(pay - deliveryCost);

  Future fnGetLocale() async {
    final _storage = new FlutterSecureStorage();
    locale = await _storage.read(key: KeyHelper.KEY_LOCALE);
    notifyListeners();
  }

  fnOnSelectProduct(int value) {
    this.selectedProductId = value;
    notifyListeners();
  }

  fnInitReviewValue() {
    if (transactionDetail.result?.data != null) {
      if ((transactionDetail.result?.data?.length ?? 0) == 1) {
        selectedProductId = transactionDetail.result?.data?[0].idProduct;
      } else {
        selectedProductId = null;
      }
    } else {
      selectedProductId = null;
    }
    starRating = 0;
    commentController.clear();
    notifyListeners();
  }

  Future fnStoreReview(BuildContext context) async {
    _view!.onProgressStart();
    print(selectedProductId);
    var _res = await _reviewService.storeReview(
      productId: selectedProductId ?? 0,
      rating: starRating.toInt(),
      comment: commentController.text,
    );

    if (_res!.status != null) {
      if (_res.status == true) {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(context: context, content: Text('Thank you for reviewing'));
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message != null ? _res.message.toString() : ''));
      }
    } else {
      _view!.onProgressFinish();
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
    _view!.onProgressFinish();
    notifyListeners();
  }

}
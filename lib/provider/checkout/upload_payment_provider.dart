import 'dart:io';

import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/helper/image_helper.dart';
import 'package:eight_barrels/screen/checkout/upload_payment_screen.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:eight_barrels/screen/success_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/transaction/transcation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class UploadPaymentProvider extends ChangeNotifier {
  TransactionService _service = new TransactionService();
  PictureProvider _pictureProvider = new PictureProvider();

  File? imageFile;
  String? orderId;
  String? orderDate;
  String? totalPay;

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as UploadPaymentScreen;
    orderId = _args.orderId;
    orderDate = _args.orderDate;
    totalPay = _args.totalPay;
    notifyListeners();
  }

  Future fnUploadImage(BuildContext context) async {
    final tempImage = await _pictureProvider.showChoiceDialog(context);
    if (tempImage != null) {
      imageFile = tempImage;
    }
    notifyListeners();
  }

  Future fnUploadPayment(BuildContext context) async {
    _view!.onProgressStart();
    var _res = await _service.uploadPayment(orderId: orderId!, image: imageFile!);

    if (_res!.status != null) {
      if (_res.status == true) {
        Get.toNamed(SuccessScreen.tag, arguments: SuccessScreen(
          message: AppLocalizations.instance.text('TXT_UPLOAD_PAYMENT_SUCCESS'),
          orderId: orderId,
        ));
        _view!.onProgressFinish();
      } else {
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message.toString()));
        _view!.onProgressFinish();
      }
    } else {
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
      _view!.onProgressFinish();
    }
    _view!.onProgressFinish();
    notifyListeners();
  }

}
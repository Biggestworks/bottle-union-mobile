import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart';
import 'package:eight_barrels/screen/discussion/add_discussion_screen.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/discussion/discussion_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class AddDiscussionProvider extends ChangeNotifier {
  DiscussionService _service = new DiscussionService();
  Data? product;
  TextEditingController questionController = new TextEditingController();

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as AddDiscussionScreen;
    product = _args.product;
    notifyListeners();
  }

  Future fnStoreDiscussion(BuildContext context) async {
    _view!.onProgressStart();
    var _res = await _service.storeDiscussion(
      productId: product!.id!,
      comment: questionController.text,
    );

    if (_res?.status != null) {
      if (_res?.status == true) {
        _view!.onProgressFinish();
        Get.back(result: true);
      } else {
        _view!.onProgressFinish();
        await CustomWidget.showSnackBar(context: context, content: Text(_res?.message ?? '-'));
      }
    } else {
      _view!.onProgressFinish();
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
    _view!.onProgressFinish();
    notifyListeners();
  }

}
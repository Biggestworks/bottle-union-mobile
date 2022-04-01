import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/model/product/discussion_list_model.dart';
import 'package:eight_barrels/model/product/product_detail_model.dart' as productDetail;
import 'package:eight_barrels/screen/discussion/discussion_screen.dart';
import 'package:eight_barrels/service/discussion/discussion_service.dart';
import 'package:flutter/material.dart';

class DiscussionProvider extends ChangeNotifier {
  DiscussionService _service = new DiscussionService();
  DiscussionListModel discussionList = new DiscussionListModel();
  productDetail.Data? product;

  LoadingView? _view;

  fnGetView(LoadingView view) {
    this._view = view;
  }

  fnGetArguments(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as DiscussionScreen;
    product = _args.product;
    notifyListeners();
  }

  Future fnFetchDiscussionList() async {
    _view!.onProgressStart();
    if (product != null) {
      discussionList = (await _service.getDiscussionList(productId: product?.id ?? 0))!;
    }
    _view!.onProgressFinish();
    notifyListeners();
  }
}
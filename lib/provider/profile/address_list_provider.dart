import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/app_localization.dart';
import 'package:eight_barrels/model/address/address_list_model.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:eight_barrels/service/address/address_service.dart';
import 'package:flutter/material.dart';

class AddressListProvider extends ChangeNotifier {
  AddressService _service = new AddressService();
  AddressListModel addressList = new AddressListModel();
  TextEditingController searchController = new TextEditingController();

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  Future fnFetchAddressList() async {
    _view!.onProgressStart();

    addressList = (await _service.getAddress(search: searchController.text))!;

    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnDeleteAddress(BuildContext context, int id) async {
    var _res = (await _service.deleteAddress(id: id))!;

    if (_res.status != null) {
      if (_res.status == true) {
        await fnFetchAddressList();
        await CustomWidget.showSnackBar(context: context, content: Text('Success delete'));
      } else {
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message.toString().toString()));
      }
    } else {
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
    notifyListeners();
  }

  Future fnSelectAddress(BuildContext context, int id) async {
    var _res = (await _service.selectAddress(id: id))!;

    if (_res.status != null) {
      if (_res.status == true) {
        await fnFetchAddressList();
        await CustomWidget.showSnackBar(context: context, content: Text('Success select address'));
      } else {
        await CustomWidget.showSnackBar(context: context, content: Text(_res.message.toString()));
      }
    } else {
      await CustomWidget.showSnackBar(context: context, content: Text(AppLocalizations.instance.text('TXT_MSG_ERROR')));
    }
    notifyListeners();
  }

  Future fnOnSearchAddress() async {
    await fnFetchAddressList();
    notifyListeners();
  }

}
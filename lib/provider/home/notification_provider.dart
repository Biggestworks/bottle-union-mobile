import 'package:badges/badges.dart';
import 'package:eight_barrels/abstract/loading.dart';
import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/db_helper.dart';
import 'package:eight_barrels/helper/user_preferences.dart';
import 'package:eight_barrels/model/notification/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  DbHelper _dbHelper = new DbHelper();
  UserPreferences _userPreferences = new UserPreferences();
  List<NotificationModel> notificationList = [];
  int infoCount = 0;
  int promoCount = 0;

  LoadingView? _view;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  fnGetView(LoadingView view) {
    this._view = view;
  }

  Future fnGetNotification() async {
    _view!.onProgressStart();
    var _user = await _userPreferences.getUserData();
    notificationList = (await _dbHelper.getNotification(userId: _user?.user?.id.toString() ?? ''))!;
    infoCount = notificationList.where((i) => i.type == 'info' && i.isNew == 1).length;
    promoCount = notificationList.where((i) => i.type == 'promo' && i.isNew == 1).length;
    _view!.onProgressFinish();
    notifyListeners();
  }

  Future fnOnReadNotification(int notificationId) async {
    await _dbHelper.updateNotificationStatus(notificationId: notificationId.toString());
    infoCount = notificationList.where((i) => i.type == 'info' && i.isNew == 1).length;
    promoCount = notificationList.where((i) => i.type == 'promo' && i.isNew == 1).length;
    notifyListeners();
  }

  Future fnOnTabSelected(int value) async {
    // this.status = value;
    // await fnFetchTransactionList();
    notifyListeners();
  }

}
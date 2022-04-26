import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:eight_barrels/screen/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_localization.dart';

enum NetworkStatus { Online, Offline }

class NetworkConnectionHelper {
  final Connectivity connectivity = new Connectivity();

  Future initConnectivity({
    required StreamSubscription<ConnectivityResult>? subscription,
    required BuildContext context,
  }) async {
    subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result) async {
      print(result);
      if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
        try {
          final _res = await InternetAddress.lookup(dotenv.get('BASE_URL', fallback: 'BASE_URL not found'));
          if (_res.isNotEmpty) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            CustomWidget.showSnackBar(
              context: context,
              content: ListTile(
                title: Text('You are connected', style: TextStyle(
                    color: Colors.white
                ),),
                leading: Icon(Icons.wifi, color: Colors.white,),
                dense: true,
              ),
            );
          }
        } on SocketException catch (_) {
          CustomWidget.showInfoPopup(context, desc: AppLocalizations.instance.text('TXT_REGION_PREFERENCE_INFO'));
          // ScaffoldMessenger.of(context).hideCurrentSnackBar();
          // CustomWidget.showSnackBar(
          //   context: context,
          //   content: ListTile(
          //     title: Text('No Connection 1', style: TextStyle(
          //       color: Colors.white,
          //     ),),
          //     leading: Icon(Icons.wifi_off, color: Colors.white,),
          //     dense: true,
          //   ),
          //   duration: 10,
          // );
        }
      } else if (result == ConnectivityResult.none) {
        CustomWidget.showInfoPopup(context, desc: AppLocalizations.instance.text('TXT_REGION_PREFERENCE_INFO'));
        // ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // CustomWidget.showSnackBar(
        //   context: context,
        //   content: ListTile(
        //     title: Text('No Connection 2', style: TextStyle(
        //       color: Colors.white,
        //     ),),
        //     leading: Icon(Icons.wifi_off, color: Colors.white,),
        //     dense: true,
        //   ),
        //   duration: 10,
        // );
      }
    });
  }
}
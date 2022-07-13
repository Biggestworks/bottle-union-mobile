import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


class NetworkConnectionHelper {
  Future checkConnection({
    required StreamSubscription<InternetConnectionStatus>? subscription,
    required BuildContext context,
  }) async {
    subscription = InternetConnectionChecker().onStatusChange.listen((status) async {
      switch (status) {
        case InternetConnectionStatus.disconnected:
          Get.snackbar(
            'error (400)',
            'You seems to be offline. Please check your connection.',
            backgroundColor: Colors.black,
            colorText: Colors.white,
            animationDuration: Duration(seconds: 1),
            snackStyle: SnackStyle.GROUNDED,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.zero,
          );
          break;
        default:
          break;
      }
    });
  }
}
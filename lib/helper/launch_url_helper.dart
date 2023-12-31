// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUrlHelper {
  static Future launchUrl(
      {required BuildContext context, required String url}) async {
    // if (await canLaunch(url)) {
    bool _isLaunch = await launch(
      url,
      forceSafariVC: false,
      universalLinksOnly: true,
    );
    if (!_isLaunch) {
      await launch(
        url,
        forceSafariVC: true,
      );
    }
    // } else {
    //   await CustomWidget.showSnackBar(
    //       context: context, content: Text('Cannot launch $url'));
    // }
  }
}

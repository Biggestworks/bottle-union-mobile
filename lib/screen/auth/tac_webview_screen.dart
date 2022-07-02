import 'dart:io';

import 'package:eight_barrels/helper/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TacWebviewScreen extends StatefulWidget {
  static String tag = '/tac-webview-screen';

  const TacWebviewScreen({Key? key}) : super(key: key);

  @override
  _TacWebviewScreenState createState() => _TacWebviewScreenState();
}

class _TacWebviewScreenState extends State<TacWebviewScreen> {

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.MAIN,
        centerTitle: true,
        title: Text('Term & Condition'),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: dotenv.get('TOC_URL'),
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}

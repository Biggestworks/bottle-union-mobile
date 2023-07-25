import 'dart:io';

import 'package:eight_barrels/helper/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FbWebviewScreen extends StatefulWidget {
  static String tag = '/fb-webview-screen';

  const FbWebviewScreen({Key? key}) : super(key: key);

  @override
  _FbWebviewScreenState createState() => _FbWebviewScreenState();
}

class _FbWebviewScreenState extends State<FbWebviewScreen> {
  WebViewController webViewController = WebViewController();

  @override
  void initState() {
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    setState(() {
      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              // if (request.url.startsWith(dotenv.get('TOC_URL').toString())) {
              //   return NavigationDecision.prevent;
              // }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(dotenv.get('ROC_URL').toString()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.MAIN,
        centerTitle: true,
        title: Text('Refund Policy'),
      ),
      body: WebViewWidget(
        controller: webViewController,
      ),
    );
  }
}

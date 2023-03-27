import 'dart:io';

import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/screen/home/base_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidtransWebviewScreen extends StatefulWidget {
  static String tag = '/midtrans-webview-screen';
  final String? url;

  const MidtransWebviewScreen({Key? key, this.url}) : super(key: key);

  @override
  _MidtransWebviewScreenState createState() => _MidtransWebviewScreenState();
}

class _MidtransWebviewScreenState extends State<MidtransWebviewScreen> {
  var webViewController = WebViewController();

  @override
  void initState() {
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _args =
        ModalRoute.of(context)!.settings.arguments as MidtransWebviewScreen;

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
            if (request.url.startsWith(_args.url.toString())) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_args.url.toString()));

    return WillPopScope(
      onWillPop: () async {
        Get.offNamedUntil(BaseHomeScreen.tag, (route) => false,
            arguments: BaseHomeScreen(pageIndex: 3));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.MAIN,
        ),
        body: SafeArea(
          child: WebViewWidget(
            controller: webViewController,
          ),
        ),
      ),
    );
  }
}

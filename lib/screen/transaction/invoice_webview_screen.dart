import 'dart:io';

import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/helper/launch_url_helper.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InvoiceWebviewScreen extends StatefulWidget {
  static String tag = '/invoice-webview-screen';
  final String? url;

  const InvoiceWebviewScreen({Key? key, this.url}) : super(key: key);

  @override
  _InvoiceWebviewScreenState createState() => _InvoiceWebviewScreenState();
}

class _InvoiceWebviewScreenState extends State<InvoiceWebviewScreen> {
  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _args =
        ModalRoute.of(context)!.settings.arguments as InvoiceWebviewScreen;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.MAIN,
        centerTitle: true,
        title: Text('Invoice'),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 10),
        //     child: IconButton(
        //       onPressed: () async {},
        //       icon: Icon(Icons.file_download, size: 26,),
        //       visualDensity: VisualDensity.compact,
        //     ),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: _args.url,
          navigationDelegate: (a) async {
            await LaunchUrlHelper.launchUrl(context: context, url: a.url);
            return NavigationDecision.prevent;
          },
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}

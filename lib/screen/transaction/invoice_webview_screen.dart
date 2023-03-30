import 'package:eight_barrels/helper/color_helper.dart';

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
  WebViewController webViewController = WebViewController();
  @override
  void initState() {
    // if (Platform.isAndroid) WebViewWidget.fromPlatform(platform: PlatformWeb) = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _args =
        ModalRoute.of(context)!.settings.arguments as InvoiceWebviewScreen;

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
        child: WebViewWidget(
          controller: webViewController,
        ),
      ),
    );
  }
}

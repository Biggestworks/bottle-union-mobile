import 'package:eight_barrels/helper/color_helper.dart';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'dart:io' show Platform;

class InvoiceWebviewScreen extends StatefulWidget {
  static String tag = '/invoice-webview-screen';
  final String? url;

  const InvoiceWebviewScreen({Key? key, this.url}) : super(key: key);

  @override
  _InvoiceWebviewScreenState createState() => _InvoiceWebviewScreenState();
}

class _InvoiceWebviewScreenState extends State<InvoiceWebviewScreen> {
  WebViewController webViewController = WebViewController();
  late final PlatformWebViewControllerCreationParams params;

  @override
  void initState() {
    // if (Platform.isAndroid) WebViewWidget.fromPlatform(platform: PlatformWeb) = SurfaceAndroidWebView();
    Future.delayed(Duration.zero).then((value) {
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        setState(() {
          params = WebKitWebViewControllerCreationParams(
            allowsInlineMediaPlayback: true,
            mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
          );
        });
      } else {
        setState(() {
          params = const PlatformWebViewControllerCreationParams();
        });
      }

      if (webViewController.platform is AndroidWebViewController) {
        setState(() {
          AndroidWebViewController.enableDebugging(true);
          (webViewController.platform as AndroidWebViewController)
              .setMediaPlaybackRequiresUserGesture(false);
        });
      }

      setState(() {
        webViewController =
            WebViewController.fromPlatformCreationParams(params);
        final _args =
            ModalRoute.of(context)!.settings.arguments as InvoiceWebviewScreen;
        print(_args.url);
        webViewController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {},
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (_args.url.toString().contains('gojek')) {
                  return NavigationDecision.navigate;
                } else if (request.url.startsWith(_args.url.toString())) {
                  return NavigationDecision.navigate;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(_args.url.toString()));
      });
    });

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
        title: Text(
          _args.url.toString().contains('gojek') ? "GoSend Track" : 'Invoice ',
        ),
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

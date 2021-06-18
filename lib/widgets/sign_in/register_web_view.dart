import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

class RegisterWebView extends StatefulWidget {
  @override
  _RegisterWebViewState createState() => _RegisterWebViewState();
}

class _RegisterWebViewState extends State<RegisterWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: FlavorConfig.instance.values.questionnaireUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      onProgress: (int progress) {
        debugPrint("WebView is loading (progress : $progress%)");
      },
      javascriptChannels: <JavascriptChannel>{
        _toasterJavascriptChannel(context),
      },
      navigationDelegate: (NavigationRequest request) {
        /*if (!request.url
                  .startsWith(FlavorConfig.instance.values.questionnaireUrl)) {
                debugPrint('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }*/
        debugPrint('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        debugPrint('Page started loading: $url');
      },
      onPageFinished: (String url) {
        debugPrint('Page finished loading: $url');
      },
      gestureNavigationEnabled: true,
    );
  }
}

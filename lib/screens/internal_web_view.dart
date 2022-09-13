import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/screens/authentication/sign_in.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'dart:io';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

class InternalWebView extends StatefulWidget {
  static const String id = "register_web_view";
  @override
  _InternalWebViewState createState() => _InternalWebViewState();
}

class _InternalWebViewState extends State<InternalWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) =>
      JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final link = ModalRoute.of(context)?.settings.arguments as String? ?? "";

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryColor,
      body: SafeArea(
        child: WebView(
          initialUrl: link,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
            // We need to reset the cookies so that a new session will be
            // created, just in case a second account may be logged in
            final cookieManager = CookieManager();
            cookieManager.clearCookies();
          },
          onProgress: (int progress) {
            debugPrint("WebView is loading (progress : $progress%)");
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          navigationDelegate: (NavigationRequest request) {
            debugPrint('allowing navigation to $request');
            if (request.url.contains("/subscribed")) {
              showAlertDialog(
                context,
                "Success",
                "Your account is successfully subscribed. Please return to the sign in page.",
                "",
                "Return to Sign In",
                (BuildContext context) {
                  Navigator.pushReplacementNamed(
                    context,
                    SignIn.id,
                  );
                },
                null,
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
          zoomEnabled: false,
        ),
      ),
    );
  }
}

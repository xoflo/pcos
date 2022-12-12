
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../styles/colors.dart';


final InAppLocalhostServer localhostServer = new InAppLocalhostServer();

class ZendeskWebView extends StatefulWidget {
  static const String id = "zendesk_web_view";

  @override
  _ZendeskWebViewState createState() => _ZendeskWebViewState();
}

class _ZendeskWebViewState extends State<ZendeskWebView> {

  @override
  void initState() {
    super.initState();

    startLocalServer();
  }

  void startLocalServer() async {
    // start the localhost server
    await localhostServer.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: primaryColor,
        body: SafeArea(
            child: InAppWebView(
              initialFile: "assets/html/zendesk.html",
              // initialUrlRequest: URLRequest(
              //     url: Uri.parse("http://localhost:8080/assets/zendesk.html")
              // ),
            )
        )
    );
  }
}
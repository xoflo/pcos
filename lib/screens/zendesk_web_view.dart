
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../styles/colors.dart';
import '../widgets/shared/header.dart';


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

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: primaryColor,
        body: SafeArea(
            child: Column(
              children: [
                Header(
                  title: "Zendesk",
                  closeItem: () => Navigator.pop(context),
                ),
                Expanded(
                  child: InAppWebView(
                    initialFile: "assets/html/zendesk.html",
                  ),
                ),
              ],
            )
        )
    );
  }
}
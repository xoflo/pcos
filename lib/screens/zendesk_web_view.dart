import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../controllers/authentication_controller.dart';
import '../styles/colors.dart';
import '../widgets/shared/header.dart';

final InAppLocalhostServer localhostServer = new InAppLocalhostServer();

class ZendeskWebView extends StatefulWidget {
  static const String id = "zendesk_web_view";

  @override
  _ZendeskWebViewState createState() => _ZendeskWebViewState();
}

class _ZendeskWebViewState extends State<ZendeskWebView> {
  String? _userId;
  String? _userName;

  @override
  void initState() {
    super.initState();

    getUserDetails();
  }

  void getUserDetails() async {
    final authenticationController = AuthenticationController();

    _userId = await authenticationController.getUserId() ?? "unknown-user-id";
    _userName = await authenticationController.getUsername() ?? "unknown-user-name";
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
                onLoadStop: (controller, url) {
                  // Tag the chat session with the username and userId to help
                  // the Ovie team manage Zendesk sessions.
                  //
                  // https://developer.zendesk.com/api-reference/widget/chat-api/#chataddtags
                  controller.evaluateJavascript(
                      source: "zE('webWidget', 'chat:addTags', ['$_userName', '$_userId'])");
                },
              ),
            ),
          ],
        )));
  }
}

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:thepcosprotocol_app/constants/zendesk_jwt_key.dart';

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

    _userId = await authenticationController.getUserId();
    _userName = await authenticationController.getUsername();
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
                onLoadStop: (controller, url) async {
                  // Add a bit of a delay, so the app only attempts to login
                  // after the Zendesk web widget finishes loading.
                  await Future.delayed(const Duration(seconds: 2));

                  final token = issueZendeskJWT();
                  if (token != null) {
                    // https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/web/sdk_api_reference/#authentication
                    controller.evaluateJavascript(source: """
                      zE('messenger', 'loginUser', function (callback) {
                        callback('$token');
                        });
                        """);
                  }
                },
              ),
            ),
          ],
        )));
  }

  // TODO: A better/more secure appraoch is to have the server issue the JWT
  String? issueZendeskJWT() {
    // https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/web/enabling_auth_visitors/
    if (_userName != null && _userId != null) {
      final jwt = JWT({
        "scope": "user",
        "name": _userName,
        "external_id": _userId,
      }, header: {
        "alg": "HS256",
        "typ": "JWT",
        "kid": ZendeskAppId,
      });

      return jwt.sign(SecretKey(ZendeskJWTKey));
    }

    return null;
  }
}

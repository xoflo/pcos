import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/notifications/messages_layout.dart';

class Notifications extends StatelessWidget {
  static const String id = "notifications_screen";

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryColor,
        body: WillPopScope(
          onWillPop: () async => !Platform.isIOS,
          child: SafeArea(
            child: MessagesLayout(),
          ),
        ),
      );
}

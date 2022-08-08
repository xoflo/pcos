import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/notifications/messages_layout.dart';

class Notifications extends StatelessWidget {
  static const String id = "notifications_screen";

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryColor,
        body: WillPopScope(
          onWillPop: () async => Platform.isIOS ? false : true,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 12,
                ),
                child: MessagesLayout(),
              ),
            ),
          ),
      );
}

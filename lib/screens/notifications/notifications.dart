import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/notifications/messages_layout.dart';

class Notifications extends StatelessWidget {
  static const String id = "notifications_screen";

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryColor,
        body: WillPopScope(
          onWillPop: () async => false,
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

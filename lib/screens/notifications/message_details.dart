import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/widgets/notifications/message_details_layout.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class MessageDetails extends StatelessWidget {
  final Message message;
  final Function closeMessage;
  final Function(Message) deleteMessage;

  MessageDetails({
    required this.message,
    required this.closeMessage,
    required this.deleteMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: WillPopScope(
        onWillPop: () async => !Platform.isIOS,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: 12.0,
            ),
            child: MessageDetailsLayout(
              message: message,
              closeMessage: closeMessage,
              deleteMessage: deleteMessage,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/messages/messages_layout.dart';
import 'package:thepcosprotocol_app/providers/messages_provider.dart';

class Messages extends StatelessWidget {
  final MessagesProvider messagesProvider;
  final Function closeMenuItem;

  Messages({this.messagesProvider, this.closeMenuItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: MessagesLayout(
            messagesProvider: messagesProvider,
            closeMenuItem: closeMenuItem,
          ),
        ),
      ),
    );
  }
}

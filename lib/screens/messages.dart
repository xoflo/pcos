import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/messages/messages_layout.dart';

class Messages extends StatelessWidget {
  final Function closeMenuItem;

  Messages({this.closeMenuItem});

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
            closeMenuItem: closeMenuItem,
          ),
        ),
      ),
    );
  }
}

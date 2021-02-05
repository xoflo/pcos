import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/message.dart';

class MessagesList extends StatelessWidget {
  final List<Message> messages;

  MessagesList({this.messages});

  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Messages here. count=${messages.length}"));
  }
}

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/providers/messages_provider.dart';
import 'package:thepcosprotocol_app/widgets/messages/messages_list_item.dart';

class MessagesList extends StatelessWidget {
  final MessagesProvider messagesProvider;
  final Function(BuildContext, MessagesProvider, Message) openMessage;

  MessagesList({this.messagesProvider, this.openMessage});

  void _openMessage(final BuildContext context, final Message message) {
    openMessage(context, messagesProvider, message);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            height: constraints.maxHeight,
            child: SingleChildScrollView(
              child: Column(
                children: messagesProvider.items.map((Message message) {
                  return MessagesListItem(
                    message: message,
                    width: constraints.maxWidth,
                    openMessageDetails: _openMessage,
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

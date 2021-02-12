import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/providers/messages_provider.dart';
import 'package:thepcosprotocol_app/widgets/messages/messages_list_item.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';

class MessagesList extends StatelessWidget {
  final MessagesProvider messagesProvider;
  final Size screenSize;
  final Function(MessagesProvider, Message) openMessage;

  MessagesList({this.messagesProvider, this.screenSize, this.openMessage});

  void _openMessage(final Message message) {
    openMessage(messagesProvider, message);
  }

  @override
  Widget build(BuildContext context) {
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        height: DeviceUtils.getRemainingHeight(
            MediaQuery.of(context).size.height,
            false,
            isHorizontal,
            false,
            false),
        child: SingleChildScrollView(
          child: Column(
            children: messagesProvider.items.map((Message message) {
              return MessagesListItem(
                message: message,
                width: screenSize.width,
                openMessageDetails: _openMessage,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

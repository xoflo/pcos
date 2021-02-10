import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/widgets/messages/messages_list_item.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';

class MessagesList extends StatelessWidget {
  final List<Message> messages;
  final Size screenSize;
  final Function(Message) openMessage;

  MessagesList({this.messages, this.screenSize, this.openMessage});

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
            children: messages.map((Message message) {
              return MessagesListItem(
                message: message,
                width: screenSize.width,
                openMessageDetails: openMessage,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

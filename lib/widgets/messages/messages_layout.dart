import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/widgets/messages/messages_list.dart';
import 'package:thepcosprotocol_app/models/message.dart';

class MessagesLayout extends StatefulWidget {
  final Function closeMenuItem;

  MessagesLayout({this.closeMenuItem});

  @override
  _MessagesLayoutState createState() => _MessagesLayoutState();
}

class _MessagesLayoutState extends State<MessagesLayout> {
  List<Message> getMessages() {
    List<Message> messages = List<Message>();
    final Message message1 = Message(
        title: "This is a new message.",
        text: "Hi, we sent you a message, hope you like it.",
        isRead: false);
    final Message message2 = Message(
        title: "This is another message.",
        text: "This is the second message.",
        isRead: false);
    messages.add(message1);
    messages.add(message2);
    return messages;
  }

  Widget getMessagesList(Size screenSize) {
    final LoadingStatus tempStatus = LoadingStatus.success;
    switch (tempStatus) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.of(context).noNotifications);
      case LoadingStatus.success:
        return MessagesList(
          messages: getMessages(),
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(
            itemId: 0,
            favouriteType: FavouriteType.None,
            title: S.of(context).messagesTitle,
            isFavourite: false,
            closeItem: widget.closeMenuItem,
          ),
          getMessagesList(screenSize),
        ],
      ),
    );
  }
}

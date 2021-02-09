import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/screens/message_details.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/messages/messages_list.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/providers/messages_provider.dart';

class MessagesLayout extends StatefulWidget {
  final MessagesProvider messagesProvider;
  final Function closeMenuItem;

  MessagesLayout({this.messagesProvider, this.closeMenuItem});

  @override
  _MessagesLayoutState createState() => _MessagesLayoutState();
}

class _MessagesLayoutState extends State<MessagesLayout> {
  Widget getMessagesList(
      final Size screenSize, final MessagesProvider messagesProvider) {
    switch (messagesProvider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.of(context).noNotifications);
      case LoadingStatus.success:
        return MessagesList(
          messages: messagesProvider.items,
          openMessage: openMessage,
          screenSize: screenSize,
        );
    }
    return Container();
  }

  void openMessage(final Message message) {
    debugPrint("OPEN MESSAGE ${message.title}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetails(
          message: message,
          closeMessage: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
    //TODO: mark message AsRead = true
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(
            title: S.of(context).messagesTitle,
            closeItem: widget.closeMenuItem,
            showMessagesIcon: true,
            unreadCount: 2,
          ),
          getMessagesList(screenSize, widget.messagesProvider),
        ],
      ),
    );
  }
}

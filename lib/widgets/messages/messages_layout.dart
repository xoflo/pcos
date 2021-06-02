import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/screens/header/message_details.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/messages/messages_list.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/providers/messages_provider.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';

class MessagesLayout extends StatelessWidget {
  Widget getMessagesList(
    final BuildContext context,
    final Size screenSize,
    final MessagesProvider messagesProvider,
  ) {
    switch (messagesProvider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.of(context).noNotifications);
      case LoadingStatus.success:
        return MessagesList(
          messagesProvider: messagesProvider,
          openMessage: openMessage,
        );
    }
    return Container();
  }

  void openMessage(
    final BuildContext context,
    final MessagesProvider messagesProvider,
    Message message,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetails(
          message: message,
          closeMessage: () {
            Navigator.pop(context);
          },
          deleteMessage: (Message message) {
            //mark message isDeleted = true in backend and delete locally
            deleteMessage(context, messagesProvider, message.notificationId);
          },
        ),
      ),
    );
    //mark message AsRead = true in backend and locally
    await messagesProvider.updateNotificationAsRead(message.notificationId);
  }

  void deleteMessage(final BuildContext context,
      final MessagesProvider messagesProvider, final int notificationId) async {
    void continueDeleteMessage(BuildContext context) async {
      await messagesProvider.updateNotificationAsDeleted(notificationId);
      Navigator.pop(context);
      Navigator.pop(context);
    }

    showAlertDialog(
      context,
      S.of(context).deleteMessageTitle,
      S.of(context).deleteMessageText,
      S.of(context).noText,
      S.of(context).yesText,
      continueDeleteMessage,
      (BuildContext context) {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Consumer<MessagesProvider>(
      builder: (context, model, child) => Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Header(
              title: S.of(context).messagesTitle,
              closeItem: () {
                Navigator.pop(context);
              },
              showMessagesIcon: true,
              unreadCount: model.getUnreadCount(),
            ),
            getMessagesList(context, screenSize, model),
          ],
        ),
      ),
    );
  }
}

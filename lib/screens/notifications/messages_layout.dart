import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/screens/notifications/message_details.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/screens/notifications/messages_list.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/providers/messages_provider.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';

class MessagesLayout extends StatefulWidget {
  const MessagesLayout({Key? key}) : super(key: key);

  @override
  State<MessagesLayout> createState() => _MessagesLayoutState();
}

class _MessagesLayoutState extends State<MessagesLayout> {
  bool showMessageReadOption = false;
  bool selectAll = false;

  Widget getMessagesList(final MessagesProvider messagesProvider) {
    if (messagesProvider.status == LoadingStatus.empty) {
      return NoResults(message: "There are no notifications to display.");
    }
    return MessagesList(
      messagesProvider: messagesProvider,
      openMessage: openMessage,
      showMessageReadOption: showMessageReadOption,
      isAllSelected: selectAll,
      onSelectItem: (shouldSelectAll) =>
          setState(() => selectAll = shouldSelectAll),
      onPressMarkAsRead: () => setState(() => showMessageReadOption = false),
    );
  }

  void openMessage(
    final BuildContext context,
    final MessagesProvider? messagesProvider,
    Message message,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetails(
          message: message,
          closeMessage: () => Navigator.pop(context),
          deleteMessage: (Message message) {
            //mark message isDeleted = true in backend and delete locally
            deleteMessage(context, messagesProvider, message.notificationId);
          },
        ),
      ),
    );
    //mark message AsRead = true in backend and locally
    await messagesProvider?.updateNotificationAsRead(message.notificationId);
  }

  void deleteMessage(
      final BuildContext context,
      final MessagesProvider? messagesProvider,
      final int? notificationId) async {
    void continueDeleteMessage(BuildContext context) async {
      await messagesProvider?.updateNotificationAsDeleted(notificationId);
      Navigator.pop(context);
      Navigator.pop(context);
    }

    showAlertDialog(
      context,
      S.current.deleteMessageTitle,
      S.current.deleteMessageText,
      S.current.noText,
      S.current.yesText,
      continueDeleteMessage,
      (BuildContext context) {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) => Consumer<MessagesProvider>(
        builder: (context, model, child) => Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Header(
                    title: "Notifications",
                    closeItem: () => Navigator.pop(context),
                    showDivider: true,
                    isAllSelected: selectAll,
                    onToggleSelectAll: showMessageReadOption
                        ? () => setState(() => selectAll = !selectAll)
                        : null,
                    onToggleMarkAsRead: () => setState(() {
                      showMessageReadOption = !showMessageReadOption;
                      selectAll = false;
                    }),
                  ),
                  getMessagesList(model),
                ],
              ),
            ),
            if (model.status == LoadingStatus.loading) LoaderOverlay()
          ],
        ),
      );
}

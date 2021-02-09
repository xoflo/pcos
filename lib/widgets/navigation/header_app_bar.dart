import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/messages_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/messages_bell.dart';

class HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final Function displayChat;
  final Function(MessagesProvider) displayNotifications;

  HeaderAppBar({
    @required this.currentIndex,
    @required this.displayChat,
    @required this.displayNotifications,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  String getHeaderText(BuildContext context, int currentIndex) {
    switch (currentIndex) {
      case 1:
        return S.of(context).knowledgeBaseTitle;
      case 2:
        return S.of(context).recipesTitle;
      case 3:
        return S.of(context).coachChatTitle;
      default:
        return S.of(context).dashboardTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        getHeaderText(context, currentIndex),
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.chat_outlined,
            color: Colors.white,
            size: 26.0,
          ),
          onPressed: () {
            displayChat();
          },
        ),
        Consumer<MessagesProvider>(
          builder: (context, model, child) => GestureDetector(
              onTap: () {
                displayNotifications(model);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 2.0),
                child: MessagesBell(messagesCount: 2),
              )),
        ),
      ],
    );
  }
}

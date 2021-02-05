import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final Function displayChat;
  final Function displayNotifications;

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
        IconButton(
          icon: Icon(
            Icons.notifications_none,
            color: Colors.white,
            size: 28.0,
          ),
          onPressed: () {
            displayNotifications();
          },
        )
      ],
    );
  }
}

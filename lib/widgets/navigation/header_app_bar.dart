import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/messages_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/messages_bell.dart';
import 'package:thepcosprotocol_app/screens/messages.dart';

class HeaderAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int currentIndex;
  final Function displayChat;
  final Function closeMessages;

  HeaderAppBar({
    @required this.currentIndex,
    @required this.displayChat,
    @required this.closeMessages,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  _HeaderAppBarState createState() => _HeaderAppBarState();
}

class _HeaderAppBarState extends State<HeaderAppBar> {
  String _getHeaderText(BuildContext context, int currentIndex) {
    switch (currentIndex) {
      case 1:
        return S.of(context).knowledgeBaseTitle;
      case 2:
        return S.of(context).recipesTitle;
      case 3:
        return S.of(context).favouritesTitle;
      default:
        return S.of(context).dashboardTitle;
    }
  }

  void _openNotifications(final BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Messages(
          closeMenuItem: widget.closeMessages,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        _getHeaderText(context, widget.currentIndex),
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
            widget.displayChat();
          },
        ),
        GestureDetector(
          onTap: () {
            _openNotifications(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 28.0),
            child: Consumer<MessagesProvider>(
              builder: (context, model, child) =>
                  MessagesBell(messagesCount: model.getUnreadCount()),
            ),
          ),
        ),
      ],
    );
  }
}

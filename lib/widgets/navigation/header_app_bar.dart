import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;

  HeaderAppBar({@required this.currentIndex});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  String getHeaderText(BuildContext context, int currentIndex) {
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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(getHeaderText(context, currentIndex),
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          )),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.notifications_none,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () {
            debugPrint("display messages");
          },
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';

class HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;

  HeaderAppBar({@required this.currentIndex});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  String getHeaderText(int currentIndex) {
    switch (currentIndex) {
      case 1:
        return "Knowledge Base";
      case 2:
        return "Recipes";
      case 3:
        return "Favourites";
      default:
        return "Dashboard";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(getHeaderText(currentIndex),
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

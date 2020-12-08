import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/text_themes.dart';
import 'package:thepcosprotocol_app/widgets/drawer_menu.dart';

class AppBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard",
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
      ),
      drawer: DrawerMenu(),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText1,
        child: TextThemes(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        selectedIconTheme: IconThemeData(
          color: Colors.white,
          size: 30.0,
        ),
        unselectedIconTheme: IconThemeData(
          color: Theme.of(context).backgroundColor,
          size: 30.0,
        ),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.batch_prediction),
            label: "Knowledge Base",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining),
            label: "Recipes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: "Favourites",
          ),
        ],
      ),
    );
  }
}

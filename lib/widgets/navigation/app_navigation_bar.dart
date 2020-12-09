import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int selectedIndex) onTapped;
  AppNavigationBar({@required this.currentIndex, @required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).primaryColor,
      onTap: (int index) {
        onTapped(index);
      },
      selectedIconTheme: IconThemeData(
        color: Colors.white,
        size: 34.0,
      ),
      unselectedIconTheme: IconThemeData(
        color: Theme.of(context).backgroundColor,
        size: 30.0,
      ),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex, // this will be set when a new tab is tapped
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
    );
  }
}

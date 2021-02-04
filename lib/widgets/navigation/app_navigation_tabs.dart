import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class AppNavigationTabs extends StatelessWidget {
  final int currentIndex;
  final Function(int selectedIndex) onTapped;
  AppNavigationTabs({@required this.currentIndex, @required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        onTapped(index);
      },
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex, // this will be set when a new tab is tapped
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: S.of(context).dashboardTitle,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.batch_prediction),
          label: S.of(context).knowledgeBaseTitle,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_dining),
          label: S.of(context).recipesTitle,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: S.of(context).favouritesTitle,
        ),
      ],
    );
  }
}

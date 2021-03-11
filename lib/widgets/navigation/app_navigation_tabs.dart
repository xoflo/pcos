import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/screens/app_tabs.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class AppNavigationTabs extends StatelessWidget {
  final int currentIndex;
  final Function(int selectedIndex) onTapped;
  final FirebaseAnalyticsObserver observer;

  AppNavigationTabs({
    @required this.currentIndex,
    @required this.onTapped,
    @required this.observer,
  });

  void _sendCurrentTabToAnalytics(final int selectedIndex) {
    final String indexName = AnalyticsUtils.getAppTabName(selectedIndex);
    observer.analytics.setCurrentScreen(
      screenName: "${AppTabs.id}/$indexName",
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        onTapped(index);
        _sendCurrentTabToAnalytics(index);
      },
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex, // this will be set when a new tab is tapped
      selectedFontSize: 0,
      unselectedFontSize: 0,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
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

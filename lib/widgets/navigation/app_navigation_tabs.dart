import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart';
import 'package:thepcosprotocol_app/screens/app_tabs.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class AppNavigationTabs extends StatelessWidget {
  final int currentIndex;
  final Function(int selectedIndex) onTapped;
  final FirebaseAnalyticsObserver? observer;
  final TabController tabController;

  AppNavigationTabs({
    required this.currentIndex,
    required this.onTapped,
    required this.observer,
    required this.tabController,
  });

  void _sendCurrentTabToAnalytics(final int selectedIndex) {
    final String indexName = AnalyticsUtils.getAppTabName(selectedIndex);
    observer?.analytics.setCurrentScreen(
      screenName: "${AppTabs.id}/$indexName",
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: TabBar(
        onTap: (index) {
          onTapped(index);
          _sendCurrentTabToAnalytics(index);
        },
        indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
        controller: tabController,
        indicator: UnderlineTabIndicator(
          insets: EdgeInsets.only(bottom: 75),
          borderSide:
              BorderSide(color: Theme.of(context).backgroundColor, width: 2),
        ),
        labelColor: backgroundColor,
        unselectedLabelColor: unselectedIndicatorColor,
        labelStyle: TextStyle(fontSize: 12),
        tabs: [
          Tab(
            icon: Image.asset(
              'assets/course.png',
              height: 24,
              width: 24,
              color: currentIndex == 0
                  ? backgroundColor
                  : unselectedIndicatorIconColor,
            ),
            text: "Course",
          ),
          Tab(
            icon: Image.asset(
              'assets/library.png',
              height: 24,
              width: 24,
              color: currentIndex == 1
                  ? backgroundColor
                  : unselectedIndicatorIconColor,
            ),
            text: "Library",
          ),
          Tab(
            icon: Image.asset(
              'assets/recipes.png',
              height: 24,
              width: 24,
              color: currentIndex == 2
                  ? backgroundColor
                  : unselectedIndicatorIconColor,
            ),
            text: "Recipes",
          ),
          Tab(
            icon: Image.asset(
              'assets/favorites.png',
              height: 24,
              width: 24,
              color: currentIndex == 3
                  ? backgroundColor
                  : unselectedIndicatorIconColor,
            ),
            text: "Favorites",
          ),
          Tab(
            icon: Image.asset(
              'assets/more.png',
              height: 24,
              width: 24,
              color: currentIndex == 4
                  ? backgroundColor
                  : unselectedIndicatorIconColor,
            ),
            text: "More",
          ),
        ],
      ),
    );
  }
}

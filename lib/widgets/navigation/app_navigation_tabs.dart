import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
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
  Widget build(BuildContext context) => BottomAppBar(
        child: TabBar(
          onTap: (index) {
            onTapped(index);
            _sendCurrentTabToAnalytics(index);
          },
          indicatorPadding: EdgeInsets.symmetric(horizontal: 15),
          controller: tabController,
          indicator: UnderlineTabIndicator(
            insets: EdgeInsets.only(bottom: 75),
            borderSide:
                BorderSide(color: Theme.of(context).backgroundColor, width: 2),
          ),
          labelPadding: EdgeInsets.zero,
          labelColor: backgroundColor,
          unselectedLabelColor: unselectedIndicatorColor,
          labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          tabs: [
            Stack(
              children: [
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
                  iconMargin: EdgeInsets.only(bottom: 5),
                ),
                Consumer<ModulesProvider>(
                  builder: (context, modulesProvider, child) {
                    // Count a lesson as incomplete if they are not yet
                    // complete, and they are already available for use
                    final incompleteLessonCount =
                        modulesProvider.currentModuleLessons
                            .where(
                              (element) =>
                                  !element.isComplete &&
                                  element.hoursUntilAvailable == 0,
                            )
                            .length;
                    final showLessonCount = incompleteLessonCount != 0;
                    return Positioned(
                      right: 0,
                      top: 5,
                      child: Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: showLessonCount ? badgeColor : null,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: showLessonCount
                            ? Text(
                                "$incompleteLessonCount",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ],
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
              iconMargin: EdgeInsets.only(bottom: 5),
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
              iconMargin: EdgeInsets.only(bottom: 5),
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
              iconMargin: EdgeInsets.only(bottom: 5),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'package:thepcosprotocol_app/providers/preferences_provider.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/dashboard_lesson_carousel.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/dashboard_member_time.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/dashboard_why_community.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class DashboardLayout extends StatelessWidget {
  DashboardLayout({Key? key}) : super(key: key);

  // final bool showYourWhy;
  // final bool showLessonReicpes;
  // final String displayedName;

  // bool _showWhy = true;
  // bool _showRecipes = false;
  // bool _isUsernameUsed = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _initialise();
  // }

  // Future<void> _initialise() async {
  //   final bool showRecipes = await PreferencesController()
  //       .getBool(SharedPreferencesKeys.LESSON_RECIPES_DISPLAYED_DASHBOARD);
  //   final bool showYourWhy = await PreferencesController()
  //       .getBool(SharedPreferencesKeys.YOUR_WHY_DISPLAYED);
  //   final bool isUsernameUsed = await PreferencesController()
  //       .getBool(SharedPreferencesKeys.USERNAME_USED);

  // setState(() {
  //   _showWhy = showYourWhy;
  //   _showRecipes = showRecipes;
  //   _isUsernameUsed = isUsernameUsed;
  // });
  // }

  @override
  Widget build(BuildContext context) {
    // _showRecipes = showLessonReicpes;
    // _showWhy = showYourWhy;
    // _isUsernameUsed = isUsernameUsed;

    // return ChangeNotifierProvider(create: (context) => PreferencesProvider(),
    return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: Consumer<PreferencesProvider>(
              builder: (context, prefsProvider, child) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardMemberTime(),
                  if (prefsProvider.isShowYourWhy) DashboardWhyCommunity(),
                  SizedBox(height: 25),
                  DashboardLessonCarousel(),
                ],
              ),
            )),
          ),
        ],
      );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/dashboard_lesson_carousel.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/dashboard_member_time.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/dashboard_why_community.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class DashboardLayout extends StatefulWidget {
  DashboardLayout({
    Key? key,
    required this.showYourWhy,
    required this.showLessonReicpes,
    required this.isUsernameUsed,
  }) : super(key: key);

  final bool showYourWhy;
  final bool showLessonReicpes;
  final bool isUsernameUsed;

  @override
  _DashboardLayoutState createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  bool _showWhy = true;
  bool _showRecipes = false;
  bool _isUsernameUsed = false;

  @override
  void initState() {
    super.initState();
    _initialise();
  }

  Future<void> _initialise() async {
    final bool showRecipes = await PreferencesController()
        .getBool(SharedPreferencesKeys.LESSON_RECIPES_DISPLAYED_DASHBOARD);
    final bool showYourWhy = await PreferencesController()
        .getBool(SharedPreferencesKeys.YOUR_WHY_DISPLAYED);
    final bool isUsernameUsed = await PreferencesController()
        .getBool(SharedPreferencesKeys.USERNAME_USED);

    setState(() {
      _showWhy = showYourWhy;
      _showRecipes = showRecipes;
      _isUsernameUsed = isUsernameUsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    _showRecipes = widget.showLessonReicpes;
    _showWhy = widget.showYourWhy;
    _isUsernameUsed = widget.isUsernameUsed;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Consumer4<ModulesProvider, FavouritesProvider,
                RecipesProvider, MemberProvider>(
              builder: (context, modulesProvider, favouritesProvider,
                      recipesProvider, memberProvider, child) =>
                  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardMemberTime(
                    memberProvider: memberProvider,
                    isUsernameUsed: _isUsernameUsed,
                  ),
                  if (_showWhy) DashboardWhyCommunity(),
                  SizedBox(height: 25),
                  DashboardLessonCarousel(
                    modulesProvider: modulesProvider,
                    showLessonRecipes: _showRecipes,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
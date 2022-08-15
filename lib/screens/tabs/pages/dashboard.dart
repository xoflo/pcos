import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/dashboard_layout.dart';

class Dashboard extends StatelessWidget {
  Dashboard({
    required this.showYourWhy,
    required this.showLessonReicpes,
    required this.isUsernameUsed,
  });

  final bool showYourWhy;
  final bool showLessonReicpes;
  final bool isUsernameUsed;

  @override
  Widget build(BuildContext context) => DashboardLayout(
          showYourWhy: showYourWhy,
          showLessonReicpes: showLessonReicpes,
          isUsernameUsed: isUsernameUsed,
      );
}

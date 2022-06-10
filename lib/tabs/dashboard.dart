import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/dashboard_layout.dart';

class Dashboard extends StatelessWidget {
  final bool showYourWhy;
  final bool showLessonRecipes;
  final Function(bool) updateYourWhy;

  Dashboard(
      {required this.showYourWhy,
      required this.showLessonRecipes,
      required this.updateYourWhy});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      showYourWhy: showYourWhy,
      showLessonRecipes: showLessonRecipes,
      updateYourWhy: updateYourWhy,
    );
  }
}

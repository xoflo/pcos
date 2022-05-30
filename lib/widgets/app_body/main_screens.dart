import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/tabs/dashboard.dart';
import 'package:thepcosprotocol_app/tabs/recipes.dart';
import 'package:thepcosprotocol_app/tabs/favourites.dart';

class MainScreens extends StatelessWidget {
  final int currentIndex;
  final bool showYourWhy;
  final bool showLessonRecipes;
  final Function(bool) updateYourWhy;

  MainScreens({
    required this.currentIndex,
    required this.showYourWhy,
    required this.showLessonRecipes,
    required this.updateYourWhy,
  });

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentIndex,
      children: [
        Dashboard(
          showYourWhy: showYourWhy,
          showLessonRecipes: showLessonRecipes,
          updateYourWhy: updateYourWhy,
        ),
        Recipes(),
        Favourites(),
      ],
    );
  }
}

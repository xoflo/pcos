import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/screens/app_tutorial/app_tutorial_get_started_item.dart';

class AppTutorialGetStarted extends StatelessWidget {
  const AppTutorialGetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            AppTutorialGetStartedItem(
              title: "Library",
              subtitle: "Search and find anything you need",
              asset: "assets/tutorial_library.png",
            ),
            SizedBox(
              height: 20,
            ),
            AppTutorialGetStartedItem(
              title: "Recipes",
              subtitle: "Find recipes to help maintain your goals.",
              asset: "assets/tutorial_recipes.png",
            ),
            SizedBox(
              height: 20,
            ),
            AppTutorialGetStartedItem(
              title: "Favorites",
              subtitle:
                  "Add lessons, knowledge base questions or recipes to your favorites for later.",
              asset: "assets/tutorial_favorites.png",
            )
          ],
        ),
      );
}

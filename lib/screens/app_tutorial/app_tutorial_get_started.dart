import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/screens/app_tutorial/app_tutorial_get_started_item.dart';

class AppTutorialGetStarted extends StatelessWidget {
  const AppTutorialGetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppTutorialGetStartedItem(
              title: "Library",
              subtitle: "Search any past modules or wikis",
              asset: "assets/tutorial_library.png",
            ),
            SizedBox(
              height: 20,
            ),
            AppTutorialGetStartedItem(
              title: "Recipes",
              subtitle: "100+ PCOS friendly, healthy recipes",
              asset: "assets/tutorial_recipes.png",
            ),
            SizedBox(
              height: 20,
            ),
            AppTutorialGetStartedItem(
              title: "Favorites",
              subtitle:
                  "Add lessons, wikis or recipes to your favourites for easy access later",
              asset: "assets/tutorial_favorites.png",
            ),
            SizedBox(
              height: 20,
            ),
            AppTutorialGetStartedItem(
              title: "Toolkits",
              subtitle:
                  "Toolkits are lessons that have actionable information in them, so we’ve automatically saved these in your Toolkit under favorites",
              asset: "assets/tutorial_toolkit.png",
            ),
          ],
        ),
      );
}

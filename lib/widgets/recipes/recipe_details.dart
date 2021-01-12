import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/view_models/recipe_view_model.dart';

class RecipeDetails extends StatelessWidget {
  final RecipeViewModel recipe;
  final Function closeRecipeDetails;
  final Function addToFavourites;

  RecipeDetails({this.recipe, this.closeRecipeDetails, this.addToFavourites});

  Column _iconColumn(BuildContext context, IconData icon, Color iconColor,
      String displayText) {
    return Column(children: [
      Icon(
        icon,
        size: 30.0,
        color: iconColor,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          displayText,
          style: Theme.of(context).textTheme.headline4.copyWith(
                color: textColor,
              ),
        ),
      ),
    ]);
  }

  String _getDifficultyText(BuildContext context, int difficulty) {
    switch (difficulty) {
      case 0:
        return S.of(context).recipeDifficultyEasy;
      case 1:
        return S.of(context).recipeDifficultyMedium;
      case 2:
        return S.of(context).recipeDifficultyHard;
    }
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 0:
        return Colors.green;
      case 1:
        return primaryColor;
      case 2:
        return darkAlternative;
    }
  }

  Widget _recipeDetailTabs(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(isScrollable: true, tabs: [
              Tab(text: S.of(context).recipeDetailsSummaryTab),
              Tab(text: S.of(context).recipeDetailsIngredientsTab),
              Tab(text: S.of(context).recipeDetailsMethodTab),
              Tab(text: S.of(context).recipeDetailsTipsTab),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              //Add this to give height
              height: MediaQuery.of(context).size.height -
                  (kToolbarHeight + kBottomNavigationBarHeight),
              child: TabBarView(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _iconColumn(
                            context,
                            Icons.restaurant,
                            primaryColorDark,
                            recipe.servings.toString(),
                          ),
                          _iconColumn(
                            context,
                            Icons.timer,
                            primaryColorDark,
                            recipe.durationMinutes.toString() +
                                " " +
                                S.of(context).minutesShort,
                          ),
                          _iconColumn(
                            context,
                            Icons.sort,
                            _getDifficultyColor(recipe.difficulty),
                            _getDifficultyText(
                              context,
                              recipe.difficulty,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.network(recipe.thumbnail),
                    ),
                  ],
                ),
                Html(
                  data: recipe.ingredients,
                ),
                Html(
                  data: recipe.method,
                ),
                Html(
                  data: recipe.tips,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    addToFavourites();
                  },
                  child: Icon(
                    recipe.isFavourite
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    color: primaryColorDark,
                    size: 35,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    closeRecipeDetails();
                  },
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: Container(
                      color: primaryColorDark,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _recipeDetailTabs(context),
        ],
      ),
    );
  }
}

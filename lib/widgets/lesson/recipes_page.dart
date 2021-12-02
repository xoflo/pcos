import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipes_list.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_details.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';

class RecipesPage extends StatelessWidget {
  final Size screenSize;
  final bool isHorizontal;
  final List<LessonRecipe> recipes;
  final BuildContext parentContext;

  RecipesPage({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.recipes,
    @required this.parentContext,
  });

  void _openRecipeDetails(BuildContext context, dynamic lessonRecipe) async {
    //remove the focus from the searchbox if necessary, to hide the keyboard
    final RecipesProvider recipeProvider =
        Provider.of<RecipesProvider>(context, listen: false);
    final FavouritesProvider favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
    final Recipe recipe = recipeProvider.getRecipeById(lessonRecipe.recipeId);
    final bool isFavourite = favouritesProvider.isFavourite(
        FavouriteType.Recipe, lessonRecipe.recipeId);
    openBottomSheet(
      context,
      RecipeDetails(
        recipe: recipe,
        isFavourite: isFavourite,
        closeRecipeDetails: _closeRecipeDetails,
      ),
      Analytics.ANALYTICS_SCREEN_RECIPE_DETAIL,
      recipe.recipeId.toString(),
    );
  }

  void _closeRecipeDetails() {
    Navigator.pop(parentContext);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                S.current.lessonRecipes,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          RecipesList(
              screenSize: screenSize,
              recipes: recipes,
              openRecipeDetails: _openRecipeDetails),
        ],
      ),
    );
  }
}

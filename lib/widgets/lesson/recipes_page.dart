import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/question_list.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipes_list.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_details.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';

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

  void _openRecipeDetails(BuildContext context, Recipe recipe) async {
    //remove the focus from the searchbox if necessary, to hide the keyboard
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

    openBottomSheet(
      context,
      RecipeDetails(
        recipe: recipe,
        closeRecipeDetails: _closeRecipeDetails,
        addToFavourites: _addToFavourites,
      ),
      Analytics.ANALYTICS_SCREEN_RECIPE_DETAIL,
      recipe.recipeId.toString(),
    );
  }

  void _closeRecipeDetails() {
    Navigator.pop(parentContext);
  }

  void _addToFavourites(final dynamic recipe, final bool add) async {
    final recipeProvider =
        Provider.of<RecipesProvider>(parentContext, listen: false);
    await recipeProvider.addToFavourites(recipe, add);
    Provider.of<FavouritesProvider>(parentContext, listen: false)
        .fetchAndSaveData();
    //recipeProvider.filterAndSearch(_searchController.text.trim(),
    //_tagSelectedValue, _tagValuesSelectedSecondary);
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
                S.of(context).lessonRecipes,
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

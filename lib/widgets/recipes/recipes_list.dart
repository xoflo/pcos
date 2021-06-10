import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_list_item.dart';

class RecipesList extends StatelessWidget {
  final Size screenSize;
  final List<Recipe> recipes;
  final Function(BuildContext, Recipe) openRecipeDetails;

  RecipesList({this.screenSize, this.recipes, this.openRecipeDetails});

  @override
  Widget build(BuildContext context) {
    final int itemsPerRow =
        DeviceUtils.getItemsPerRow(screenSize.width, screenSize.height);
    final double aspectRatioSingle = (screenSize.width / 266) - 0.05;
    final double aspectRatio = itemsPerRow == 3
        ? screenSize.width < 1025 //landscape
            ? 1.24 //9.7inch iPad
            : 1.65 //12.9inch iPad
        : itemsPerRow == 2
            ? screenSize.width < 769 //portrait
                ? 1.39 //9.7inch iPad
                : 1.85 //12.9inch iPad
            : aspectRatioSingle; //phone
    //NB: If that's the case, simply wrap your GridView in Flexible, you may not need to use shrinkWrap then
    // Previously was a Expanded with shrinkWrap=true
    return Flexible(
      child: GridView.count(
        cacheExtent: screenSize.height * 2,
        shrinkWrap: false,
        crossAxisCount: itemsPerRow,
        childAspectRatio: aspectRatio,
        children: recipes.map((Recipe recipe) {
          return RecipeListItem(
            recipe: recipe,
            itemsPerRow: itemsPerRow,
            openRecipeDetails: openRecipeDetails,
            screenSize: screenSize,
          );
        }).toList(),
      ),
    );
  }
}

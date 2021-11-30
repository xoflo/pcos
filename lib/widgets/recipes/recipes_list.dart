import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_list_item.dart';

class RecipesList extends StatelessWidget {
  final Size screenSize;
  final List<dynamic> recipes;
  final Function(BuildContext, dynamic) openRecipeDetails;

  RecipesList({
    @required this.screenSize,
    @required this.recipes,
    @required this.openRecipeDetails,
  });

  @override
  Widget build(BuildContext context) {
    //NB: If that's the case, simply wrap your GridView in Flexible, you may not need to use shrinkWrap then
    // Previously was a Expanded with shrinkWrap=true
    final int itemsPerRow =
        DeviceUtils.getItemsPerRow(screenSize.width, screenSize.height);
    final double rowHeight = 266;
    final double itemWidth = screenSize.width / itemsPerRow;
    final double initialAspectRatio = itemWidth / rowHeight;
    final aspectRatio = initialAspectRatio * 0.95;

    return Flexible(
      child: GridView.count(
        cacheExtent: screenSize.height * 2,
        shrinkWrap: false,
        crossAxisCount: itemsPerRow,
        childAspectRatio: aspectRatio,
        children: recipes.map((dynamic recipe) {
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

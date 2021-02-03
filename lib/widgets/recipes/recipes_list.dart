import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_list_item.dart';

class RecipesList extends StatelessWidget {
  final Size screenSize;
  final List<Recipe> recipes;
  final Function(Recipe) openRecipeDetails;

  RecipesList({this.screenSize, this.recipes, this.openRecipeDetails});

  @override
  Widget build(BuildContext context) {
    final bool isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    /*24 is for notification bar on Android*/
    //final double itemHeight = (size.height - kToolbarHeight) / 2;
    //final double itemWidth = size.width / 2;
    final double aspectRatio = isHorizontal
        ? 1.24
        : Platform.isIOS
            ? 1.36
            : 1.49;

    return Expanded(
      child: GridView.count(
        cacheExtent: screenSize.height * 2,
        shrinkWrap: true,
        crossAxisCount:
            DeviceUtils.getItemsPerRow(screenSize.width, screenSize.height),
        childAspectRatio: aspectRatio,
        children: recipes.map((Recipe recipe) {
          return RecipeListItem(
            recipe: recipe,
            openRecipeDetails: openRecipeDetails,
          );
        }).toList(),
      ),
    );
  }
}

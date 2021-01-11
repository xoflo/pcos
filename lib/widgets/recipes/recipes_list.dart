import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/view_models/recipe_view_model.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_list_item.dart';

class RecipesList extends StatelessWidget {
  final Size screenSize;
  final List<RecipeViewModel> recipes;

  RecipesList({this.screenSize, this.recipes});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = size.width / 2;
    final double aspectRatio =
        DeviceUtils.isHorizontalWideScreen(size.width, size.height)
            ? 1.24
            : Platform.isIOS
                ? 1.36
                : 1.49;

    debugPrint("*************ASPECT RATIO=$aspectRatio");

    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount:
          DeviceUtils.getItemsPerRow(screenSize.width, screenSize.height),
      childAspectRatio: aspectRatio,
      // Generate 100 widgets that display their index in the List.
      children: recipes.map((RecipeViewModel recipe) {
        return RecipeListItem(
          recipeId: recipe.recipeId,
          title: recipe.title,
          thumbnail: recipe.thumbnail,
        );
      }).toList(),
    );
  }
}

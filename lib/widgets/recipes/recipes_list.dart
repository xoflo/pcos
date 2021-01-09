import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/view_models/recipe_view_model.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';

class RecipesList extends StatelessWidget {
  final Size screenSize;
  final List<RecipeViewModel> recipes;

  RecipesList({this.screenSize, this.recipes});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount:
          DeviceUtils.getItemsPerRow(screenSize.width, screenSize.height),
      // Generate 100 widgets that display their index in the List.
      children: recipes.map((RecipeViewModel recipe) {
        return Center(
          child: Text(
            recipe.title,
            style: Theme.of(context).textTheme.headline5,
          ),
        );
      }).toList(),
    );
  }
}

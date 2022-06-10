import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_recipe_item.dart';

class FavouritesRecipesList extends StatelessWidget {
  final List<Recipe> recipes;
  final double width;
  final Function(FavouriteType, dynamic) removeFavourite;
  final Function(FavouriteType, dynamic) openFavourite;

  FavouritesRecipesList({
    required this.recipes,
    required this.width,
    required this.removeFavourite,
    required this.openFavourite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: recipes.map((Recipe recipe) {
        return FavouritesRecipeItem(
          recipe: recipe,
          width: width,
          removeFavourite: removeFavourite,
          openFavourite: openFavourite,
        );
      }).toList(),
    );
  }
}

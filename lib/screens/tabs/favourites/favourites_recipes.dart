import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/screens/tabs/recipes/recipe_item.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class FavouritesRecipes extends StatefulWidget {
  const FavouritesRecipes({Key? key, required this.favouritesProvider})
      : super(key: key);

  final FavouritesProvider favouritesProvider;

  @override
  State<FavouritesRecipes> createState() => _FavouritesRecipesState();
}

class _FavouritesRecipesState extends State<FavouritesRecipes> {
  @override
  void initState() {
    super.initState();

    widget.favouritesProvider.fetchRecipesStatus(notifyListener: false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.favouritesProvider.recipes.isEmpty) {
      return NoResults(message: S.current.noFavouriteRecipe);
    }
    switch (widget.favouritesProvider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.current.noFavouriteRecipe);
      case LoadingStatus.success:
        return GridView.count(
          padding: EdgeInsets.all(10),
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(
            widget.favouritesProvider.recipes.length,
            (index) {
              final recipe = widget.favouritesProvider.recipes[index];

              return RecipeItem(recipe: recipe);
            },
            growable: false,
          ),
        );
    }
  }
}

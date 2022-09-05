import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/screens/tabs/recipes/recipe_item.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_with_change_notifier.dart';

class FavouritesRecipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    favouritesProvider.fetchRecipesStatus(notifyListener: false);

    return LoaderOverlay(
      indicatorPosition: Alignment.center,
      loadingStatusNotifier: favouritesProvider,
      height: double.maxFinite,
      emptyMessage: S.current.noFavouriteRecipe,
      overlayBackgroundColor: Colors.transparent,
      child: GridView.count(
        padding: EdgeInsets.all(10),
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: List.generate(
          favouritesProvider.recipes.length,
          (index) {
            final recipe = favouritesProvider.recipes[index];

            return RecipeItem(recipe: recipe);
          },
          growable: false,
        ),
      ),
    );
  }
}

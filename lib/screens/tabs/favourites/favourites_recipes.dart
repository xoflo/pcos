import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/image_view_item.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_with_change_notifier.dart';

import '../../../models/navigation/lesson_recipe_arguments.dart';
import '../recipes/recipe_details_page.dart';

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

            return ImageViewItem(
              thumbnail: recipe.thumbnail,
              onViewPressed: () => RecipeDetailsPage(args: LessonRecipeArguments(true, recipe)),
              title: recipe.title
            );
          },
          growable: false,
        ),
      ),
    );
  }
}

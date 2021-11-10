import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';

class FavouritesController {
  Future<void> addToFavourites(final BuildContext context,
      final FavouriteType favouriteType, final dynamic item, final bool add,
      {final bool refreshData = true}) async {
    switch (favouriteType) {
      case FavouriteType.Lesson:
        await Provider.of<ModulesProvider>(context, listen: false)
            .addLessonToFavourites(item, add, refreshData);
        break;
      case FavouriteType.Recipe:
        await Provider.of<RecipesProvider>(context, listen: false)
            .addToFavourites(item, add);
        break;
      case FavouriteType.Wiki:
        await Provider.of<ModulesProvider>(context, listen: false)
            .addWikiToFavourites(item, add);
        break;
      case FavouriteType.None:
        break;
    }
    Provider.of<FavouritesProvider>(context, listen: false).fetchAndSaveData();
  }
}

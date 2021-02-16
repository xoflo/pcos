import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class RecipesProvider with ChangeNotifier {
  final DatabaseProvider dbProvider;

  RecipesProvider({@required this.dbProvider}) {
    if (dbProvider != null) fetchAndSaveData();
  }
  final String tableName = "Recipe";
  List<Recipe> _items = [];
  LoadingStatus status = LoadingStatus.empty;
  List<Recipe> get items => [..._items];

  Future<void> fetchAndSaveData() async {
    status = LoadingStatus.loading;
    notifyListeners();
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      _items = await ProviderHelper().fetchAndSaveRecipes(dbProvider);
    }

    status = _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    notifyListeners();
  }

  Future<void> filterAndSearch(
      final String searchText, final String tag) async {
    status = LoadingStatus.loading;
    notifyListeners();
    if (dbProvider.db != null) {
      _items = await ProviderHelper()
          .filterAndSearch(dbProvider, tableName, searchText, tag);
    }
    status = _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    notifyListeners();
  }

  Future<void> addToFavourites(final dynamic recipe, final bool add) async {
    if (dbProvider.db != null) {
      await ProviderHelper()
          .addToFavourites(add, dbProvider, FavouriteType.Recipe, recipe);
    }
  }
}

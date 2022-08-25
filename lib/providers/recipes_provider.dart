import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class RecipesProvider with ChangeNotifier {
  final DatabaseProvider? dbProvider;

  RecipesProvider({required this.dbProvider}) {
    if (dbProvider != null) fetchAndSaveData();
  }
  final String tableName = "Recipe";
  List<Recipe> _items = [];
  List<Recipe> _randomizedItems = [];
  List<Recipe> _originalRandomizedItems = [];

  LoadingStatus status = LoadingStatus.empty;
  List<Recipe> get items => [..._items];
  List<Recipe> get randomizedItems => [..._randomizedItems];
  List<Recipe> get originalRandomized => [..._originalRandomizedItems];

  Future<void> fetchAndSaveData() async {
    status = LoadingStatus.loading;
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    if (dbProvider?.db != null) {
      //first get the data from the api if we have no data yet
      _items = await ProviderHelper().fetchAndSaveRecipes(dbProvider);

      // By randomizing here, we ensure that as the user goes from tab to tab,
      // the items do not get randomized (unless they unlock the app from the
      // enter PIN screen)
      _randomizedItems = [..._items];
      _randomizedItems.shuffle();
      _originalRandomizedItems = [..._randomizedItems];
    }

    status = _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
  }

  Future<void> filterAndSearch(final String searchText, final String tag,
      final List<String> secondaryTags) async {
    status = LoadingStatus.loading;
    notifyListeners();
    if (searchText.isEmpty) {
      _randomizedItems = [..._originalRandomizedItems];
    } else if (dbProvider?.db != null) {
      _items = await ProviderHelper().filterAndSearch(
              dbProvider, tableName, searchText, tag, secondaryTags)
          as List<Recipe>;

      _randomizedItems = [..._items];
    }
    status =
        _randomizedItems.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    notifyListeners();
  }

  Recipe getRecipeById(final int? recipeId) {
    return _items.firstWhere((recipe) => recipe.recipeId == recipeId,
        orElse: () => Recipe(recipeId: -1));
  }
}

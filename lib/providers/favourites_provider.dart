import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/models/all_favourites.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';

class FavouritesProvider with ChangeNotifier {
  final DatabaseProvider? dbProvider;

  FavouritesProvider({required this.dbProvider}) {
    if (dbProvider != null) fetchAndSaveData();
  }

  LoadingStatus status = LoadingStatus.empty;

  List<Lesson> _toolkits = [];
  List<Lesson> _lessons = [];
  List<LessonWiki> _lessonWikis = [];
  List<Recipe> _recipes = [];

  List<Lesson> get toolkits => [..._toolkits];
  List<Lesson> get lessons => [..._lessons];
  List<LessonWiki> get lessonWikis => [..._lessonWikis];
  List<Recipe> get recipes => [..._recipes];

  Future<void> fetchAndSaveData() async {
    status = LoadingStatus.loading;

    if (dbProvider?.db != null) {
      //first get the data from the api if we have no data yet
      final AllFavourites allFavourites =
          await ProviderHelper().getFavourites(dbProvider);

      _toolkits = allFavourites.toolkits;
      _lessons = allFavourites.lessons;
      _lessonWikis = allFavourites.lessonWikis;
      _recipes = allFavourites.recipes;
    }

    // status = LoadingStatus.success;
  }

  void fetchToolkitStatus({bool notifyListener = true}) {
    status = _toolkits.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    if (notifyListener) {
      notifyListeners();
    }
  }

  void fetchLessonStatus({bool notifyListener = true}) {
    status = _lessons.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    if (notifyListener) {
      notifyListeners();
    }
  }

  void fetchLessonWikisStatus({bool notifyListener = true}) {
    status = _lessonWikis.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    if (notifyListener) {
      notifyListeners();
    }
  }

  void fetchRecipesStatus({bool notifyListener = true}) {
    status = _recipes.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    if (notifyListener) {
      notifyListeners();
    }
  }

  Future<void> addToFavourites(
      final FavouriteType favouriteType, final int? itemId) async {
    ProviderHelper().addToFavourites(
        !isFavourite(favouriteType, itemId), dbProvider, favouriteType, itemId);
    fetchAndSaveData();
  }

  bool isFavourite(final FavouriteType favouriteType, final int? itemId) {
    switch (favouriteType) {
      case FavouriteType.Lesson:
        Lesson? lessonFound = _lessons.firstWhereOrNull(
          (lesson) => lesson.lessonID == itemId,
        );
        if (lessonFound != null) {
          return true;
        }
        return false;
      case FavouriteType.Wiki:
        LessonWiki? wikiFound = _lessonWikis.firstWhereOrNull(
          (wiki) => wiki.questionId == itemId,
        );
        if (wikiFound != null) {
          return true;
        }
        return false;
      case FavouriteType.Recipe:
        Recipe? recipeFound = _recipes.firstWhereOrNull(
          (recipe) => recipe.recipeId == itemId,
        );
        if (recipeFound != null) {
          return true;
        }
        return false;
      case FavouriteType.None:
        return false;
    }
  }
}

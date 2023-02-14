import 'package:thepcosprotocol_app/models/all_favourites.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/loading_status_notifier.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';

import '../models/workout.dart';

class FavouritesProvider extends LoadingStatusNotifier {
  final DatabaseProvider? dbProvider;

  FavouritesProvider({required this.dbProvider}) {
    if (dbProvider != null) fetchAndSaveData();
  }

  List<Lesson> _toolkits = [];
  List<Lesson> _lessons = [];
  List<LessonWiki> _lessonWikis = [];
  List<Recipe> _recipes = [];
  List<Workout> _workouts = [];

  List<Lesson> get toolkits => [..._toolkits];
  List<Lesson> get lessons => [..._lessons];
  List<LessonWiki> get lessonWikis => [..._lessonWikis];
  List<Recipe> get recipes => [..._recipes];
  List<Workout> get workouts => [..._workouts];

  Future<void> fetchAndSaveData() async {
    setLoadingStatus(LoadingStatus.loading, false);

    if (dbProvider?.db != null) {
      //first get the data from the api if we have no data yet
      final AllFavourites allFavourites =
          await ProviderHelper().getFavourites(dbProvider);

      _toolkits = allFavourites.toolkits;
      _lessons = allFavourites.lessons;
      _lessonWikis = allFavourites.lessonWikis;
      _recipes = allFavourites.recipes;
      _workouts = allFavourites.workouts;
    }

    // status = LoadingStatus.success;
  }

  void fetchToolkitStatus({bool notifyListener = true}) {
    setLoadingStatus(
        _toolkits.isEmpty ? LoadingStatus.empty : LoadingStatus.success,
        notifyListener);
  }

  void fetchLessonStatus({bool notifyListener = true}) {
    setLoadingStatus(
        _lessons.isEmpty ? LoadingStatus.empty : LoadingStatus.success,
        notifyListener);
  }

  void fetchLessonWikisStatus({bool notifyListener = true}) {
    setLoadingStatus(
        _lessonWikis.isEmpty ? LoadingStatus.empty : LoadingStatus.success,
        notifyListener);
  }

  void fetchRecipesStatus({bool notifyListener = true}) {
    setLoadingStatus(
        _recipes.isEmpty ? LoadingStatus.empty : LoadingStatus.success,
        notifyListener);
  }

  void fetchWorkoutsStatus({bool notifyListener = true}) {
    setLoadingStatus(
        _workouts.isEmpty ? LoadingStatus.empty : LoadingStatus.success,
        notifyListener);
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
      case FavouriteType.Workout:
        Workout? workoutFound = _workouts.firstWhereOrNull(
          (workout) => workout.workoutID == itemId,
        );
        if (workoutFound != null) {
          return true;
        }
        return false;
      case FavouriteType.None:
        return false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/providers/wiki_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_tab.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/widgets/lesson/course_lesson.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_details.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;

class FavouritesLayout extends StatefulWidget {
  @override
  _FavouritesLayoutState createState() => _FavouritesLayoutState();
}

class _FavouritesLayoutState extends State<FavouritesLayout> {
  void _removeFavourite(
      FavouriteType favouriteType, dynamic item, bool isAdd) async {
    void removeFavouriteConfirmed(BuildContext context) async {
      switch (favouriteType) {
        case FavouriteType.Recipe:
          final recipeProvider =
              Provider.of<RecipesProvider>(context, listen: false);
          await recipeProvider.addToFavourites(item, false);
          recipeProvider.fetchAndSaveData();
          break;
        case FavouriteType.Wiki:
          final kbProvider = Provider.of<WikiProvider>(context, listen: false);
          await kbProvider.addToFavourites(item, false);
          kbProvider.fetchAndSaveData();
          break;
        case FavouriteType.Lesson:
          final modulesProvider =
              Provider.of<ModulesProvider>(context, listen: false);
          modulesProvider.addToFavourites(item, false);
          break;
        case FavouriteType.None:
          break;
      }
      Navigator.of(context).pop();
    }

    showAlertDialog(
      context,
      S.of(context).favouriteRemoveTitle,
      S.of(context).favouriteRemoveText,
      S.of(context).noText,
      S.of(context).yesText,
      removeFavouriteConfirmed,
      (BuildContext context) {
        Navigator.of(context).pop();
      },
    );
  }

  void _openFavourite(FavouriteType favouriteType, dynamic favourite) {
    Widget favouriteWidget;
    final String analyticsName = favouriteType == FavouriteType.Lesson
        ? Analytics.ANALYTICS_SCREEN_LESSON
        : Analytics.ANALYTICS_SCREEN_RECIPE_DETAIL;
    String analyticsId = "";

    if (favouriteType == FavouriteType.Lesson) {
      Lesson lesson = favourite;
      analyticsId = lesson.lessonID.toString();
      final modulesProvider =
          Provider.of<ModulesProvider>(context, listen: false);
      final List<LessonWiki> lessonWikis =
          modulesProvider.getLessonWikis(lesson.lessonID);
      final List<LessonRecipe> lessonRecipes =
          modulesProvider.getLessonRecipes(lesson.lessonID);
      favouriteWidget = CourseLesson(
        showDataUsageWarning: false,
        modulesProvider: modulesProvider,
        lesson: lesson,
        lessonWikis: lessonWikis,
        lessonRecipes: lessonRecipes,
        closeLesson: _closeFavourite,
        addToFavourites: _addLessonToFavourites,
      );
    } else {
      Recipe recipe = favourite;
      analyticsId = recipe.recipeId.toString();
      favouriteWidget = RecipeDetails(
        recipe: recipe,
        closeRecipeDetails: _closeFavourite,
        addToFavourites: _addRecipeToFavourites,
      );
    }

    openBottomSheet(
      context,
      favouriteWidget,
      analyticsName,
      analyticsId,
    );
  }

  void _closeFavourite() {
    Navigator.pop(context);
  }

  void _addLessonToFavourites(
      final ModulesProvider modulesProvider, dynamic lesson, bool add) {
    modulesProvider.addToFavourites(lesson, add);
  }

  void _addRecipeToFavourites(dynamic recipe, bool add) async {
    final recipeProvider = Provider.of<RecipesProvider>(context, listen: false);
    await recipeProvider.addToFavourites(recipe, add);
    recipeProvider.fetchAndSaveData();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: screenSize.width,
            decoration: BoxDecoration(color: Colors.white),
            child: Align(
              alignment: Alignment.center,
              child: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    text: S.of(context).toolkitTitle,
                    icon: Icon(
                      Icons.construction,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  Tab(
                    text: S.of(context).lessonsTitle,
                    icon: Icon(
                      Icons.play_circle_outline,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  Tab(
                    text: S.of(context).wikiTitle,
                    icon: Icon(
                      Icons.batch_prediction,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  Tab(
                    text: S.of(context).recipesTitle,
                    icon: Icon(
                      Icons.local_dining,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 4.0,
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 1.0,
            child: Container(
              decoration: BoxDecoration(color: primaryColor),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Consumer3<ModulesProvider, WikiProvider,
                        RecipesProvider>(
                      builder: (context, modulesProvider, wikiProvider,
                              recipesProvider, child) =>
                          TabBarView(
                        children: [
                          FavouritesTab(
                            screenSize: screenSize,
                            favourites: modulesProvider.favouriteToolkitLessons,
                            status: modulesProvider.status,
                            favouriteType: FavouriteType.Lesson,
                            isToolkit: true,
                            removeFavourite: _removeFavourite,
                            openFavourite: _openFavourite,
                          ),
                          FavouritesTab(
                            screenSize: screenSize,
                            favourites: modulesProvider.favouriteLessons,
                            status: modulesProvider.status,
                            favouriteType: FavouriteType.Lesson,
                            isToolkit: false,
                            removeFavourite: _removeFavourite,
                            openFavourite: _openFavourite,
                          ),
                          FavouritesTab(
                            screenSize: screenSize,
                            favourites: wikiProvider.favourites,
                            status: wikiProvider.status,
                            favouriteType: FavouriteType.Wiki,
                            isToolkit: false,
                            removeFavourite: _removeFavourite,
                            openFavourite: _openFavourite,
                          ),
                          FavouritesTab(
                            screenSize: screenSize,
                            favourites: recipesProvider.favourites,
                            status: recipesProvider.status,
                            favouriteType: FavouriteType.Recipe,
                            isToolkit: false,
                            removeFavourite: _removeFavourite,
                            openFavourite: _openFavourite,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

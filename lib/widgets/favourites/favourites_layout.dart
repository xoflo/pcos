import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_wiki_full.dart';
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
        getPreviousModuleLessons: () {},
      );
    } else if (favouriteType == FavouriteType.Wiki) {
      LessonWiki lessonWiki = favourite;
      analyticsId = lessonWiki.questionId.toString();
      favouriteWidget = LessonWikiFull(
        parentContext: context,
        wiki: lessonWiki,
        isFavourite: true,
        closeWiki: _closeFavourite,
      );
    } else {
      Recipe recipe = favourite;
      analyticsId = recipe.recipeId.toString();
      favouriteWidget = RecipeDetails(
        recipe: recipe,
        isFavourite: true,
        closeRecipeDetails: _closeFavourite,
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

  void _removeFavourite(FavouriteType favouriteType, dynamic item) async {
    final itemId = favouriteType == FavouriteType.Lesson
        ? item.lessonID
        : favouriteType == FavouriteType.Wiki
            ? item.questionId
            : item.recipeId;
    void removeFavouriteConfirmed(BuildContext context) async {
      Provider.of<FavouritesProvider>(context, listen: false)
          .addToFavourites(favouriteType, itemId);
      Navigator.of(context).pop();
    }

    showAlertDialog(
      context,
      S.current.favouriteRemoveTitle,
      S.current.favouriteRemoveText,
      S.current.noText,
      S.current.yesText,
      removeFavouriteConfirmed,
      (BuildContext context) {
        Navigator.of(context).pop();
      },
    );
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
                    text: S.current.toolkitTitle,
                    icon: Icon(
                      Icons.construction,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  Tab(
                    text: S.current.lessonsTitle,
                    icon: Icon(
                      Icons.play_circle_outline,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  Tab(
                    text: S.current.wikiTitle,
                    icon: Icon(
                      Icons.batch_prediction,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  Tab(
                    text: S.current.recipesTitle,
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
                    child: Consumer<FavouritesProvider>(
                      builder: (context, favouritesProvider, child) =>
                          TabBarView(
                        children: [
                          FavouritesTab(
                            screenSize: screenSize,
                            favourites: favouritesProvider.toolkits,
                            status: favouritesProvider.status,
                            favouriteType: FavouriteType.Lesson,
                            isToolkit: true,
                            openFavourite: _openFavourite,
                            removeFavourite: _removeFavourite,
                          ),
                          FavouritesTab(
                            screenSize: screenSize,
                            favourites: favouritesProvider.lessons,
                            status: favouritesProvider.status,
                            favouriteType: FavouriteType.Lesson,
                            isToolkit: false,
                            openFavourite: _openFavourite,
                            removeFavourite: _removeFavourite,
                          ),
                          FavouritesTab(
                            screenSize: screenSize,
                            favourites: favouritesProvider.lessonWikis,
                            status: favouritesProvider.status,
                            favouriteType: FavouriteType.Wiki,
                            isToolkit: false,
                            openFavourite: _openFavourite,
                            removeFavourite: _removeFavourite,
                          ),
                          FavouritesTab(
                            screenSize: screenSize,
                            favourites: favouritesProvider.recipes,
                            status: favouritesProvider.status,
                            favouriteType: FavouriteType.Recipe,
                            isToolkit: false,
                            openFavourite: _openFavourite,
                            removeFavourite: _removeFavourite,
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

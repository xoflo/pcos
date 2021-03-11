import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/knowledge_base_provider.dart';
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_recipes_list.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_lessons_list.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/widgets/shared/question_list.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/course_lesson.dart';
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
  Widget getFavouritesList(
    final BuildContext context,
    final Size screenSize,
    final List<dynamic> favourites,
    final LoadingStatus status,
    final FavouriteType favouriteType,
  ) {
    switch (status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.of(context).noItemsFound);
      case LoadingStatus.success:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: getContent(
            context,
            screenSize,
            favourites,
            favouriteType,
          ),
        );
    }
    return Container();
  }

  Widget getContent(
    final BuildContext context,
    final Size screenSize,
    final List<dynamic> favourites,
    final FavouriteType favouriteType,
  ) {
    switch (favouriteType) {
      case FavouriteType.Lesson:
        return FavouritesLessonsList(
          lessons: favourites,
          width: screenSize.width,
          removeFavourite: _removeFavourite,
          openFavourite: _openFavourite,
        );
      case FavouriteType.KnowledgeBase:
        return QuestionList(
          screenSize: screenSize,
          questions: favourites,
          showIcon: true,
          iconData: Icons.delete,
          iconDataOn: Icons.delete,
          iconAction: _removeFavourite,
        );
      case FavouriteType.Recipe:
        return FavouritesRecipesList(
          recipes: favourites,
          width: screenSize.width,
          removeFavourite: _removeFavourite,
          openFavourite: _openFavourite,
        );
      case FavouriteType.None:
        return Container();
    }
    return Container();
  }

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
        case FavouriteType.KnowledgeBase:
          final kbProvider =
              Provider.of<KnowledgeBaseProvider>(context, listen: false);
          await kbProvider.addToFavourites(item, false);
          kbProvider.fetchAndSaveData();
          break;
        case FavouriteType.Lesson:
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
      analyticsId = lesson.lessonId.toString();
      favouriteWidget = CourseLesson(
        lesson: lesson,
        closeLesson: closeFavourite,
        addToFavourites: addLessonToFavourites,
      );
    } else {
      Recipe recipe = favourite;
      analyticsId = recipe.recipeId.toString();
      favouriteWidget = RecipeDetails(
        recipe: recipe,
        closeRecipeDetails: closeFavourite,
        addToFavourites: addRecipeToFavourites,
      );
    }

    openBottomSheet(
      context,
      favouriteWidget,
      analyticsName,
      analyticsId,
    );
  }

  void closeFavourite() {
    Navigator.pop(context);
  }

  void addLessonToFavourites(dynamic lesson, bool add) {
    debugPrint("*********ADD LESSON TO FAVE");
  }

  void addRecipeToFavourites(dynamic recipe, bool add) async {
    final recipeProvider = Provider.of<RecipesProvider>(context, listen: false);
    await recipeProvider.addToFavourites(recipe, add);
    recipeProvider.fetchAndSaveData();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return DefaultTabController(
      length: 3,
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
                    text: S.of(context).lessonsTitle,
                    icon: Icon(
                      Icons.play_circle_outline,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  Tab(
                    text: S.of(context).knowledgeBaseTitle,
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
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 6.0,
              ),
              child: Container(
                //Add this to give height
                height: DeviceUtils.getRemainingHeight(
                    MediaQuery.of(context).size.height,
                    true,
                    isHorizontal,
                    true,
                    true),
                child: TabBarView(
                  children: [
                    Consumer<FavouritesProvider>(
                      builder: (context, model, child) => SingleChildScrollView(
                        child: getFavouritesList(
                          context,
                          screenSize,
                          model.itemsLessons,
                          model.statusLessons,
                          FavouriteType.Lesson,
                        ),
                      ),
                    ),
                    Consumer<KnowledgeBaseProvider>(
                      builder: (context, model, child) => SingleChildScrollView(
                        child: getFavouritesList(
                          context,
                          screenSize,
                          model.favourites,
                          model.status,
                          FavouriteType.KnowledgeBase,
                        ),
                      ),
                    ),
                    Consumer<RecipesProvider>(
                      builder: (context, model, child) => SingleChildScrollView(
                        child: getFavouritesList(
                          context,
                          screenSize,
                          model.favourites,
                          model.status,
                          FavouriteType.Recipe,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
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

  void _removeFavourite(FavouriteType favouriteType, int id) {
    debugPrint("********REMOVE FAVE = $favouriteType $id");
  }

  void _openFavourite(FavouriteType favouriteType, dynamic favourite) {
    debugPrint("********OPEN FAVE = $favouriteType $favourite");
    Widget favouriteWidget;

    if (favouriteType == FavouriteType.Lesson) {
      Lesson lesson = favourite;
      favouriteWidget = CourseLesson(
        lessonId: lesson.lessonId,
        closeLesson: closeFavourite,
      );
    } else {
      Recipe recipe = favourite;
      favouriteWidget = RecipeDetails(
        recipe: recipe,
        closeRecipeDetails: closeFavourite,
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => favouriteWidget,
    );
  }

  void closeFavourite() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: DefaultTabController(
        length: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    text: S.of(context).lessonsTitle,
                    icon: Icon(
                      Icons.play_circle_outline,
                    ),
                  ),
                  Tab(
                    text: S.of(context).knowledgeBaseTitle,
                    icon: Icon(
                      Icons.batch_prediction,
                    ),
                  ),
                  Tab(
                    text: S.of(context).recipesTitle,
                    icon: Icon(
                      Icons.local_dining,
                    ),
                  ),
                ],
              ),
            ),
            Consumer<FavouritesProvider>(
              builder: (context, model, child) => Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 2.0,
                  right: 2.0,
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
                      SingleChildScrollView(
                        child: getFavouritesList(
                          context,
                          screenSize,
                          model.itemsLessons,
                          model.statusLessons,
                          FavouriteType.Lesson,
                        ),
                      ),
                      SingleChildScrollView(
                        child: getFavouritesList(
                          context,
                          screenSize,
                          model.itemsKnowledgeBase,
                          model.statusKnowledgeBase,
                          FavouriteType.KnowledgeBase,
                        ),
                      ),
                      SingleChildScrollView(
                        child: getFavouritesList(
                          context,
                          screenSize,
                          model.itemsRecipes,
                          model.statusRecipes,
                          FavouriteType.Recipe,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
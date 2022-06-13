import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_wiki_full.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_lessons.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_recipes.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_toolkits.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_wikis.dart';
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

class _FavouritesLayoutState extends State<FavouritesLayout>
    with TickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;
  int index = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: index, length: 4, vsync: this);
    pageController = PageController(initialPage: index);
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

  Tab generateTab(int itemNumber, String title) => Tab(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: index == itemNumber ? backgroundColor : Colors.white,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: index == itemNumber
                    ? Colors.white
                    : textColor.withOpacity(0.5),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: primaryColor),
          child: Align(
            alignment: Alignment.center,
            child: TabBar(
              onTap: (value) {
                setState(() => index = value);
                pageController.animateToPage(value,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeIn);
              },
              labelPadding: EdgeInsets.symmetric(horizontal: 10),
              controller: tabController,
              indicator: UnderlineTabIndicator(borderSide: BorderSide.none),
              isScrollable: true,
              tabs: [
                generateTab(0, S.current.toolkitTitle),
                generateTab(1, S.current.lessonsTitle),
                generateTab(2, S.current.wikiTitle),
                generateTab(3, S.current.recipesTitle),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Consumer<FavouritesProvider>(
                builder: (context, favouritesProvider, child) => PageView(
                  controller: pageController,
                  onPageChanged: (value) {
                    setState(() => index = value);
                    tabController.index = value;
                  },
                  children: [
                    FavouritesToolkits(
                      toolkits: favouritesProvider.toolkits,
                      status: favouritesProvider.status,
                    ),
                    FavouritesLessons(
                      favouritesProvider: favouritesProvider,
                    ),
                    FavouritesWikis(
                      favouritesProvider: favouritesProvider,
                    ),
                    FavouritesRecipes(
                      favouritesProvider: favouritesProvider,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

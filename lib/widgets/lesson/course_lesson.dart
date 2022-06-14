import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/course_lesson_content.dart';
import 'package:thepcosprotocol_app/widgets/lesson/wiki_page.dart';
import 'package:thepcosprotocol_app/widgets/lesson/recipes_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/dialog_header.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/widgets/shared/carousel_pager.dart';

class CourseLesson extends StatefulWidget {
  final ModulesProvider modulesProvider;
  final bool showDataUsageWarning;
  final Lesson lesson;
  final List<LessonWiki> lessonWikis;
  final List<LessonRecipe> lessonRecipes;
  final Function closeLesson;
  final Function getPreviousModuleLessons;

  CourseLesson({
    required this.modulesProvider,
    required this.showDataUsageWarning,
    required this.lesson,
    required this.lessonWikis,
    required this.lessonRecipes,
    required this.closeLesson,
    required this.getPreviousModuleLessons,
  });

  @override
  _CourseLessonState createState() => _CourseLessonState();
}

class _CourseLessonState extends State<CourseLesson> {
  List<LessonContent>? _lessonContent;
  bool _isLoading = true;
  bool _displayDataWarning = false;
  int _currentPage = 0;
  bool _lessonComplete = false;
  List<LessonRecipe> _lessonRecipes = [];

  @override
  void initState() {
    super.initState();
    initializeLesson();
  }

  void initializeLesson() async {
    List<LessonContent> lessonContents =
        widget.modulesProvider.getLessonContent(widget.lesson.lessonID);
    setState(() {
      _lessonContent = lessonContents;
      _lessonRecipes = widget.lessonRecipes;
      _isLoading = false;
      _displayDataWarning = widget.showDataUsageWarning;
    });
  }

  double _getTabBarHeight(BuildContext context) {
    return MediaQuery.of(context).size.height - (kToolbarHeight + 20);
  }

  void _onDismiss() {
    setState(() {
      _displayDataWarning = false;
    });
  }

  Widget _getDataUsageWarning(
      final BuildContext context, final Size screenSize) {
    if (!_displayDataWarning) return Container();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        width: screenSize.width - 80,
        height: 136,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.warning,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        S.current.dataUsageWarningTitle,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Text(
                  S.current.dataUsageWarningText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: ColorButton(
                    isUpdating: false,
                    label: S.current.dismissText,
                    onTap: _onDismiss,
                    color: Colors.white,
                    textColor: primaryColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getLessonContentInColumn(
    final BuildContext context,
    final Size screenSize,
    final bool isHorizontal,
    final double tabBarHeight,
  ) {
    if (_isLoading) {
      return PcosLoadingSpinner();
    } else {
      analytics.logEvent(name: Analytics.ANALYTICS_EVENT_LESSON_COMPLETE);
      return SizedBox(
        height: tabBarHeight - 51,
        child: SingleChildScrollView(
          child: Column(
            children: _lessonContent?.map((LessonContent content) {
                  return CourseLessonContent(
                    lessonContent: content,
                    screenSize: screenSize,
                    isHorizontal: isHorizontal,
                    tabBarHeight: 0,
                    isPaged: false,
                  );
                }).toList() ??
                [],
          ),
        ),
      );
    }
  }

  Widget _getLessonContentInCarousel(
    final BuildContext context,
    final Size screenSize,
    final bool isHorizontal,
    final double tabBarHeight,
  ) {
    final int extraPages = (widget.lessonWikis.length == 0 ? 0 : 1) +
        (widget.lessonRecipes.length == 0 ? 0 : 1);
    final int totalPages =
        _lessonContent == null ? 0 : (_lessonContent?.length ?? 0) + extraPages;
    if (_isLoading) {
      return PcosLoadingSpinner();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              height: tabBarHeight - 77,
              enableInfiniteScroll: false,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                final int pageNumber = index + 1;
                //log which page is being read
                analytics.logEvent(
                  name: Analytics.ANALYTICS_EVENT_LESSON_PAGE,
                  parameters: {
                    Analytics.ANALYTICS_PARAMETER_LESSON_PAGE_NUMBER:
                        "$pageNumber/$totalPages"
                  },
                );
                bool isLessonComplete = false;
                if (index == totalPages - 1 && !_lessonComplete) {
                  //log lesson complete to analytics
                  analytics.logEvent(
                      name: Analytics.ANALYTICS_EVENT_LESSON_COMPLETE);
                  isLessonComplete = true;
                  //NB: if necessary could set lesson to complete when they goto the last page here, would also need to set for if only 1 page
                }
                setState(() {
                  _currentPage = index;
                  _lessonComplete = isLessonComplete;
                });
              },
            ),
            items: _getPages(screenSize, isHorizontal, tabBarHeight),
          ),
          Container(
            color: backgroundColor,
            child: CarouselPager(
                totalPages: totalPages,
                currentPage: _currentPage,
                bottomPadding: 6.0),
          ),
        ],
      );
    }
  }

  List<Widget> _getPages(final Size screenSize, final bool isHorizontal,
      final double tabBarHeight) {
    final List<Widget>? pages = _lessonContent?.map((LessonContent content) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(color: Colors.white),
            child: CourseLessonContent(
              lessonContent: content,
              screenSize: screenSize,
              isHorizontal: isHorizontal,
              tabBarHeight: tabBarHeight + 177,
              isPaged: true,
            ),
          );
        },
      );
    }).toList();

    //add the wiki page if needed
    if (widget.lessonWikis.length > 0) {
      pages?.add(_getWikiPage(screenSize, isHorizontal, tabBarHeight));
    }

    //add the Recipes page if needed
    if (widget.lessonRecipes.length > 0) {
      pages?.add(_getRecipesPage(screenSize, isHorizontal, tabBarHeight));
    }

    return pages ?? [];
  }

  Widget _getWikiPage(final Size screenSize, final bool isHorizontal,
      final double tabBarHeight) {
    return Builder(builder: (BuildContext context) {
      return WikiPage(
        isHorizontal: isHorizontal,
        wikis: widget.lessonWikis,
        parentContext: context,
      );
    });
  }

  Widget _getRecipesPage(final Size screenSize, final bool isHorizontal,
      final double tabBarHeight) {
    return Builder(builder: (BuildContext context) {
      return RecipesPage(
        screenSize: screenSize,
        isHorizontal: isHorizontal,
        recipes: _lessonRecipes,
        parentContext: context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);
    final double tabBarHeight = _getTabBarHeight(context);
    return Consumer<FavouritesProvider>(
      builder: (context, favouritesProvider, child) => SafeArea(
        child: Container(
          height: tabBarHeight,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              DialogHeader(
                screenSize: screenSize,
                item: widget.lesson,
                favouriteType: FavouriteType.Lesson,
                title: widget.lesson.title,
                isFavourite: favouritesProvider.isFavourite(
                    FavouriteType.Lesson, widget.lesson.lessonID),
                closeItem: widget.closeLesson,
                isToolkit: widget.lesson.isToolkit,
                onAction: widget.getPreviousModuleLessons,
              ),
              _getDataUsageWarning(context, screenSize),
              _lessonContent == null
                  ? Container()
                  : _lessonContent?.length == 1 &&
                          widget.lessonWikis.length == 0 &&
                          widget.lessonRecipes.length == 0
                      ? _getLessonContentInColumn(
                          context, screenSize, isHorizontal, tabBarHeight)
                      : _getLessonContentInCarousel(
                          context, screenSize, isHorizontal, tabBarHeight),
            ],
          ),
        ),
      ),
    );
  }
}

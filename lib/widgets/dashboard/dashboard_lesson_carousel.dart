import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_arguments.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/screens/other/quiz.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/dashboard_lesson_carousel_item_card.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_page.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_list_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;

class DashboardLessonCarousel extends StatefulWidget {
  DashboardLessonCarousel({Key? key, required this.modulesProvider})
      : super(key: key);
  final ModulesProvider modulesProvider;

  @override
  State<DashboardLessonCarousel> createState() =>
      _DashboardLessonCarouselState();
}

class _DashboardLessonCarouselState extends State<DashboardLessonCarousel> {
  PageController? controller;

  int activePage = 0;

  Widget getLockedComponent(String text) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            Icon(Icons.lock_outline),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );

  List<Widget> generateIndicators() =>
      List<Widget>.generate(widget.modulesProvider.currentModuleLessons.length,
          (index) {
        return Container(
            margin: const EdgeInsets.all(3),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: activePage == index
                  ? selectedIndicatorColor
                  : unselectedIndicatorColor,
              shape: BoxShape.circle,
            ));
      });

  @override
  Widget build(BuildContext context) {
    switch (widget.modulesProvider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.current.noResultsLessons);
      case LoadingStatus.success:
        if (controller == null) {
          activePage = widget.modulesProvider.currentModuleLessons.indexWhere(
            (element) =>
                element.lessonID ==
                widget.modulesProvider.currentLesson?.lessonID,
          );
          controller =
              PageController(initialPage: activePage, viewportFraction: 0.9);
        }

        return Column(
          children: [
            Container(
              height: 500,
              child: PageView.builder(
                controller: controller,
                itemCount: widget.modulesProvider.currentModuleLessons.length,
                pageSnapping: true,
                itemBuilder: (context, index) {
                  final currentLesson =
                      widget.modulesProvider.currentModuleLessons[index];
                  final currentLessonContent = widget.modulesProvider
                      .getLessonContent(currentLesson.lessonID);
                  final currentLessonWikis = widget.modulesProvider
                      .getLessonWikis(currentLesson.lessonID);
                  final currentLessonTasks = widget.modulesProvider
                      .getLessonTasks(currentLesson.lessonID);
                  final currentLessonRecipes = widget.modulesProvider
                      .getLessonRecipes(currentLesson.lessonID);
                  final isLessonComplete = currentLesson.isComplete;

                  // If the previous lesson is already complete, then we must lock
                  // the current lesson. But when the item is the first one, then
                  // we should set to true so that the current index will not
                  // be locked. It doesn't make sense to lock the first lesson,
                  // after all.
                  final isPreviousLessonComplete = index == 0
                      ? true
                      : widget.modulesProvider.currentModuleLessons[index - 1]
                          .isComplete;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 25,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (isPreviousLessonComplete)
                                Expanded(
                                  child: Text(
                                    widget.modulesProvider.currentModule
                                            ?.title ??
                                        "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                      fontSize: 24,
                                    ),
                                  ),
                                )
                              else
                                getLockedComponent("Complete the early lesson"),
                              Opacity(
                                opacity: isPreviousLessonComplete ? 1 : 0.5,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Icon(Icons.restaurant),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 25),
                          DashboardLessonCarouselItemCard(
                            onTapCard:
                                isPreviousLessonComplete // && isLessonComplete
                                    ? () => Navigator.pushNamed(
                                          context,
                                          LessonPage.id,
                                          arguments: LessonArguments(
                                            currentLesson,
                                            currentLessonContent,
                                            currentLessonTasks,
                                            currentLessonWikis,
                                          ),
                                        )
                                    : null,
                            isLocked: isPreviousLessonComplete,
                            title: "Lesson ${index + 1}",
                            subtitle: currentLesson.title,
                            duration: "5 mins",
                            asset: 'assets/dashboard_lesson.png',
                            assetSize: Size(84, 84),
                          ),
                          if (currentLessonRecipes.length > 0) ...[
                            SizedBox(height: 15),
                            DashboardLessonCarouselItemCard(
                              onTapCard:
                                  isPreviousLessonComplete && isLessonComplete
                                      ? () => Navigator.pushNamed(
                                            context,
                                            RecipeListPage.id,
                                            arguments: currentLessonRecipes,
                                          )
                                      : null,
                              isLocked: isPreviousLessonComplete,
                              title: "Lesson Recipes",
                              duration: "5 mins",
                              asset: 'assets/dashboard_recipes.png',
                              assetSize: Size(84, 90),
                            ),
                          ],
                          if (widget.modulesProvider.lessonQuizzes.length >
                              0) ...[
                            SizedBox(height: 15),
                            DashboardLessonCarouselItemCard(
                              onTapCard: isPreviousLessonComplete &&
                                      isLessonComplete
                                  ? () {
                                      analytics.logEvent(
                                          name:
                                              Analytics.ANALYTICS_SCREEN_QUIZ);
                                      Navigator.pushNamed(
                                          context, QuizScreen.id);
                                    }
                                  : null,
                              isLocked: isPreviousLessonComplete,
                              title: "Quiz",
                              duration: "5 mins",
                              asset: 'assets/dashboard_quiz.png',
                              assetSize: Size(88, 95),
                            ),
                            //
                          ]
                        ],
                      ),
                    ),
                  );
                },
                onPageChanged: (page) => setState(() => activePage = page),
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: generateIndicators(),
            ),
            SizedBox(height: 30)
          ],
        );
    }
  }
}
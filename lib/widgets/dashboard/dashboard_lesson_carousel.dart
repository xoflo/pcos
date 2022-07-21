import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_arguments.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/screens/other/quiz.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/dashboard_lesson_carousel_item_card.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/dashboard_lesson_locked_component.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_page.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_list_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;

class DashboardLessonCarousel extends StatefulWidget {
  DashboardLessonCarousel({
    Key? key,
    required this.modulesProvider,
    required this.showLessonRecipes,
  }) : super(key: key);
  final ModulesProvider modulesProvider;
  final bool showLessonRecipes;

  @override
  State<DashboardLessonCarousel> createState() =>
      _DashboardLessonCarouselState();
}

class _DashboardLessonCarouselState extends State<DashboardLessonCarousel> {
  PageController? controller;

  int activePage = 0;

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
        return Center(child: NoResults(message: S.current.noResultsLessons));
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
              height: 505,
              child: PageView.builder(
                controller: controller,
                itemCount: widget.modulesProvider.currentModuleLessons.length,
                pageSnapping: true,
                itemBuilder: (context, index) {
                  final currentLesson =
                      widget.modulesProvider.currentModuleLessons[index];

                  final currentLessonQuiz = widget.modulesProvider
                      .getQuizByLessonID(currentLesson.lessonID);

                  final currentLessonRecipes = widget.modulesProvider
                      .getLessonRecipes(currentLesson.lessonID);
                  final isLessonComplete = currentLesson.isComplete;

                  int lessonRecipeDuration = 0;
                  currentLessonRecipes.forEach((element) {
                    lessonRecipeDuration += element.duration ?? 0;
                  });

                  // We must lock the current lesson, if and only if the
                  // previous lesson is not yet complete or if the current
                  // lesson is not yet available. But when the item is the
                  // first one, then we should set to true so that the current
                  // index will not be locked. It doesn't make sense to lock
                  // the first lesson, after all.
                  final isPreviousLessonComplete = index == 0
                      ? true
                      : (widget.modulesProvider.currentModuleLessons[index - 1]
                              .isComplete ||
                          widget.modulesProvider.currentModuleLessons[index - 1]
                                  .hoursToNextLesson ==
                              0);

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
                                DashboardLessonLockedComponent(
                                    title: "Complete the early lesson"),
                              Opacity(
                                opacity: isPreviousLessonComplete ? 1 : 0.5,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: widget.modulesProvider.currentModule
                                              ?.iconUrl?.isNotEmpty ==
                                          true
                                      ? Image.network(
                                          widget.modulesProvider.currentModule
                                                  ?.iconUrl ??
                                              "",
                                          fit: BoxFit.contain,
                                          height: 24,
                                          width: 24,
                                        )
                                      : Icon(Icons.restaurant),
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
                                          arguments:
                                              LessonArguments(currentLesson),
                                        ).then((value) {
                                          if (value is bool) {
                                            widget.modulesProvider
                                                .fetchAndSaveData(value);
                                          }
                                        })
                                    : null,
                            showCompletedTag: isLessonComplete,
                            isUnlocked: isPreviousLessonComplete,
                            title: "Lesson ${index + 1}",
                            subtitle: currentLesson.title,
                            duration: "${currentLesson.minsToComplete} mins",
                            asset: 'assets/dashboard_lesson.png',
                            assetSize: Size(84, 84),
                          ),
                          if (widget.showLessonRecipes &&
                              currentLessonRecipes.length > 0) ...[
                            SizedBox(height: 15),
                            DashboardLessonCarouselItemCard(
                              onTapCard:
                                  isPreviousLessonComplete // && isLessonComplete
                                      ? () => Navigator.pushNamed(
                                            context,
                                            RecipeListPage.id,
                                            arguments: currentLessonRecipes,
                                          )
                                      : null,
                              isUnlocked: isPreviousLessonComplete,
                              title: "Lesson Recipes",
                              duration:
                                  "${Duration(milliseconds: lessonRecipeDuration).inMinutes} " +
                                      S.current.minutesShort,
                              asset: 'assets/dashboard_recipes.png',
                              assetSize: Size(84, 90),
                            ),
                          ],
                          if (currentLessonQuiz != null) ...[
                            SizedBox(height: 15),
                            DashboardLessonCarouselItemCard(
                              onTapCard: isPreviousLessonComplete &&
                                      isLessonComplete
                                  ? () {
                                      analytics.logEvent(
                                          name:
                                              Analytics.ANALYTICS_SCREEN_QUIZ);
                                      Navigator.pushNamed(
                                        context,
                                        QuizScreen.id,
                                        arguments: currentLessonQuiz,
                                      );
                                    }
                                  : null,
                              showCompletedTag:
                                  currentLessonQuiz.isComplete == true,
                              showCompleteLesson: !isLessonComplete,
                              isUnlocked:
                                  isPreviousLessonComplete && isLessonComplete,
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

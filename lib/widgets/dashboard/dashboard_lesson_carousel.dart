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
              height: 530,
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

                  // Initially, all lessons in the current module are already
                  // loaded. However, each lesson needs to be checked if
                  // they are already unlocked. The first lesson of the module is
                  // automatically unlocked. But for the rest of the lessons
                  // to be unlocked, the previous one must be completed first.
                  // But the app still needs to check if the lesson is already
                  // available to access for the user. The server determines the
                  // availability of the lesson so that the user will not
                  // be able to simultaneously finish all the lessons and all
                  // the modules in one sitting. This also allows other users
                  // to save the lessons for later and go over them on their
                  // own pace. The computation for this value is already done
                  // in the server, based on the number of hours since the user
                  // completed the very first lesson in the module.
                  final isLessonUnlocked = index == 0
                      ? true
                      : (widget.modulesProvider.currentModuleLessons[index - 1]
                              .isComplete &&
                          currentLesson.hoursUntilAvailable == 0);

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
                              if (isLessonUnlocked)
                                Expanded(
                                  child: Text(
                                    widget.modulesProvider.currentModule
                                            ?.title ??
                                        "",
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                )
                              else
                                DashboardLessonLockedComponent(
                                    title: "Complete the previous lesson"),
                              Opacity(
                                opacity: isLessonUnlocked ? 1 : 0.5,
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
                            onTapCard: isLessonUnlocked
                                ? () => Navigator.pushNamed(
                                      context,
                                      LessonPage.id,
                                      arguments: LessonArguments(currentLesson),
                                    )
                                : null,
                            showCompletedTag: isLessonComplete,
                            isUnlocked: isLessonUnlocked,
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
                              onTapCard: isLessonUnlocked
                                  ? () => Navigator.pushNamed(
                                        context,
                                        RecipeListPage.id,
                                        arguments: currentLessonRecipes,
                                      )
                                  : null,
                              isUnlocked: isLessonUnlocked,
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
                              onTapCard: isLessonUnlocked && isLessonComplete
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
                              isUnlocked: isLessonUnlocked && isLessonComplete,
                              title: "Quiz",
                              duration: "5 mins",
                              asset: 'assets/dashboard_quiz.png',
                              assetSize: Size(88, 95),
                            ),
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

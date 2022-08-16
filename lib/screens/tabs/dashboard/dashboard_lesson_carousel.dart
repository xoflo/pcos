import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_arguments.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/providers/preferences_provider.dart';
import 'package:thepcosprotocol_app/screens/tabs/more/quiz.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/dashboard_lesson_carousel_item_card.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/dashboard_lesson_locked_component.dart';
import 'package:thepcosprotocol_app/screens/lesson/lesson_page.dart';
import 'package:thepcosprotocol_app/screens/tabs/recipes/recipe_list_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;

class DashboardLessonCarousel extends StatelessWidget {
  DashboardLessonCarousel({
    Key? key,
  }) : super(key: key);

  // final bool showLessonRecipes;

  // int activePage = 0;

  List<Widget> generateIndicators(ModulesProvider modulesProvider) =>
      List<Widget>.generate(modulesProvider.currentModuleLessons.length,
          (index) {
        return Container(
            margin: const EdgeInsets.all(3),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: 0 == index
                  ? selectedIndicatorColor
                  : unselectedIndicatorColor,
              shape: BoxShape.circle,
            ));
      });

  @override
  Widget build(BuildContext context) {
    PageController? controller;
    ModulesProvider modulesProvider = Provider.of<ModulesProvider>(context);

    // switch (modulesProvider.status) {
    //   case LoadingStatus.loading:
    //     return PcosLoadingSpinner();
    //   case LoadingStatus.empty:
    //     return Center(child: NoResults(message: S.current.noResultsLessons));
    //   case LoadingStatus.success:
    //     if (controller == null) {
    //       // activePage = modulesProvider.currentModuleLessons.indexWhere(
    //       //   (element) =>
    //       //       element.lessonID ==
    //       //       modulesProvider.currentLesson?.lessonID,
    //       // );
    //       controller =
    //           PageController(initialPage: 0, viewportFraction: 0.9);
    //     }

    if (controller == null) {
      // activePage = modulesProvider.currentModuleLessons.indexWhere(
      //   (element) =>
      //       element.lessonID ==
      //       modulesProvider.currentLesson?.lessonID,
      // );
      controller = PageController(initialPage: 0, viewportFraction: 0.9);
    }

    return Container(child: getCarouselWidget(context, modulesProvider, controller));
  }

  Widget getCarouselWidget(
    BuildContext context, 
  ModulesProvider modulesProvider, 
  PageController controller) {
    if (modulesProvider.status == LoadingStatus.empty) {
      return Center(child: NoResults(message: S.current.noResultsLessons));
    } else {
      PreferencesProvider prefsProvider =
          Provider.of<PreferencesProvider>(context);

      return Column(
        children: [
          Container(
            height: 530,
            child: PageView.builder(
              controller: controller,
              itemCount: modulesProvider.currentModuleLessons.length,
              pageSnapping: true,
              itemBuilder: (context, index) {
                final currentLesson =
                    modulesProvider.currentModuleLessons[index];

                final currentLessonQuiz =
                    modulesProvider.getQuizByLessonID(currentLesson.lessonID);

                final currentLessonRecipes =
                    modulesProvider.getLessonRecipes(currentLesson.lessonID);
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
                    : (modulesProvider
                            .currentModuleLessons[index - 1].isComplete &&
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
                                  modulesProvider.currentModule?.title ?? "",
                                  style: Theme.of(context).textTheme.headline3,
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
                                child: modulesProvider.currentModule?.iconUrl
                                            ?.isNotEmpty ==
                                        true
                                    ? Image.network(
                                        modulesProvider
                                                .currentModule?.iconUrl ??
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
                        OpenContainer(
                          tappable: isLessonUnlocked,
                          transitionDuration: Duration(milliseconds: 400),
                          routeSettings: RouteSettings(
                              name: LessonPage.id,
                              arguments: LessonArguments(currentLesson)),
                          openBuilder: (context, closedContainer) {
                            return LessonPage();
                          },
                          closedBuilder: (context, openContainer) {
                            return Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(15),
                              child: DashboardLessonCarouselItemCard(
                                showCompletedTag: isLessonComplete,
                                isUnlocked: isLessonUnlocked,
                                title: currentLesson.title,
                                subtitle: "Lesson ${index + 1}",
                                duration:
                                    "${currentLesson.minsToComplete} mins",
                                asset: 'assets/dashboard_lesson.png',
                                assetSize: Size(84, 84),
                              ),
                            );
                          },
                        ),
                        if (prefsProvider.isShowLessonRecipes &&
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
                                        name: Analytics.ANALYTICS_SCREEN_QUIZ);
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
              // onPageChanged: (page) => setState(() => activePage = page),
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: generateIndicators(modulesProvider),
          ),
          SizedBox(height: 30)
        ],
      );
    }
  }
  // }
}

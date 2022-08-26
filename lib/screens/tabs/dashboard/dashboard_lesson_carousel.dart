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
import 'package:thepcosprotocol_app/screens/tabs/dashboard/carousel_page_indicator.dart';
import 'package:thepcosprotocol_app/screens/lesson/lesson_page.dart';
import 'package:thepcosprotocol_app/screens/tabs/recipes/recipe_list_page.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_with_change_notifier.dart';

class DashboardLessonCarousel extends StatelessWidget {
  DashboardLessonCarousel({
    Key? key,
  }) : super(key: key);

  final activePage = ValueNotifier(0);
  final isPageScrollerInitialized = ValueNotifier(false);

  final PageController controller =
      PageController(initialPage: 0, keepPage: false, viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) => LoaderOverlay(
        loadingStatusNotifier:
            Provider.of<ModulesProvider>(context, listen: true),
        emptyMessage: S.current.noResultsLessons,
        overlayBackgroundColor: primaryColor,
        indicatorPosition: Alignment.topCenter,
        height: 585,
        child: Consumer<ModulesProvider>(
          builder: (context, modulesProvider, child) {
            if (modulesProvider.loadingStatus == LoadingStatus.success &&
                !isPageScrollerInitialized.value) {
              isPageScrollerInitialized.value = true;
              activePage.value =
                  modulesProvider.currentModuleLessons.indexWhere(
                (element) =>
                    element.lessonID == modulesProvider.currentLesson?.lessonID,
              );
            }

            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              if (controller.hasClients) {
                controller.jumpToPage(activePage.value);
              }
            });

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

                      final currentLessonQuiz = modulesProvider
                          .getQuizByLessonID(currentLesson.lessonID);

                      final currentLessonRecipes = modulesProvider
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

                      bool isLessonUnlocked = index == 0;

                      if (index > 0) {
                        final previousLesson =
                            modulesProvider.currentModuleLessons[index - 1];

                        // If there is a quiz in the previous lesson, we must check
                        // it first before the user proceeds to the next lesson.
                        final isPreviousLessonQuizComplete = modulesProvider
                                .getQuizByLessonID(previousLesson.lessonID)
                                ?.isComplete ??
                            true;

                        isLessonUnlocked = (previousLesson.isComplete &&
                            isPreviousLessonQuizComplete &&
                            currentLesson.hoursUntilAvailable == 0);
                      }

                      final lessonDuration = currentLesson.minsToComplete;

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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (isLessonUnlocked)
                                    Expanded(
                                      child: Text(
                                        modulesProvider.currentModule?.title ??
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: modulesProvider.currentModule
                                                  ?.iconUrl?.isNotEmpty ==
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
                                closedElevation: 0.0,
                                tappable: isLessonUnlocked,
                                transitionDuration: Duration(milliseconds: 400),
                                routeSettings: RouteSettings(
                                    name: LessonPage.id,
                                    arguments: LessonArguments(currentLesson)),
                                openBuilder: (context, closedContainer) =>
                                    LessonPage(),
                                closedShape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: tertiaryColor, width: 0),
                                    borderRadius: BorderRadius.circular(16)),
                                closedBuilder: (context, openContainer) =>
                                    Container(
                                  alignment: Alignment.center,
                                  child: DashboardLessonCarouselItemCard(
                                    showCompletedTag: isLessonComplete,
                                    isUnlocked: isLessonUnlocked,
                                    title: currentLesson.title,
                                    subtitle: "Lesson ${index + 1}",
                                    duration: lessonDuration == 0
                                        ? null
                                        : "$lessonDuration mins",
                                    asset: 'assets/dashboard_lesson.png',
                                    assetSize: Size(84, 84),
                                  ),
                                ),
                              ),
                              if (prefsProvider.isShowLessonRecipes &&
                                  currentLessonRecipes.length > 0) ...[
                                SizedBox(height: 15),
                                OpenContainer(
                                  closedElevation: 0.0,
                                  tappable: isLessonUnlocked,
                                  transitionDuration:
                                      Duration(milliseconds: 400),
                                  routeSettings: RouteSettings(
                                      name: RecipeListPage.id,
                                      arguments: currentLessonRecipes),
                                  openBuilder: (context, closedContainer) =>
                                      RecipeListPage(),
                                  closedShape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: tertiaryColor, width: 0),
                                      borderRadius: BorderRadius.circular(16)),
                                  closedBuilder: (context, openContainer) =>
                                      Container(
                                    alignment: Alignment.center,
                                    child: DashboardLessonCarouselItemCard(
                                      isUnlocked: isLessonUnlocked,
                                      title: "Lesson Recipes",
                                      duration:
                                          "${Duration(milliseconds: lessonRecipeDuration).inMinutes} " +
                                              S.current.minutesShort,
                                      asset: 'assets/dashboard_recipes.png',
                                      assetSize: Size(84, 90),
                                    ),
                                  ),
                                ),
                              ],
                              if (currentLessonQuiz != null) ...[
                                SizedBox(height: 15),
                                OpenContainer(
                                  closedElevation: 0.0,
                                  tappable:
                                      isLessonUnlocked && isLessonComplete,
                                  transitionDuration:
                                      Duration(milliseconds: 400),
                                  routeSettings: RouteSettings(
                                      name: QuizScreen.id,
                                      arguments: currentLessonQuiz),
                                  openBuilder: (context, closedContainer) {
                                    analytics.logEvent(
                                        name: Analytics.ANALYTICS_SCREEN_QUIZ);
                                    return QuizScreen();
                                  },
                                  closedShape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: tertiaryColor, width: 0),
                                      borderRadius: BorderRadius.circular(16)),
                                  closedBuilder: (context, openContainer) =>
                                      DashboardLessonCarouselItemCard(
                                    showCompletedTag:
                                        currentLessonQuiz.isComplete == true,
                                    showCompleteLesson: !isLessonComplete,
                                    isUnlocked:
                                        isLessonUnlocked && isLessonComplete,
                                    title: "Quiz",
                                    duration: "5 mins",
                                    asset: 'assets/dashboard_quiz.png',
                                    assetSize: Size(88, 95),
                                  ),
                                )
                              ]
                            ],
                          ),
                        ),
                      );
                    },
                    onPageChanged: (page) => activePage.value = page,
                  ),
                ),
                SizedBox(height: 15),
                ValueListenableBuilder<int>(
                  valueListenable: activePage,
                  builder: (context, value, child) => CarouselPageIndicator(
                    numberOfPages: modulesProvider.currentModuleLessons.length,
                    activePage: activePage,
                  ),
                ),
                SizedBox(height: 30)
              ],
            );
          },
        ),
      );
}

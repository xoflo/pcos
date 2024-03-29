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
  Widget build(BuildContext context) {
    final modulesProvider = Provider.of<ModulesProvider>(context);
    final prefsProvider = Provider.of<PreferencesProvider>(context);

    if (modulesProvider.loadingStatus == LoadingStatus.success &&
        !isPageScrollerInitialized.value) {
      isPageScrollerInitialized.value = true;
      activePage.value = modulesProvider.currentModuleLessons.indexWhere(
        (element) =>
            element.lessonID == modulesProvider.currentLesson?.lessonID,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (controller.hasClients) {
        controller.jumpToPage(activePage.value);
      }
    });

    return LoaderOverlay(
      loadingStatusNotifier: modulesProvider,
      loadingMessage: S.current.loadingLessons,
      emptyMessage: S.current.noResultsLessons,
      overlayBackgroundColor: primaryColor,
      indicatorPosition: Alignment.topCenter,
      isErrorDialogDismissible: true,
      retryAction: modulesProvider.fetchAndSaveData,
      positionalParams: [true],
      height: 585,
      child: Column(
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

                var isLessonUnlocked = currentLesson.isComplete ||
                    currentLesson.hoursUntilAvailable <= 0;
                var isPreviousLessonComplete = true;

                if (index > 0) {
                  final previousLesson =
                      modulesProvider.currentModuleLessons[index - 1];

                  // If there is a quiz in the previous lesson, we must check
                  // it first before the user proceeds to the next lesson.
                  final isPreviousLessonQuizComplete = modulesProvider
                          .getQuizByLessonID(previousLesson.lessonID)
                          ?.isComplete ??
                      true;

                  isPreviousLessonComplete =
                      previousLesson.isComplete && isPreviousLessonQuizComplete;

                  isLessonUnlocked = currentLesson.isComplete ||
                      (isPreviousLessonComplete &&
                          currentLesson.hoursUntilAvailable <= 0);
                }

                final unlockHint = isPreviousLessonComplete
                    ? "Unlock in ${currentLesson.hoursUntilAvailable} hours"
                    : "Lessons unlock daily or after\ncompleting previous";

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
                              DashboardLessonLockedComponent(title: unlockHint),
                            Opacity(
                              opacity: isLessonUnlocked ? 1 : 0.5,
                              child: Container(
                                padding: EdgeInsets.all(2),
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
                                    : // Placeholder if module icon is not available from API
                                    Image.asset(
                                        "assets/module_icon.png",
                                        height: 30,
                                        width: 30,
                                      ),
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
                              side: BorderSide(color: tertiaryColor, width: 0),
                              borderRadius: BorderRadius.circular(16)),
                          onClosed: (_) => activePage.value =
                              modulesProvider.currentModuleLessons.indexWhere(
                            (element) =>
                                element.lessonID ==
                                modulesProvider.currentLesson?.lessonID,
                          ),
                          closedBuilder: (context, openContainer) => Container(
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
                            transitionDuration: Duration(milliseconds: 400),
                            routeSettings: RouteSettings(
                                name: RecipeListPage.id,
                                arguments: currentLessonRecipes),
                            openBuilder: (context, closedContainer) =>
                                RecipeListPage(),
                            closedShape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: tertiaryColor, width: 0),
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
                            tappable: isLessonUnlocked && isLessonComplete,
                            transitionDuration: Duration(milliseconds: 400),
                            routeSettings: RouteSettings(
                                name: QuizScreen.id,
                                arguments: currentLessonQuiz),
                            openBuilder: (context, closedContainer) {
                              analytics.logEvent(
                                  name: Analytics.ANALYTICS_SCREEN_QUIZ);
                              return QuizScreen();
                            },
                            closedShape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: tertiaryColor, width: 0),
                                borderRadius: BorderRadius.circular(16)),
                            closedBuilder: (context, openContainer) =>
                                DashboardLessonCarouselItemCard(
                              showCompletedTag:
                                  currentLessonQuiz.isComplete == true,
                              showCompleteLesson: !isLessonComplete,
                              isUnlocked: isLessonUnlocked && isLessonComplete,
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/screens/other/quiz.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
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
                                Text(
                                  widget.modulesProvider.currentModule?.title ??
                                      "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    fontSize: 24,
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
                          Opacity(
                            opacity: isPreviousLessonComplete ? 1 : 0.5,
                            child: GestureDetector(
                              onTap:
                                  isPreviousLessonComplete && isLessonComplete
                                      ? () {}
                                      : null,
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 20),
                                decoration: BoxDecoration(
                                  color: lessonBackgroundColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Lesson ${index + 1}",
                                          style: TextStyle(
                                            color: backgroundColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        if (isLessonComplete) ...[
                                          SizedBox(width: 15),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: completedBackgroundColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 8),
                                            child: Text(
                                              "Completed",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    HtmlWidget(
                                      currentLesson.title,
                                      textStyle: TextStyle(
                                        color: textColor.withOpacity(0.8),
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.schedule,
                                            color: textColor, size: 15),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "5 min",
                                          style: TextStyle(
                                            color: textColor.withOpacity(0.8),
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (currentLessonRecipes.length > 0) ...[
                            SizedBox(height: 15),
                            Opacity(
                              opacity: isPreviousLessonComplete ? 1 : 0.5,
                              child: GestureDetector(
                                onTap:
                                    isPreviousLessonComplete && isLessonComplete
                                        ? () => Navigator.pushNamed(
                                              context,
                                              RecipeListPage.id,
                                              arguments: currentLessonRecipes,
                                            )
                                        : null,
                                child: Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 20),
                                  decoration: BoxDecoration(
                                    color: lessonBackgroundColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Lesson Recipes",
                                        style: TextStyle(
                                          color: backgroundColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Row(
                                        children: [
                                          Icon(Icons.schedule,
                                              color: textColor, size: 15),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "5 min",
                                            style: TextStyle(
                                              color: textColor.withOpacity(0.8),
                                              fontSize: 14,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                          if (widget.modulesProvider.lessonQuizzes.length >
                              0) ...[
                            SizedBox(height: 15),
                            Opacity(
                              opacity: isPreviousLessonComplete ? 1 : 0.5,
                              child: GestureDetector(
                                onTap:
                                    isPreviousLessonComplete && isLessonComplete
                                        ? () {
                                            analytics.logEvent(
                                                name: Analytics
                                                    .ANALYTICS_SCREEN_QUIZ);
                                            Navigator.pushNamed(
                                                context, QuizScreen.id);
                                          }
                                        : null,
                                child: Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 20),
                                  decoration: BoxDecoration(
                                    color: lessonBackgroundColor.withOpacity(
                                        isLessonComplete ? 1 : 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Quiz",
                                        style: TextStyle(
                                          color: backgroundColor.withOpacity(
                                              isLessonComplete ? 1 : 0.5),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      if (isLessonComplete)
                                        Row(
                                          children: [
                                            Icon(Icons.schedule,
                                                color: textColor, size: 15),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "5 min",
                                              style: TextStyle(
                                                color:
                                                    textColor.withOpacity(0.8),
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        )
                                      else
                                        getLockedComponent(
                                            "Complete the lesson")
                                    ],
                                  ),
                                ),
                              ),
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

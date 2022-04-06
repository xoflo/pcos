import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_card.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';

class CurrentModule extends StatelessWidget {
  final int selectedLesson;
  final double width;
  final bool isHorizontal;
  final ModulesProvider modulesProvider;
  final FavouritesProvider favouritesProvider;
  final bool showPreviousModule;
  final Function(Lesson, ModulesProvider) openLesson;
  final Function(BuildContext, ModulesProvider) openPreviousModules;
  final Function(ModulesProvider, int, Lesson) onLessonChanged;
  final Function(BuildContext, ModulesProvider) openLessonSearch;

  CurrentModule({
    @required this.selectedLesson,
    @required this.width,
    @required this.isHorizontal,
    @required this.modulesProvider,
    @required this.favouritesProvider,
    @required this.showPreviousModule,
    @required this.openLesson,
    @required this.openPreviousModules,
    @required this.onLessonChanged,
    @required this.openLessonSearch,
  });

  void _openLesson(final Lesson lesson) {
    openLesson(lesson, modulesProvider);
  }

  void _onLessonChanged(final int index) {
    final Lesson selectedLesson = modulesProvider.currentModuleLessons[index];
    onLessonChanged(modulesProvider, index, selectedLesson);
  }

  @override
  Widget build(BuildContext context) {
    int lessonCounter = 0;
    final String moduleTitle =
        this.modulesProvider.status == LoadingStatus.success
            ? "${S.current.moduleText}: ${modulesProvider.currentModule.title}"
            : "";
    return this.modulesProvider.status == LoadingStatus.success
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      moduleTitle,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ),
                SizedBox(
                  width: width,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 260,
                      enableInfiniteScroll: false,
                      viewportFraction: isHorizontal ? 0.50 : 0.92,
                      initialPage: selectedLesson == -1
                          ? modulesProvider.currentModuleLessons.length - 1
                          : selectedLesson,
                      onPageChanged: (index, reason) {
                        _onLessonChanged(index);
                      },
                    ),
                    items: modulesProvider.currentModuleLessons.map((lesson) {
                      lessonCounter += 1;
                      final int lessonNumber = lessonCounter;
                      return LessonCard(
                        lessonNumber: lessonNumber,
                        lesson: lesson,
                        isNew: true,
                        favouritesProvider: this.favouritesProvider,
                        openLesson: _openLesson,
                        refreshPreviousModules: () {},
                      );
                    }).toList(),
                  ),
                ),
                showPreviousModule
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                openLessonSearch(context, modulesProvider);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Icon(
                                  Icons.search,
                                  color: secondaryColor,
                                  size: 32,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                openPreviousModules(context, modulesProvider);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(S.current.viewPreviousModules,
                                        style:
                                            TextStyle(color: secondaryColor)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Icon(
                                        Icons.school,
                                        color: secondaryColor,
                                        size: 32,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          )
        : this.modulesProvider.status == LoadingStatus.empty
            ? NoResults(message: S.current.noResultsLessons)
            : PcosLoadingSpinner();
  }
}

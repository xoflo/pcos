import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_card.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class CurrentModule extends StatelessWidget {
  final int selectedLesson;
  final Size screenSize;
  final bool isHorizontal;
  final ModulesProvider modulesProvider;
  final bool showPreviousModule;
  final Function(Lesson, ModulesProvider) openLesson;
  final Function(BuildContext, ModulesProvider) openPreviousModules;
  final Function(int) onLessonChanged;
  final Function(BuildContext, ModulesProvider) openLessonSearch;

  CurrentModule({
    @required this.selectedLesson,
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.modulesProvider,
    @required this.showPreviousModule,
    @required this.openLesson,
    @required this.openPreviousModules,
    @required this.onLessonChanged,
    @required this.openLessonSearch,
  });

  void _openLesson(final Lesson lesson) {
    openLesson(lesson, modulesProvider);
  }

  @override
  Widget build(BuildContext context) {
    int lessonCounter = 0;
    final String moduleTitle =
        "${S.of(context).moduleText}: ${modulesProvider.currentModule.title}";
    return Container(
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
            width: screenSize.width,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 300,
                enableInfiniteScroll: false,
                viewportFraction: isHorizontal ? 0.50 : 0.92,
                initialPage: selectedLesson == -1
                    ? modulesProvider.currentModuleLessons.length - 1
                    : selectedLesson,
                onPageChanged: (index, reason) {
                  onLessonChanged(index);
                },
              ),
              items: modulesProvider.currentModuleLessons.map((lesson) {
                lessonCounter += 1;
                final int lessonNumber = lessonCounter;
                return Builder(
                  builder: (BuildContext context) {
                    return LessonCard(
                      lessonNumber: lessonNumber,
                      lesson: lesson,
                      displayIsNew: true,
                      openLesson: _openLesson,
                    );
                  },
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
                            size: 36,
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
                              Text(S.of(context).viewPreviousModules,
                                  style: TextStyle(color: secondaryColor)),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Icon(
                                  Icons.school,
                                  color: secondaryColor,
                                  size: 36,
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
    );
  }
}

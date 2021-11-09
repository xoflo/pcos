import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_card.dart';
import 'package:thepcosprotocol_app/widgets/modules/module_card.dart';

class PreviousModulesCarousel extends StatelessWidget {
  final Size screenSize;
  final bool isHorizontal;
  final List<Module> modules;
  final List<Lesson> lessons;
  final int selectedModuleID;
  final CarouselController lessonCarouselController;
  final Function(int, CarouselPageChangedReason) moduleChanged;
  final Function(Lesson) openLesson;
  final Function refreshPreviousModules;

  PreviousModulesCarousel({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.modules,
    @required this.lessons,
    @required this.selectedModuleID,
    @required this.lessonCarouselController,
    @required this.moduleChanged,
    @required this.openLesson,
    @required this.refreshPreviousModules,
  });

  @override
  Widget build(BuildContext context) {
    int moduleCounter = 0;
    int lessonCounter = 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SizedBox(
        width: screenSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 80,
                  enableInfiniteScroll: false,
                  viewportFraction: isHorizontal ? 0.3 : 0.5,
                  initialPage: modules.length - 1,
                  onPageChanged: (index, reason) {
                    moduleChanged(index, reason);
                  },
                ),
                items: modules.map((module) {
                  moduleCounter += 1;
                  final int moduleNumber = moduleCounter;
                  return Builder(
                    builder: (BuildContext context) {
                      final bool isSelected =
                          module.moduleID == selectedModuleID ? true : false;
                      return ModuleCard(
                        screenSize: screenSize,
                        moduleNumber: moduleNumber,
                        moduleName: module.title,
                        isSelected: isSelected,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CarouselSlider(
                carouselController: lessonCarouselController,
                options: CarouselOptions(
                  height: 300,
                  enableInfiniteScroll: false,
                  viewportFraction: isHorizontal ? 0.50 : 0.92,
                ),
                items: lessons.map((lesson) {
                  lessonCounter += 1;
                  final int lessonNumber = lessonCounter;
                  return Builder(
                    builder: (BuildContext context) {
                      debugPrint(
                          "LESSON title=${lesson.title} FAVE=${lesson.isFavorite}");
                      return LessonCard(
                        lessonNumber: lessonNumber,
                        lesson: lesson,
                        lessonFavourite: lesson.isFavorite,
                        isNew: false,
                        isPreviousModules: true,
                        openLesson: openLesson,
                        refreshPreviousModules: refreshPreviousModules,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

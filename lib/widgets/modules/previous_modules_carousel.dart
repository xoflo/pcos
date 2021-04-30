import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_card.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/module_card.dart';

class PreviousModulesCarousel extends StatelessWidget {
  final Size screenSize;
  final bool isHorizontal;
  final List<Module> modules;
  final List<Lesson> lessons;
  final int selectedModuleID;
  final Function(int, CarouselPageChangedReason) moduleChanged;
  final Function(Lesson) openLesson;

  PreviousModulesCarousel({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.modules,
    @required this.lessons,
    @required this.selectedModuleID,
    @required this.moduleChanged,
    @required this.openLesson,
  });

  @override
  Widget build(BuildContext context) {
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
                  return Builder(
                    builder: (BuildContext context) {
                      final bool isSelected =
                          module.moduleID == selectedModuleID ? true : false;
                      return ModuleCard(
                        screenSize: screenSize,
                        moduleNumber: module.moduleID,
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
                options: CarouselOptions(
                  height: 200,
                  enableInfiniteScroll: false,
                  viewportFraction: isHorizontal ? 0.50 : 0.92,
                ),
                items: lessons.map((lesson) {
                  return Builder(
                    builder: (BuildContext context) {
                      return LessonCard(
                        lesson: lesson,
                        openLesson: openLesson,
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

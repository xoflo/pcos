import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_card.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/module_card.dart';

class PreviousModules extends StatelessWidget {
  final Size screenSize;
  final bool isHorizontal;
  final Function openLesson;
  final Function closeLesson;

  PreviousModules({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.openLesson,
    @required this.closeLesson,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SizedBox(
        width: screenSize.width,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Previous Modules",
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 80,
                    enableInfiniteScroll: false,
                    viewportFraction: 0.5,
                    initialPage: 4,
                  ),
                  items: [1, 2, 3, 4].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        final bool isSelected = i == 3 ? true : false;
                        String moduleName = "What is your why?";
                        if (i == 2)
                          moduleName = "What is happening to you and why?";
                        if (i == 3) moduleName = "The healthy breakfast.";
                        if (i == 4) moduleName = "Increase your protein.";
                        return ModuleCard(
                          screenSize: screenSize,
                          moduleNumber: i,
                          moduleName: moduleName,
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
                    viewportFraction: 0.92,
                  ),
                  items: [1, 2, 3, 4, 5].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return LessonCard(
                          lessonId: i,
                          isNew: false,
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

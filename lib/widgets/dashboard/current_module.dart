import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_card.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class CurrentModule extends StatelessWidget {
  final Size screenSize;
  final bool isHorizontal;
  final ModulesProvider modulesProvider;
  final bool showPreviousModule;
  final Function(Lesson, ModulesProvider) openLesson;
  final Function(BuildContext, ModulesProvider) openPreviousModules;

  CurrentModule({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.modulesProvider,
    @required this.showPreviousModule,
    @required this.openLesson,
    @required this.openPreviousModules,
  });

  void _openLesson(final Lesson lesson) {
    openLesson(lesson, modulesProvider);
  }

  //TODO: check isComplete and set isNew for each lesson
  @override
  Widget build(BuildContext context) {
    final String moduleTitle =
        "${S.of(context).moduleText}: ${modulesProvider.currentModule.title}";
    debugPrint("No of Lessons= ${modulesProvider.currentModuleLessons.length}");
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
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          SizedBox(
            width: screenSize.width,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 200,
                enableInfiniteScroll: false,
                viewportFraction: isHorizontal ? 0.50 : 0.92,
                initialPage: modulesProvider.currentModuleLessons.length - 1,
              ),
              items: modulesProvider.currentModuleLessons.map((lesson) {
                return Builder(
                  builder: (BuildContext context) {
                    return LessonCard(
                      lesson: lesson,
                      isNew: false,
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
                  child: GestureDetector(
                    onTap: () {
                      openPreviousModules(context, modulesProvider);
                    },
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
                )
              : Container(),
        ],
      ),
    );
  }
}

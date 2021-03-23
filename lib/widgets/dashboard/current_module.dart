import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_card.dart';

class CurrentModule extends StatelessWidget {
  final Size screenSize;
  final bool isHorizontal;
  final String title;
  final List<Lesson> lessons;
  final Function(Lesson) openLesson;

  CurrentModule({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.title,
    @required this.lessons,
    @required this.openLesson,
  });

  //TODO: check isComplete and set isNew for each lesson
  @override
  Widget build(BuildContext context) {
    debugPrint("No of Lessons= ${lessons.length}");
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
                "Module: $title",
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
                initialPage: lessons.length - 1,
              ),
              items: lessons.map((lesson) {
                return Builder(
                  builder: (BuildContext context) {
                    return LessonCard(
                      lesson: lesson,
                      isNew: false,
                      openLesson: openLesson,
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Previous modules",
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
        ],
      ),
    );
  }
}

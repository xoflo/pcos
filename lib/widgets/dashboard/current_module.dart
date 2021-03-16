import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_card.dart';

class CurrentModule extends StatelessWidget {
  final bool isNew;
  final Size screenSize;
  final bool isHorizontal;
  final Function openLesson;

  CurrentModule({
    @required this.isNew,
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.openLesson,
  });

  final String moduleTitle = "Increasing Protein";
  final String lessonTitle = "Why a high protein breakfast?";
  final String lessonIntro =
      "In this lesson we look at why it is so important to start the day off with a healthy high protein breakfast, and how you can do this everyday.";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SizedBox(
          width: screenSize.width,
          child: CarouselSlider(
            options: CarouselOptions(
              height: 200,
              enableInfiniteScroll: false,
              viewportFraction: isHorizontal ? 0.50 : 0.92,
              initialPage: 5,
            ),
            items: [1, 2, 3, 4, 5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  final isNew = i == 5 ? true : false;
                  return LessonCard(
                    lessonId: i,
                    isNew: isNew,
                    openLesson: openLesson,
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

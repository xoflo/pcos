import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/task_card.dart';

class Tasks extends StatelessWidget {
  final Size screenSize;
  final bool isHorizontal;
  final List<LessonTask> lessonTasks;
  final Function onSubmit;

  Tasks({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.lessonTasks,
    @required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SizedBox(
        width: screenSize.width,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 205,
            enableInfiniteScroll: false,
            viewportFraction: 0.92,
            initialPage: lessonTasks.length - 1,
          ),
          items: lessonTasks.map((lessonTask) {
            return Builder(
              builder: (BuildContext context) {
                return TaskCard(
                  screenSize: screenSize,
                  isHorizontal: isHorizontal,
                  lessonTask: lessonTask,
                  onSubmit: onSubmit,
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

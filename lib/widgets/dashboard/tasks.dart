import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/task_card.dart';

class Tasks extends StatelessWidget {
  final Size screenSize;
  final bool isHorizontal;
  final ModulesProvider modulesProvider;

  Tasks({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.modulesProvider,
  });

  void _onSubmit(final int taskID, final String value) {
    modulesProvider.setTaskAsComplete(taskID, value);
  }

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
            height: 240,
            enableInfiniteScroll: false,
            viewportFraction: 0.92,
            initialPage: modulesProvider.displayLessonTasks.length - 1,
          ),
          items: modulesProvider.displayLessonTasks.map((lessonTask) {
            return Builder(
              builder: (BuildContext context) {
                return TaskCard(
                  screenSize: screenSize,
                  isHorizontal: isHorizontal,
                  lessonTask: lessonTask,
                  onSubmit: _onSubmit,
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

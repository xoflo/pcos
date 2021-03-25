import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/task_type.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/tasks/task_slider.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/tasks/task_bool.dart';

class TaskCard extends StatelessWidget {
  final Size screenSize;
  final bool isHorizontal;
  final LessonTask lessonTask;
  final Function onSubmit;

  TaskCard({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.lessonTask,
    @required this.onSubmit,
  });

  Widget _getTaskWidget(final LessonTask lessonTask) {
    debugPrint("***** TASK TYPE = ${lessonTask.taskType}");
    switch (lessonTask.taskType) {
      case TaskType.Slider:
        return TaskSlider(
          screenSize: screenSize,
          isHorizontal: isHorizontal,
          lessonTask: lessonTask,
          onSubmit: onSubmit,
        );
      case TaskType.Bool:
        return TaskBool(
          screenSize: screenSize,
          isHorizontal: isHorizontal,
          lessonTask: lessonTask,
          onSubmit: onSubmit,
        );
      default:
        return Container(child: Text("NOTHING"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: _getTaskWidget(lessonTask)),
      ),
    );
  }
}

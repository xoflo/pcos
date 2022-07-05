import 'package:thepcosprotocol_app/models/lesson.dart';

class LessonArguments {
  final Lesson lesson;
  final bool showTasks;

  LessonArguments(
    this.lesson, {
    this.showTasks = true,
  });
}

import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/models/module.dart';

class ModulesAndLessons {
  final List<Module> modules;
  final List<Lesson> lessons;
  final List<LessonContent> lessonContent;
  final List<LessonTask> lessonTasks;

  ModulesAndLessons({
    this.modules,
    this.lessons,
    this.lessonContent,
    this.lessonTasks,
  });
}

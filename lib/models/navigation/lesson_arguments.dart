import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';

class LessonArguments {
  final Lesson lesson;
  final List<LessonContent> lessonContents;
  final List<LessonTask> lessonTasks;
  final List<LessonWiki> lessonWikis;

  LessonArguments(
    this.lesson,
    this.lessonContents,
    this.lessonTasks,
    this.lessonWikis,
  );
}

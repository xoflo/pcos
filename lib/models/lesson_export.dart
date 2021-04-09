import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/lesson_content_list.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/models/lesson_task_list.dart';

class LessonExport {
  final Lesson lesson;
  final List<LessonContent> content;
  final List<LessonTask> tasks;

  LessonExport({
    this.lesson,
    this.content,
    this.tasks,
  });

  factory LessonExport.fromJson(Map<String, dynamic> json) {
    return LessonExport(
      lesson: Lesson.fromJson(json['lesson']),
      content: LessonContentList.fromList(json['content']).results,
      tasks: LessonTaskList.fromList(json['tasks']).results,
    );
  }
}

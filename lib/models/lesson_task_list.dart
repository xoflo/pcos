import 'package:thepcosprotocol_app/models/lesson_task.dart';

class LessonTaskList {
  List<LessonTask> results;

  LessonTaskList({this.results});

  factory LessonTaskList.fromList(List<dynamic> json) {
    List<LessonTask> contentList = [];
    if (json.length > 0) {
      json.forEach((item) {
        contentList.add(LessonTask.fromJson(item));
      });
    }
    return LessonTaskList(results: contentList);
  }
}

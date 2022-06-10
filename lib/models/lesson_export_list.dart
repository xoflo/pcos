import 'package:thepcosprotocol_app/models/lesson_export.dart';

class LessonExportList {
  List<LessonExport>? results;

  LessonExportList({this.results});

  factory LessonExportList.fromList(List<dynamic> json) {
    List<LessonExport> lessonList = [];
    if (json.length > 0) {
      json.forEach((item) {
        lessonList.add(LessonExport.fromJson(item));
      });
    }
    return LessonExportList(results: lessonList);
  }
}

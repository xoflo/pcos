import 'package:thepcosprotocol_app/models/lesson_content.dart';

class LessonContentList {
  List<LessonContent>? results;

  LessonContentList({this.results});

  factory LessonContentList.fromList(List<dynamic> json) {
    List<LessonContent> contentList = [];
    if (json.length > 0) {
      json.forEach((item) {
        contentList.add(LessonContent.fromJson(item));
      });
    }
    return LessonContentList(results: contentList);
  }
}

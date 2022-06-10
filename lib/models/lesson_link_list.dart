import 'package:thepcosprotocol_app/models/lesson_link.dart';

class LessonLinkList {
  List<LessonLink>? results;

  LessonLinkList({this.results});

  factory LessonLinkList.fromList(List<dynamic> json) {
    List<LessonLink> linkList = [];
    if (json.length > 0) {
      json.forEach((item) {
        linkList.add(LessonLink.fromJson(item));
      });
    }
    return LessonLinkList(results: linkList);
  }
}

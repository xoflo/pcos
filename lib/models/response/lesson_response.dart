import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:flutter/material.dart';

class LessonResponse {
  List<Lesson> results;

  LessonResponse({this.results});

  factory LessonResponse.fromList(List<dynamic> json) {
    List<Lesson> lessons = [];
    if (json.length > 0) {
      json.forEach((item) {
        debugPrint("Lesson Response = $item");
        lessons.add(Lesson.fromJson(item));
      });
    }
    return LessonResponse(results: lessons);
  }
}

/*
{
status: OK,
message: ,
info: ,
payload:
  [
    {
      lessonID: 1,
      moduleID: 1,
      title: This is the first lesson, introduction: Hi, welcome to the first lesson, this is the first lesson.,
      mediaUrl: ypdlccbrjnwe3hp812rl.mp4,
      mediaMimeType: mp4,
      body: This is the lesson body, blaa blaa blaa.,
      orderIndex: 0,
      dateCreatedUTC: 2021-03-18T23:00:00
    }
  ]
}
 */

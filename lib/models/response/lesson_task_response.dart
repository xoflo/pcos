import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:flutter/material.dart';

class LessonTaskResponse {
  List<LessonTask> results;

  LessonTaskResponse({this.results});

  factory LessonTaskResponse.fromList(List<dynamic> json) {
    List<LessonTask> lessonTasks = [];
    if (json.length > 0) {
      json.forEach((item) {
        debugPrint("LessonTask Response = $item");
        lessonTasks.add(LessonTask.fromJson(item));
      });
    }
    return LessonTaskResponse(results: lessonTasks);
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
        lessonTaskID: 1, 
        lessonID: 1, 
        metaName: TestTask, 
        title: This is a test, description: A test task, with a description here?, 
        taskType: bool, 
        orderIndex: 0, 
        dateCreatedUTC: 2021-03-24T01:30:00
      }
   ]
}
 */

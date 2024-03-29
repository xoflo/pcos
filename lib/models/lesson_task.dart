import 'package:flutter/foundation.dart';

class LessonTask extends Comparable<LessonTask> {
  final int lessonTaskID;
  final int? lessonID;
  final String? metaName;
  final String? title;
  final String? description;
  final String? taskType;
  final int orderIndex;
  final bool? isComplete;
  final DateTime? dateCreatedUTC;

  LessonTask({
    required this.lessonTaskID,
    this.lessonID,
    this.metaName,
    this.title,
    this.description,
    this.taskType,
    required this.orderIndex,
    this.isComplete,
    this.dateCreatedUTC,
  });

  factory LessonTask.fromJson(Map<String, dynamic> json) {
    if (json['taskType'] == 'quiz') {
      debugPrint("quiz metaName = ${json['metaName']}");
    }
    return LessonTask(
      lessonTaskID: json['lessonTaskID'],
      lessonID: json['lessonID'],
      metaName: json['metaName'],
      title: json['title'],
      description: json['description'],
      taskType: json['taskType'],
      orderIndex: json['orderIndex'],
      isComplete:
          json['isComplete'] == 1 || json['isComplete'] == true ? true : false,
      dateCreatedUTC: DateTime.parse(json['dateCreatedUTC']),
    );
  }

  @override
  int compareTo(LessonTask other) {
    var comparisonResult = orderIndex.compareTo(other.orderIndex);
    if (comparisonResult != 0) {
      return comparisonResult;
    }

    return lessonTaskID.compareTo(other.lessonTaskID);
  }
}

/*
{
  "lessonTaskID": 1,
  "lessonID": 1,
  "metaName": "TestTask",
  "title": "This is a test",
  "description": "A test task, with a description here?",
  "taskType": "bool",
  "orderIndex": 0,
  "isComplete": false,
  "dateCreatedUTC": "2021-03-24T01:30:00"
}
*/

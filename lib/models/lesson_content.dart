import 'package:flutter/foundation.dart';

class LessonContent {
  final int lessonContentID;
  final int lessonID;
  final String title;
  final String mediaUrl;
  final String mediaMimeType;
  final String body;
  final String summary;
  final int orderIndex;
  final DateTime dateCreatedUTC;

  LessonContent({
    this.lessonContentID,
    this.lessonID,
    this.title,
    this.mediaUrl,
    this.mediaMimeType,
    this.body,
    this.summary,
    this.orderIndex,
    this.dateCreatedUTC,
  });

  factory LessonContent.fromJson(Map<String, dynamic> json) {
    final int lessonContentID = json['lessonContentID'];
    if (lessonContentID == 52) {
      debugPrint("LessonContent summary Json=$json");
    }
    return LessonContent(
      lessonContentID: json['lessonContentID'],
      lessonID: json['lessonID'],
      title: json['title'],
      mediaUrl: json['mediaUrl'],
      mediaMimeType: json['mediaMimeType'],
      body: json['body'],
      summary: json['summary'],
      orderIndex: json['orderIndex'],
      dateCreatedUTC: DateTime.parse(json['dateCreatedUTC']),
    );
  }
}

/*
{
  "lessonContentID": 2,
  "lessonID": 1,
  "title": "This is the first lesson.",
  "mediaUrl": "test.mp4",
  "mediaMimeType": "mp4",
  "body": "Hi, First lesson here, welcome.",
  "summary": "This is the summary that appears after the media.",
  "orderIndex": 0,
  "dateCreatedUTC": "2021-03-25T10:37:00"
}
*/

import 'package:flutter/material.dart';

class Lesson {
  final int lessonID;
  final int moduleID;
  final String title;
  final String introduction;
  final String mediaUrl;
  final String mediaMimeType;
  final String body;
  final int orderIndex;
  final DateTime dateCreatedUTC;
  final bool isComplete;
  Lesson({
    this.lessonID,
    this.moduleID,
    this.title,
    this.introduction,
    this.mediaUrl,
    this.mediaMimeType,
    this.body,
    this.orderIndex,
    this.dateCreatedUTC,
    this.isComplete,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    final int moduleID = json['moduleID'];
    debugPrint("JOSN moduleID = $moduleID");
    return Lesson(
      lessonID: json['lessonID'],
      moduleID: json['moduleID'],
      title: json['title'],
      introduction: json['introduction'],
      mediaUrl: json['mediaUrl'],
      mediaMimeType: json['mediaMimeType'],
      body: json['body'],
      orderIndex: json['orderIndex'],
      dateCreatedUTC: DateTime.parse(json['dateCreatedUTC']),
      isComplete: json['isComplete'],
    );
  }
}

/*
{
      lessonID: 1,
      moduleID: 1,
      title: This is the first lesson,
      introduction: Hi, welcome to the first lesson, this is the first lesson.,
      mediaUrl: ypdlccbrjnwe3hp812rl.mp4,
      mediaMimeType: mp4,
      body: This is the lesson body, blaa blaa blaa.,
      orderIndex: 0,
      dateCreatedUTC: 2021-03-18T23:00:00
    }
 */

import 'package:flutter/foundation.dart';

class LessonLink {
  final int lessonLinkID;
  final int lessonID;
  final int objectID;
  final String objectType;
  final int orderIndex;
  final DateTime dateCreatedUTC;

  LessonLink({
    this.lessonLinkID,
    this.lessonID,
    this.objectID,
    this.objectType,
    this.orderIndex,
    this.dateCreatedUTC,
  });

  factory LessonLink.fromJson(Map<String, dynamic> json) {
    if (json['objectType'] == 'quiz') {
      debugPrint("found quiz link = ${json['lessonLinkID']}");
    }
    return LessonLink(
      lessonLinkID: json['lessonLinkID'],
      lessonID: json['lessonID'],
      objectID: json['objectID'],
      objectType: json['objectType'],
      orderIndex: json['orderIndex'],
      dateCreatedUTC: DateTime.parse(json['dateCreatedUTC']),
    );
  }
}

/*
lessonLinkID	:	1
lessonID	:	26
objectID	:	62
objectType	:	wiki
orderIndex	:	0
dateCreatedUTC	:	2021-06-02T00:00:00
 */

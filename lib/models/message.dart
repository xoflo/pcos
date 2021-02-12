import 'package:flutter/material.dart';

class Message {
  final int notificationId;
  final String title;
  final String message;
  final bool isRead;
  final String action;
  final DateTime dateReadUTC;
  final DateTime dateCreatedUTC;

  Message(
      {this.notificationId,
      this.title,
      this.message,
      this.isRead,
      this.action,
      this.dateReadUTC,
      this.dateCreatedUTC});

  factory Message.fromJson(Map<String, dynamic> json) {
    debugPrint("*********************ISREAD JSON= ${json['isRead']}");
    return Message(
      notificationId: json['notificationId'],
      title: "This is the title",
      message: json['message'],
      isRead: json['isRead'] == 1 || json['isRead'] == true ? true : false,
      action: "NONE",
      dateReadUTC: DateTime.parse(json['dateReadUTC']),
      dateCreatedUTC: DateTime.parse(json['dateCreatedUTC']),
    );
  }
}

/*
[
  {
    "notificationId": 2,
    "message": "Hi Andy, here is another message, do we need a title too?",
    "isRead": false,
    "dateReadUTC": "1900-01-01T00:00:00",
    "dateCreatedUTC": "2021-02-11T02:29:00"
  },
  {
    "notificationId": 1,
    "message": "Hi Andy, this is a notification message.",
    "isRead": false,
    "dateReadUTC": "1900-01-01T00:00:00",
    "dateCreatedUTC": "2021-02-11T02:27:59.123"
  }
]
 */

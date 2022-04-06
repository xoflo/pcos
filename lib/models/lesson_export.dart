import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/lesson_content_list.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/models/lesson_task_list.dart';
import 'package:thepcosprotocol_app/models/lesson_link.dart';
import 'package:thepcosprotocol_app/models/lesson_link_list.dart';
import 'package:flutter/foundation.dart';

class LessonExport {
  final Lesson lesson;
  final List<LessonContent> content;
  final List<LessonTask> tasks;
  final List<LessonLink> links;

  LessonExport({
    this.lesson,
    this.content,
    this.tasks,
    this.links,
  });

  factory LessonExport.fromJson(Map<String, dynamic> json) {
    return LessonExport(
      lesson: Lesson.fromJson(json['lesson']),
      content: LessonContentList.fromList(json['content']).results,
      tasks: LessonTaskList.fromList(json['tasks']).results,
      links: LessonLinkList.fromList(json['links']).results,
    );
  }
}

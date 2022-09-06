import 'dart:convert';
import 'dart:io';

import 'package:thepcosprotocol_app/constants/table_names.dart';
import 'package:thepcosprotocol_app/models/cms.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/models/module_export.dart';
import 'package:thepcosprotocol_app/models/quiz_answer.dart';
import 'package:thepcosprotocol_app/models/quiz_question.dart';
import 'package:thepcosprotocol_app/models/quiz.dart';
import 'package:thepcosprotocol_app/models/module.dart';

Future<List<dynamic>> constructListFromFile(String objectName) async {
  var input = await File("test_resources/$objectName.json").readAsString();
  late Map<String, dynamic> tmpMap;
  late List<dynamic> tmpObjectsList;
  if (jsonDecode(input) is Map) {
    tmpMap = jsonDecode(input);
  } else if (jsonDecode(input) is List) {
    tmpObjectsList = jsonDecode(input);
  }

  // TODO: similar/same code in provider_helper
  switch (objectName) {
    case "LessonContent":
      return tmpObjectsList
          .map<LessonContent>((item) => LessonContent.fromJson(item))
          .toList();
    case "Lesson":
      return tmpObjectsList
          .map<Lesson>((item) => Lesson.fromJson(item))
          .toList();
    case "LessonQuiz":
      return tmpObjectsList.map<Quiz>((item) => Quiz.fromJson(item)).toList();
    case "LessonQuizAnswer":
      return tmpObjectsList
          .map<QuizAnswer>((item) => QuizAnswer.fromJson(item))
          .toList();
    case "LessonQuizQuestion":
      return tmpObjectsList
          .map<QuizQuestion>((item) => QuizQuestion.fromJson(item))
          .toList();
    case "Module":
      return tmpObjectsList
          .map<Module>((item) => Module.fromJson(item))
          .toList();
    case "CMSMultiResponse_Wiki":
      return tmpMap["payload"].map<CMS>((item) => CMS.fromJson(item)).toList();
    case "ModuleExportResponse":
      return tmpMap["payload"]
          .map<ModuleExport>((item) => ModuleExport.fromJson(item))
          .toList();
    case "LessonTaskResponse_quizTasks":
      return tmpMap["payload"]
          .map<LessonTask>((item) => LessonTask.fromJson(item))
          .toList();
  }

  return [];
}

Future<List<dynamic>> constructMapFromFile(
    String objectName, String objectType) async {
  var input = await File("test_resources/$objectName.json").readAsString();
  late Map<String, dynamic> tmpMap;
  late List<dynamic> tmpObjectsList;
  if (jsonDecode(input) is Map) {
    tmpMap = jsonDecode(input);
  } else if (jsonDecode(input) is List) {
    tmpObjectsList = jsonDecode(input);
  }

  switch (objectType) {
    case TABLE_WIKI:
      List<Map<String, Object>> mapList = [];
      for (var item in tmpObjectsList) {
        Map<String, Object> map = Map<String, Object>();
        map['id'] = item['id'];
        map['reference'] = item['reference'];
        map['question'] = item['question'];
        map['answer'] = item['answer'];
        map['tags'] = item['tags'];
        if (item['lessonID'] != null)
          map['lessonID'] = item['lessonID'];
        else
          item['lessonID'] = null;
        if (item['moduleID'] != null)
          map['moduleID'] = item['moduleID'];
        else
          item['moduleID'] = null;
        map['isFavorite'] = item['isFavorite'];

        mapList.add(map);
      }
      return mapList;
    case TABLE_LESSON_LINK:
    case TABLE_QUIZ:
    case TABLE_QUIZ_QUESTION:
    case TABLE_QUIZ_ANSWER:
    case TABLE_RECIPE:
      List<Map<String, Object>> mapList = [];
      for (var item in tmpObjectsList) {
        Map<String, Object> map = Map<String, Object>();
        for (var moduleItem in item.entries) {
          map[moduleItem.key] = moduleItem.value;
        }
        mapList.add(map);
      }
      return mapList;
    case "Module":
      List<Map<String, Object>> modulesList = [];
      List<dynamic> payload = tmpMap['payload'];
      for (var item in payload) {
        var payloadMap = item["module"];
        print(payloadMap);
        Map<String, Object> moduleItemMap = {};
        for (var moduleItem in payloadMap.entries) {
          moduleItemMap[moduleItem.key] = moduleItem.value;
        }

        modulesList.add(moduleItemMap);
      }
      return modulesList;
    case "LessonContent":
      List<Map<String, Object>> lessonContentsList = [];
      List<dynamic> payload = tmpMap['payload'];

      Map<String, Object> lessonContentItemMap = {};
      for (var item in payload) {
        var lessons = item["lessons"];

        for (var lessonItem in lessons) {
          List<dynamic> lessonContentMap = lessonItem["content"];

          for (var lessonContentItem in lessonContentMap) {
            lessonContentItemMap = {};
            for (var lessonContentItemValue in lessonContentItem.entries) {
              lessonContentItemMap[lessonContentItemValue.key] =
                  lessonContentItemValue.value;
            }
            lessonContentsList.add(lessonContentItemMap);
          }
        }
      }
      
      return lessonContentsList;
    case TABLE_LESSON:
      List<Map<String, Object>> mapList = [];
      for (var item in tmpObjectsList) {
        Map<String, Object> map = Map<String, Object>();
        map['lessonID'] = item['lessonID'];
        map['moduleID'] = item['moduleID'];
        map['title'] = item['title'];
        map['introduction'] = item['introduction'];
        map['hoursToNextLesson'] = item['hoursToNextLesson'];
        map['hoursUntilAvailable'] = item['hoursUntilAvailable'];
        if (item['minsToComplete'] != null)
          map['minsToComplete'] = item['minsToComplete'];
        else
          item['minsToComplete'] = null;
        if (item['imageUrl'] != null)
          map['imageUrl'] = item['imageUrl'];
        else
          item['imageUrl'] = null;
        map['orderIndex'] = item['orderIndex'];
        map['isFavorite'] = item['isFavorite'];
        map['isComplete'] = item['isComplete'];
        map['isToolkit'] = item['isToolkit'];
        map['dateCreatedUTC'] = item['dateCreatedUTC'];

        mapList.add(map);
      }
      return mapList;
  }

  return [];
}

import 'package:thepcosprotocol_app/models/module_export.dart';

class ModuleExportResponse {
  List<ModuleExport>? results;

  ModuleExportResponse({this.results});

  factory ModuleExportResponse.fromList(List<dynamic> json) {
    List<ModuleExport> modules = [];
    if (json.length > 0) {
      json.forEach((item) {
        modules.add(ModuleExport.fromJson(item));
      });
    }
    return ModuleExportResponse(results: modules);
  }
}

/*
{
  "status": "OK",
  "message": "",
  "info": "",
  "payload": [
    {
      "module": {
        "moduleID": 1,
        "title": "This is a test module",
        "isComplete": true,
        "orderIndex": 0,
        "dateCreatedUTC": "2021-03-18T22:25:00"
      },
      "lessons": [
        {
          "lesson": {
            "lessonID": 1,
            "moduleID": 1,
            "title": "This is the first lesson",
            "introduction": "Hi, welcome to the first lesson, this is the first lesson.",
            "orderIndex": 0,
            "isFavorite": false,
            "isComplete": true,
            "dateCreatedUTC": "2021-03-18T23:00:00"
          },
          "content": [
            {
              "lessonContentID": 2,
              "lessonID": 1,
              "title": "This is the first lesson.",
              "mediaUrl": "test.mp4",
              "mediaMimeType": "mp4",
              "body": "Hi, First lesson here, welcome.",
              "orderIndex": 0,
              "dateCreatedUTC": "2021-03-25T10:37:00"
            }
          ],
          "tasks": [
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
          ]
        },
        {
          "lesson": {
            "lessonID": 2,
            "moduleID": 1,
            "title": "Second lesson, first module",
            "introduction": "Hi, this is another lesson",
            "orderIndex": 1,
            "isFavorite": false,
            "isComplete": true,
            "dateCreatedUTC": "2021-03-24T04:27:00"
          },
          "content": [
            {
              "lessonContentID": 3,
              "lessonID": 2,
              "title": "This is the second lesson you know",
              "mediaUrl": "test2.mp4",
              "mediaMimeType": "mp4",
              "body": "Hi, Second lesson, first module here",
              "orderIndex": 1,
              "dateCreatedUTC": "2021-03-25T10:38:00"
            }
          ],
          "tasks": []
        }
      ]
    },
    {
      "module": {
        "moduleID": 2,
        "title": "Second Module",
        "isComplete": true,
        "orderIndex": 1,
        "dateCreatedUTC": "2021-03-24T04:25:00"
      },
      "lessons": [
        {
          "lesson": {
            "lessonID": 3,
            "moduleID": 2,
            "title": "The second module first lesson",
            "introduction": "Hi again",
            "orderIndex": 0,
            "isFavorite": false,
            "isComplete": true,
            "dateCreatedUTC": "2021-03-24T05:19:51.2"
          },
          "content": [
            {
              "lessonContentID": 4,
              "lessonID": 3,
              "title": "First lesson module 2",
              "mediaUrl": "test3.mp4",
              "mediaMimeType": "mp4",
              "body": "The third lesson, but first in module 2",
              "orderIndex": 0,
              "dateCreatedUTC": "2021-03-25T10:37:00"
            }
          ],
          "tasks": [
            {
              "lessonTaskID": 2,
              "lessonID": 3,
              "metaName": "Test",
              "title": "How are you today?",
              "description": "Tell us how you feel today",
              "taskType": "bool",
              "orderIndex": 0,
              "isComplete": false,
              "dateCreatedUTC": "2021-03-24T22:42:04.13"
            }
          ]
        }
      ]
    }
  ]
}
*/

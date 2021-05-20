import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/cms_text.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/lesson_export.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/models/module_export.dart';
import 'package:thepcosprotocol_app/models/modules_and_lessons.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/models/cms.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

// This provider is used for Knowledge Base, FAQs and Course Questions
class ProviderHelper {
  Future<List<Question>> fetchAndSaveQuestions(
    final dbProvider,
    final String tableName,
    final String assetType,
  ) async {
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      if (await _shouldGetDataFromAPI(dbProvider, tableName)) {
        final cmsItems = await WebServices().getCMSByType(assetType);
        List<Question> questions = _convertCMSToQuestions(cmsItems, assetType);
        //delete all old records before adding new ones
        await dbProvider.deleteAll(tableName);
        //add items to database
        questions.forEach((Question question) async {
          await dbProvider.insert(tableName, {
            'id': question.id,
            'reference': question.reference,
            'question': question.question,
            'answer': question.answer,
            'tags': question.tags,
            'isFavorite': question.isFavorite ? 1 : 0,
          });
        });

        //save when we got the data
        saveTimestamp(tableName);
      }

      // get items from database
      return await getAllData(dbProvider, tableName);
    }
    return [];
  }

  Future<List<Recipe>> fetchAndSaveRecipes(final dbProvider) async {
    final String tableName = "Recipe";
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      if (await _shouldGetDataFromAPI(dbProvider, tableName)) {
        final recipes = await WebServices().getAllRecipes();
        //delete all old records before adding new ones
        await dbProvider.deleteAll(tableName);
        //add items to database
        recipes.forEach((Recipe recipe) async {
          await dbProvider.insert(tableName, {
            'recipeId': recipe.recipeId,
            'title': recipe.title,
            'description': recipe.description,
            'thumbnail': recipe.thumbnail,
            'ingredients': recipe.ingredients,
            'method': recipe.method,
            'tips': recipe.tips,
            'tags': recipe.tags,
            'difficulty': recipe.difficulty,
            'servings': recipe.servings,
            'duration': recipe.duration,
            'isFavorite': recipe.isFavorite ? 1 : 0,
          });
        });

        //save when we got the data
        saveTimestamp(tableName);
      }

      // get items from database
      return await getAllData(dbProvider, tableName);
    }
    return [];
  }

  Future<ModulesAndLessons> fetchAndSaveModuleExport(
    final dbProvider,
    final bool forceRefresh,
    final DateTime nextLessonAvailableDate,
  ) async {
    final String moduleTableName = "Module";
    final String lessonTableName = "Lesson";
    final String lessonContentTableName = "LessonContent";
    final String lessonTaskTableName = "LessonTask";
    final bool isNextLessonAvailable =
        nextLessonAvailableDate.isBefore(DateTime.now());

    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      if (forceRefresh ||
          await _shouldGetDataFromAPI(dbProvider, moduleTableName)) {
        final List<ModuleExport> moduleExport =
            await WebServices().getModulesExport();
        //delete all old records before adding new ones
        await dbProvider.deleteAll(moduleTableName);
        await dbProvider.deleteAll(lessonTableName);
        await dbProvider.deleteAll(lessonContentTableName);
        await dbProvider.deleteAll(lessonTaskTableName);

        //add modules to database
        await _addModulesAndLessonsToDatabase(
            dbProvider,
            moduleExport,
            moduleTableName,
            lessonTableName,
            lessonContentTableName,
            lessonTaskTableName);

        //save when we got the data
        await saveTimestamp(moduleTableName);
      }

      // get items from database
      final List<Module> modulesFromDB = await getAllData(
        dbProvider,
        moduleTableName,
        orderByColumn: "orderIndex",
      );

      final List<Lesson> lessonsFromDB = await getAllData(
        dbProvider,
        lessonTableName,
        orderByColumn: "moduleID, orderIndex",
      );
      final List<LessonContent> lessonContentFromDB = await getAllData(
        dbProvider,
        lessonContentTableName,
        orderByColumn: "lessonID, orderIndex",
      );
      final List<LessonTask> lessonTasksFromDB = await getAllData(
        dbProvider,
        lessonTaskTableName,
        orderByColumn: "lessonID, orderIndex",
        incompleteOnly: true,
      );

      //only return complete lessons and the first incomplete lesson, also check whether first incomplete lesson should be visible yet
      List<Lesson> lessonsToReturn = [];
      List<int> lessonIDs = [];
      List<int> moduleIDs = [];
      bool foundIncompleteLesson = false;
      for (Lesson lesson in lessonsFromDB) {
        if (foundIncompleteLesson) break;
        if (lesson.isComplete ||
            (!lesson.isComplete && isNextLessonAvailable)) {
          lessonsToReturn.add(lesson);
          lessonIDs.add(lesson.lessonID);
          if (!moduleIDs.contains(lesson.moduleID))
            moduleIDs.add(lesson.moduleID);
        }
        if (!lesson.isComplete) foundIncompleteLesson = true;
      }

      //only return complete modules and the first incomplete module
      List<Module> modulesToReturn = [];
      for (Module module in modulesFromDB) {
        if (moduleIDs.contains(module.moduleID)) modulesToReturn.add(module);
      }

      //only return the lessonContent for lessons in lessonsToReturn
      List<LessonContent> lessonContentToReturn = [];
      for (LessonContent lessonContent in lessonContentFromDB) {
        if (lessonIDs.contains(lessonContent.lessonID)) {
          lessonContentToReturn.add(lessonContent);
        }
      }

      //only return the lessonTasks for lessons in lessonsToReturn
      List<LessonTask> lessonTasksToReturn = [];
      for (LessonTask lessonTask in lessonTasksFromDB) {
        if (lessonIDs.contains(lessonTask.lessonID) && !lessonTask.isComplete)
          lessonTasksToReturn.add(lessonTask);
      }

      final ModulesAndLessons modulesAndLessons = ModulesAndLessons(
        modules: modulesToReturn,
        lessons: lessonsToReturn,
        lessonContent: lessonContentToReturn,
        lessonTasks: lessonTasksToReturn,
      );
      return modulesAndLessons;
    }
    return ModulesAndLessons();
  }

  Future<void> _addModulesAndLessonsToDatabase(
    final dbProvider,
    final List<ModuleExport> moduleExport,
    final String moduleTableName,
    final String lessonTableName,
    final String lessonContentTableName,
    final String lessonTaskTableName,
  ) async {
    moduleExport.forEach((ModuleExport moduleExport) async {
      Module module = moduleExport.module;
      await dbProvider.insert(moduleTableName, {
        'moduleID': module.moduleID,
        'title': module.title,
        'isComplete': module.isComplete ? 1 : 0,
        'orderIndex': module.orderIndex,
        'dateCreatedUTC': module.dateCreatedUTC.toIso8601String(),
      });
    });

    //add lessons, lesson content and lesson tasks to database
    moduleExport.forEach((ModuleExport moduleExport) async {
      List<LessonExport> lessons = moduleExport.lessons;
      lessons.forEach((LessonExport lessonExport) async {
        Lesson lesson = lessonExport.lesson;
        List<LessonContent> lessonContent = lessonExport.content;
        List<LessonTask> lessonTasks = lessonExport.tasks;
        //add lesson to database
        await dbProvider.insert(lessonTableName, {
          'lessonID': lesson.lessonID,
          'moduleID': lesson.moduleID,
          'title': lesson.title,
          'introduction': lesson.introduction,
          'orderIndex': lesson.orderIndex,
          'isFavorite': lesson.isFavorite ? 1 : 0,
          'isComplete': lesson.isComplete ? 1 : 0,
          'dateCreatedUTC': lesson.dateCreatedUTC.toIso8601String(),
        });
        //add lesson content to database
        await _addLessonContentToDatabase(
            dbProvider, lessonContentTableName, lessonContent);
        await _addLessonTasksToDatabase(
            dbProvider, lessonTaskTableName, lessonTasks);
      });
    });
  }

  Future<void> _addLessonContentToDatabase(final dbProvider,
      final String tableName, List<LessonContent> lessonContents) async {
    lessonContents.forEach((LessonContent lessonContent) async {
      await dbProvider.insert(tableName, {
        'lessonContentID': lessonContent.lessonContentID,
        'lessonID': lessonContent.lessonID,
        'title': lessonContent.title,
        'mediaUrl': lessonContent.mediaUrl,
        'mediaMimeType': lessonContent.mediaMimeType,
        'body': lessonContent.body,
        'orderIndex': lessonContent.orderIndex,
        'dateCreatedUTC': lessonContent.dateCreatedUTC.toIso8601String(),
      });
    });
  }

  Future<void> _addLessonTasksToDatabase(final dbProvider,
      final String tableName, List<LessonTask> lessonTasks) async {
    lessonTasks.forEach((LessonTask lessonTask) async {
      await dbProvider.insert(tableName, {
        'lessonTaskID': lessonTask.lessonTaskID,
        'lessonID': lessonTask.lessonID,
        'metaName': lessonTask.metaName,
        'title': lessonTask.title,
        'description': lessonTask.description,
        'taskType': lessonTask.taskType,
        'orderIndex': lessonTask.orderIndex,
        'isComplete': lessonTask.isComplete ? 1 : 0,
        'dateCreatedUTC': lessonTask.dateCreatedUTC.toIso8601String(),
      });
    });
  }

  Future<List<Message>> fetchAndSaveMessages(
      final dbProvider, final bool refreshFromAPI) async {
    final String tableName = "Message";
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      if (refreshFromAPI ||
          await _shouldGetDataFromAPI(dbProvider, tableName)) {
        final messages = await WebServices().getAllUserNotifications();
        //delete all old records before adding new ones
        await dbProvider.deleteAll(tableName);
        //add items to database
        messages.forEach((Message message) async {
          await dbProvider.insert(tableName, {
            'notificationId': message.notificationId,
            'title': message.title,
            'message': message.message,
            'isRead': message.isRead ? 1 : 0,
            'action': message.action,
            'dateReadUTC': message.dateReadUTC.toIso8601String(),
            'dateCreatedUTC': message.dateCreatedUTC.toIso8601String(),
          });
        });

        //save when we got the data
        saveTimestamp(tableName);
      }

      // get items from database
      return await getAllData(dbProvider, tableName);
    }
    return [];
  }

  Future<List<String>> fetchAndSaveCMSText(
      final dbProvider, final String tableName) async {
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      if (await _shouldGetDataFromAPI(dbProvider, tableName)) {
        final String gettingStarted =
            await WebServices().getCmsAssetByReference("GettingStarted");
        final String privacyStatement =
            await WebServices().getCmsAssetByReference("Privacy");
        final String termsAndConditions =
            await WebServices().getCmsAssetByReference("Terms");
        List<String> cmsItems = [
          gettingStarted,
          privacyStatement,
          termsAndConditions
        ];

        //delete all old records before adding new ones
        await dbProvider.deleteAll(tableName);
        //add items to database
        cmsItems.forEach((String cmsItem) async {
          await dbProvider.insert(tableName, {
            'cmsText': cmsItem,
          });
        });

        //save when we got the data
        saveTimestamp(tableName);
      }

      // get items from database
      return await getAllData(dbProvider, tableName);
    }
    return [];
  }

  Future<List<dynamic>> filterAndSearch(final dbProvider,
      final String tableName, final String searchText, final String tag) async {
    if (dbProvider.db != null) {
      if (searchText.length > 0 || (tag.length > 0 && tag != "All")) {
        String searchQuery = "";
        if (searchText.length > 0) {
          if (tableName == "Recipe") {
            searchQuery =
                " WHERE (title LIKE '%$searchText%' OR description LIKE '%$searchText%')";
          } else if (tableName == "Lesson") {
            searchQuery =
                " WHERE (title LIKE '%$searchText%' OR REPLACE(title,'''','') LIKE '%$searchText%' OR introduction LIKE '%$searchText%' OR REPLACE(introduction,'''','') LIKE '%$searchText%')";
          } else {
            searchQuery = " WHERE question LIKE '%$searchText%'";
          }
        }
        if (tag.length > 0 && tag != 'All') {
          searchQuery += searchText.length > 0 ? " AND" : " WHERE";
          searchQuery += " tags LIKE '%$tag%'";
        }
        debugPrint("*********searchQuery=$searchQuery");
        final dataList = await dbProvider.getDataQuery(tableName, searchQuery);
        return mapDataToList(dataList, tableName);
      } else {
        return getAllData(dbProvider, tableName);
      }
    }
    return [];
  }

  Future<void> markNotificationAsRead(
      final dbProvider, final int notificationId) async {
    final String tableName = "Message";
    //update on server
    WebServices().markNotificationAsRead(notificationId);
    if (dbProvider.db != null) {
      //update in sqlite
      await dbProvider.updateQuery(
        table: tableName,
        setFields: "isRead = 1",
        whereClause: "notificationId = $notificationId",
        limitRowCount: 1,
      );
    }
  }

  Future<void> markNotificationAsDeleted(
      final dbProvider, final int notificationId) async {
    final String tableName = "Message";
    //update on server
    WebServices().markNotificationAsDeleted(notificationId);
    if (dbProvider.db != null) {
      //update in sqlite
      await dbProvider.deleteQuery(
        table: tableName,
        whereClause: "notificationId = $notificationId",
        limitRowCount: 1,
      );
    }
  }

  Future<bool> markTaskAsCompleted(
      final dbProvider, final int lessonTaskID, final String value) async {
    final String tableName = "LessonTask";
    //update on server
    final bool setComplete =
        await WebServices().setTaskComplete(lessonTaskID, value);
    //refresh the data from the API
    if (setComplete && dbProvider.db != null) {
      //set isComplete in local database and delete from displayLessonTasks
      await dbProvider.deleteQuery(
        table: tableName,
        whereClause: "lessonTaskID = $lessonTaskID",
        limitRowCount: 1,
      );
    }
    return setComplete;
  }

  Future<void> addToFavourites(
    final bool isAdd,
    final dbProvider,
    final FavouriteType favouriteType,
    final dynamic item,
  ) async {
    int updateId = 0;
    String tableName = "";
    String assetType = "";
    String updateColumn = "";

    switch (favouriteType) {
      case FavouriteType.Recipe:
        updateId = item.recipeId;
        tableName = "Recipe";
        assetType = "Recipe";
        updateColumn = "recipeId";
        break;
      case FavouriteType.KnowledgeBase:
        updateId = item.id;
        tableName = "KnowledgeBase";
        assetType = "CMS";
        updateColumn = "id";
        break;
      case FavouriteType.Lesson:
        updateId = item.lessonID;
        tableName = "Lesson";
        assetType = "Lesson";
        updateColumn = "lessonID";
        break;
      case FavouriteType.None:
        break;
    }
    //update in API
    if (isAdd) {
      WebServices().addToFavourites(assetType, updateId);
    } else {
      WebServices().removeFromFavourites(assetType, updateId);
    }
    //update in sqlite
    if (dbProvider.db != null) {
      final int isFavorite = isAdd ? 1 : 0;
      await dbProvider.updateQuery(
        table: tableName,
        setFields: "isFavorite = $isFavorite",
        whereClause: "$updateColumn = $updateId",
        limitRowCount: 1,
      );
    }
  }

  Future<bool> _shouldGetDataFromAPI(
      final dbProvider, final String tableName) async {
    final int rowCount = await dbProvider.getTableRowCount(tableName);

    //no data in table so get data from API
    if (rowCount == 0) return true;

    final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    final int savedTimestamp = await getTimestamp(tableName);
    final int cacheSeconds = tableName == "Message" ? 300 : 900;

    //we have data, so check if the data is older than 15 minutes (900 seconds) or 5 mins for messages
    if (savedTimestamp != null &&
        currentTimestamp - savedTimestamp > (cacheSeconds * 1000)) {
      return true;
    }

    //we have data and it is under 15 mins old (or 5 mins for Messages), so use the database version
    return false;
  }

  Future<List<dynamic>> getAllData(final dbProvider, final String tableName,
      {final String orderByColumn = "",
      final bool incompleteOnly = false}) async {
    final dataList =
        await dbProvider.getData(tableName, orderByColumn, incompleteOnly);
    return mapDataToList(dataList, tableName);
  }

  List<dynamic> mapDataToList(final dataList, final String tableName) {
    if (tableName == "Recipe") {
      return dataList.map<Recipe>((item) => Recipe.fromJson(item)).toList();
    } else if (tableName == "Module") {
      return dataList.map<Module>((item) => Module.fromJson(item)).toList();
    } else if (tableName == "Lesson") {
      return dataList.map<Lesson>((item) => Lesson.fromJson(item)).toList();
    } else if (tableName == "LessonContent") {
      return dataList
          .map<LessonContent>((item) => LessonContent.fromJson(item))
          .toList();
    } else if (tableName == "LessonTask") {
      return dataList
          .map<LessonTask>((item) => LessonTask.fromJson(item))
          .toList();
    } else if (tableName == "Message") {
      return dataList.map<Message>((item) => Message.fromJson(item)).toList();
    } else if (tableName == "CMSText") {
      List<CMSText> cmsItems =
          dataList.map<CMSText>((item) => CMSText.fromJson(item)).toList();
      List<String> cmsStrings = [];
      for (CMSText cmsText in cmsItems) {
        cmsStrings.add(cmsText.cmsText);
      }
      return cmsStrings;
    }
    //if none of the above it must be a question
    return dataList
        .map<Question>((item) => Question(
              id: item['id'],
              reference: item['reference'],
              question: item['question'],
              answer: item['answer'],
              tags: item['tags'],
              isFavorite: item['isFavorite'] == 1 ? true : false,
            ))
        .toList();
  }

  List<Question> _convertCMSToQuestions(
      final List<CMS> cmsItems, final String cmsType) {
    List<Question> questionList = [];

    if (cmsItems.length.isOdd) {
      //an odd number of items, so remove the last one as they should be in pairs
      cmsItems.removeAt(cmsItems.length);
    }

    for (var i = 0; i < cmsItems.length - 1; i = i + 2) {
      final question = cmsItems[i];
      final answer = cmsItems[i + 1];

      Question newQuestion = Question(
        id: question.cmsId,
        reference: question.reference,
        question: question.body,
        answer: answer.body,
        tags: question.tags,
        isFavorite: question.isFavorite,
      );

      questionList.add(newQuestion);
    }
    return questionList;
  }

  Future<bool> saveTimestamp(final String tableName) async {
    try {
      final String key =
          "${tableName}_${SharedPreferencesKeys.DB_SAVED_TIMESTAMP}";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(key, DateTime.now().millisecondsSinceEpoch);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<int> getTimestamp(final String tableName) async {
    try {
      final String key =
          "${tableName}_${SharedPreferencesKeys.DB_SAVED_TIMESTAMP}";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt(key);
    } catch (ex) {
      return 0;
    }
  }
}

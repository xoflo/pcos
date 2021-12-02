import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/all_favourites.dart';
import 'package:thepcosprotocol_app/models/cms_text.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/lesson_export.dart';
import 'package:thepcosprotocol_app/models/lesson_link.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
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
import 'package:thepcosprotocol_app/constants/table_names.dart';

// This provider is used for App Help
class ProviderHelper {
  Future<List<Question>> fetchAndSaveQuestions(
    final dbProvider,
    final String tableName,
    final String assetType,
  ) async {
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
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
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      if (await _shouldGetDataFromAPI(dbProvider, TABLE_RECIPE)) {
        final recipes = await WebServices().getAllRecipes();
        //delete all old records before adding new ones
        await dbProvider.deleteAll(TABLE_RECIPE);
        //add items to database
        recipes.forEach((Recipe recipe) async {
          await dbProvider.insert(TABLE_RECIPE, {
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
        saveTimestamp(TABLE_RECIPE);
      }
      // get items from database
      return await getAllData(dbProvider, TABLE_RECIPE);
    }
    return [];
  }

  Future<ModulesAndLessons> fetchAndSaveModuleExport(
    final dbProvider,
    final bool forceRefresh,
    final DateTime nextLessonAvailableDate,
  ) async {
    final bool isNextLessonAvailable =
        nextLessonAvailableDate.isBefore(DateTime.now());

    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      if (forceRefresh ||
          await _shouldGetDataFromAPI(dbProvider, TABLE_MODULE)) {
        //first get the Wiki items and store in local DB
        await ProviderHelper()
            .fetchAndSaveQuestions(dbProvider, TABLE_WIKI, TABLE_WIKI);
        //now get the modules, lessons etc
        final List<ModuleExport> moduleExport =
            await WebServices().getModulesExport();
        //delete all old records before adding new ones
        await dbProvider.deleteAll(TABLE_MODULE);
        await dbProvider.deleteAll(TABLE_LESSON);
        await dbProvider.deleteAll(TABLE_LESSON_CONTENT);
        await dbProvider.deleteAll(TABLE_LESSON_TASK);
        await dbProvider.deleteAll(TABLE_LESSON_LINK);

        //add modules to database
        await _addModulesAndLessonsToDatabase(dbProvider, moduleExport);

        //save when we got the data
        await saveTimestamp(TABLE_MODULE);
      }

      // get items from database
      final List<Module> modulesFromDB = await getAllData(
        dbProvider,
        TABLE_MODULE,
        orderByColumn: "orderIndex",
      );

      final List<Lesson> lessonsFromDB = await getAllData(
        dbProvider,
        TABLE_LESSON,
        orderByColumn: "moduleID, orderIndex",
      );
      final List<LessonContent> lessonContentFromDB = await getAllData(
        dbProvider,
        TABLE_LESSON_CONTENT,
        orderByColumn: "lessonID, orderIndex",
      );
      final List<LessonTask> lessonTasksFromDB = await getAllData(
        dbProvider,
        TABLE_LESSON_TASK,
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

      //get the lesson wikis by joining the wiki and lesson table and only return the lessonaWikis for lessons in lessonsToReturn
      final wikiList = await dbProvider.getDataQueryWithJoin(
        "$TABLE_WIKI.*, $TABLE_LESSON_LINK.LessonID, $TABLE_LESSON_LINK.ModuleID",
        "$TABLE_WIKI INNER JOIN $TABLE_LESSON_LINK ON $TABLE_WIKI.id = $TABLE_LESSON_LINK.objectID",
        "WHERE objectType = 'wiki'",
      );

      final List<LessonWiki> lessonWikisToReturn =
          mapDataToList(wikiList, "LessonWiki");

      //get the lesson wikis by joining the wiki and lesson table and only return the lessonWikis for lessons in lessonsToReturn
      final recipeList = await dbProvider.getDataQueryWithJoin(
        "$TABLE_RECIPE.*, $TABLE_LESSON_LINK.LessonID",
        "$TABLE_RECIPE INNER JOIN $TABLE_LESSON_LINK ON $TABLE_RECIPE.recipeId = $TABLE_LESSON_LINK.objectID",
        "WHERE objectType = 'recipe'",
      );
      final List<LessonRecipe> lessonRecipesToReturn =
          mapDataToList(recipeList, "LessonRecipe");

      final ModulesAndLessons modulesAndLessons = ModulesAndLessons(
        modules: modulesToReturn,
        lessons: lessonsToReturn,
        lessonContent: lessonContentToReturn,
        lessonTasks: lessonTasksToReturn,
        lessonWikis: lessonWikisToReturn,
        lessonRecipes: lessonRecipesToReturn,
      );
      return modulesAndLessons;
    }
    return ModulesAndLessons();
  }

  Future<void> _addModulesAndLessonsToDatabase(
      final dbProvider, final List<ModuleExport> moduleExport) async {
    moduleExport.forEach((ModuleExport moduleExport) async {
      Module module = moduleExport.module;
      await dbProvider.insert(TABLE_MODULE, {
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
        List<LessonLink> lessonLinks = lessonExport.links;
        //add lesson to database
        await dbProvider.insert(TABLE_LESSON, {
          'lessonID': lesson.lessonID,
          'moduleID': lesson.moduleID,
          'title': lesson.title,
          'introduction': lesson.introduction,
          'orderIndex': lesson.orderIndex,
          'isFavorite': lesson.isFavorite ? 1 : 0,
          'isComplete': lesson.isComplete ? 1 : 0,
          'isToolkit': lesson.isToolkit ? 1 : 0,
          'dateCreatedUTC': lesson.dateCreatedUTC.toIso8601String(),
        });
        //add lesson content to database
        await _addLessonContentToDatabase(dbProvider, lessonContent);
        await _addLessonTasksToDatabase(dbProvider, lessonTasks);
        await _addLessonLinkToDatabase(
            dbProvider, lessonLinks, lesson.moduleID);
      });
    });
  }

  Future<void> _addLessonContentToDatabase(
      final dbProvider, List<LessonContent> lessonContents) async {
    lessonContents.forEach((LessonContent lessonContent) async {
      await dbProvider.insert(TABLE_LESSON_CONTENT, {
        'lessonContentID': lessonContent.lessonContentID,
        'lessonID': lessonContent.lessonID,
        'title': lessonContent.title,
        'mediaUrl': lessonContent.mediaUrl,
        'mediaMimeType': lessonContent.mediaMimeType,
        'body': lessonContent.body,
        'summary': lessonContent.summary,
        'orderIndex': lessonContent.orderIndex,
        'dateCreatedUTC': lessonContent.dateCreatedUTC.toIso8601String(),
      });
    });
  }

  Future<void> _addLessonTasksToDatabase(
      final dbProvider, List<LessonTask> lessonTasks) async {
    lessonTasks.forEach((LessonTask lessonTask) async {
      await dbProvider.insert(TABLE_LESSON_TASK, {
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

  Future<void> _addLessonLinkToDatabase(final dbProvider,
      final List<LessonLink> lessonLinks, final int moduleID) async {
    lessonLinks.forEach((LessonLink lessonLink) async {
      await dbProvider.insert(TABLE_LESSON_LINK, {
        'lessonLinkID': lessonLink.lessonLinkID,
        'lessonID': lessonLink.lessonID,
        'moduleID': moduleID,
        'objectID': lessonLink.objectID,
        'objectType': lessonLink.objectType,
        'orderIndex': lessonLink.orderIndex,
        'dateCreatedUTC': lessonLink.dateCreatedUTC.toIso8601String(),
      });
    });
  }

  Future<List<Message>> fetchAndSaveMessages(
      final dbProvider, final bool refreshFromAPI) async {
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      if (refreshFromAPI ||
          await _shouldGetDataFromAPI(dbProvider, TABLE_MESSAGE)) {
        final messages = await WebServices().getAllUserNotifications();
        //delete all old records before adding new ones
        await dbProvider.deleteAll(TABLE_MESSAGE);
        //add items to database
        messages.forEach((Message message) async {
          await dbProvider.insert(TABLE_MESSAGE, {
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
        saveTimestamp(TABLE_MESSAGE);
      }

      // get items from database
      return await getAllData(dbProvider, TABLE_MESSAGE);
    }
    return [];
  }

  Future<List<String>> fetchAndSaveCMSText(final dbProvider) async {
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      if (await _shouldGetDataFromAPI(dbProvider, TABLE_CMS_TEXT)) {
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
        await dbProvider.deleteAll(TABLE_CMS_TEXT);
        //add items to database
        cmsItems.forEach((String cmsItem) async {
          await dbProvider.insert(TABLE_CMS_TEXT, {
            'cmsText': cmsItem,
          });
        });

        //save when we got the data
        saveTimestamp(TABLE_CMS_TEXT);
      }

      // get items from database
      return await getAllData(dbProvider, TABLE_CMS_TEXT);
    }
    return [];
  }

  Future<AllFavourites> getFavourites(final dbProvider) async {
    List<Lesson> toolkits =
        await getAllData(dbProvider, TABLE_LESSON, toolkitsOnly: true);
    List<Lesson> lessons =
        await getAllData(dbProvider, TABLE_LESSON, favouritesOnly: true);
    List<LessonWiki> wikis =
        await getAllData(dbProvider, TABLE_WIKI, favouritesOnly: true);
    List<Recipe> recipes =
        await getAllData(dbProvider, TABLE_RECIPE, favouritesOnly: true);

    return AllFavourites(
      toolkits: toolkits,
      lessons: lessons,
      lessonWikis: wikis,
      recipes: recipes,
    );
  }

  Future<List<dynamic>> filterAndSearch(
      final dbProvider,
      final String tableName,
      final String searchText,
      final String tag,
      final List<String> secondaryTags) async {
    if (dbProvider.db != null) {
      if (searchText.length > 0 || (tag.length > 0 && tag != "All")) {
        String searchQuery = "";
        if (searchText.length > 0) {
          if (tableName == TABLE_RECIPE) {
            searchQuery =
                " WHERE (title LIKE '%$searchText%' OR description LIKE '%$searchText%')";
          } else if (tableName == TABLE_LESSON) {
            searchQuery =
                " WHERE (title LIKE '%$searchText%' OR REPLACE(title,'''','') LIKE '%$searchText%' OR introduction LIKE '%$searchText%' OR REPLACE(introduction,'''','') LIKE '%$searchText%')";
          } else {
            searchQuery = " WHERE question LIKE '%$searchText%'";
          }
        }
        if (tag.length > 0 && tag != 'All') {
          searchQuery += searchText.length > 0 ? " AND" : " WHERE";
          searchQuery += " tags LIKE '%$tag%'";
          //add the secondary tags as OR's if any selected
          if (tableName == TABLE_RECIPE && secondaryTags.length > 0) {
            bool firstItem = true;
            searchQuery += " AND (";
            secondaryTags.forEach((item) {
              if (firstItem) {
                searchQuery += "tags LIKE '%$item%'";
                firstItem = false;
              } else {
                searchQuery += " OR tags LIKE '%$item%'";
              }
            });
            searchQuery += ")";
          }
        }
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
    //update on server
    WebServices().markNotificationAsRead(notificationId);
    if (dbProvider.db != null) {
      //update in sqlite
      await dbProvider.updateQuery(
        table: TABLE_MESSAGE,
        setFields: "isRead = 1",
        whereClause: "notificationId = $notificationId",
        limitRowCount: 1,
      );
    }
  }

  Future<void> markNotificationAsDeleted(
      final dbProvider, final int notificationId) async {
    //update on server
    WebServices().markNotificationAsDeleted(notificationId);
    if (dbProvider.db != null) {
      //update in sqlite
      await dbProvider.deleteQuery(
        table: TABLE_MESSAGE,
        whereClause: "notificationId = $notificationId",
        limitRowCount: 1,
      );
    }
  }

  Future<bool> markTaskAsCompleted(
      final dbProvider, final int lessonTaskID, final String value) async {
    //update on server
    final bool setComplete =
        await WebServices().setTaskComplete(lessonTaskID, value);
    //refresh the data from the API
    if (setComplete && dbProvider.db != null) {
      //set isComplete in local database and delete from displayLessonTasks
      await dbProvider.deleteQuery(
        table: TABLE_LESSON_TASK,
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
    final int itemId,
  ) async {
    int updateId = 0;
    String tableName = "";
    String assetType = "";
    String updateColumn = "";

    switch (favouriteType) {
      case FavouriteType.Recipe:
        updateId = itemId;
        tableName = TABLE_RECIPE;
        assetType = "Recipe";
        updateColumn = "recipeId";
        break;
      case FavouriteType.Wiki:
        updateId = itemId;
        tableName = TABLE_WIKI;
        assetType = "CMS";
        updateColumn = "id";
        break;
      case FavouriteType.Lesson:
        updateId = itemId;
        tableName = TABLE_LESSON;
        assetType = "Lesson";
        updateColumn = "lessonID";
        break;
      case FavouriteType.None:
        break;
    }
    //update in sqlite
    if (dbProvider.db != null && tableName.length > 0) {
      final int isFavorite = isAdd ? 1 : 0;
      await dbProvider.updateQuery(
        table: tableName,
        setFields: "isFavorite = $isFavorite",
        whereClause: "$updateColumn = $updateId",
        limitRowCount: 1,
      );
    }
    //update in API to persist - don't await the service call otherwise too slow
    if (isAdd) {
      WebServices().addToFavourites(assetType, updateId);
    } else {
      WebServices().removeFromFavourites(assetType, updateId);
    }
  }

  Future<bool> _shouldGetDataFromAPI(
      final dbProvider, final String tableName) async {
    final int rowCount = await dbProvider.getTableRowCount(tableName);

    //no data in table so get data from API
    if (rowCount == 0) return true;

    final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    final int savedTimestamp = await getTimestamp(tableName);
    final int cacheSeconds = tableName == TABLE_MESSAGE ? 300 : 900;

    //we have data, so check if the data is older than 15 minutes (900 seconds) or 5 mins for messages
    if (savedTimestamp != null &&
        currentTimestamp - savedTimestamp > (cacheSeconds * 1000)) {
      return true;
    }

    //we have data and it is under 15 mins old (or 5 mins for Messages), so use the database version
    return false;
  }

  Future<List<dynamic>> getAllData(
    final dbProvider,
    final String tableName, {
    final String orderByColumn = "",
    final bool incompleteOnly = false,
    final bool favouritesOnly = false,
    final bool toolkitsOnly = false,
  }) async {
    final dataList = await dbProvider.getData(
        tableName, orderByColumn, incompleteOnly, favouritesOnly, toolkitsOnly);
    final mapName =
        tableName == TABLE_WIKI && favouritesOnly ? "LessonWiki" : tableName;
    return mapDataToList(dataList, mapName);
  }

  List<dynamic> mapDataToList(final dataList, final String tableName) {
    if (tableName == TABLE_RECIPE) {
      return dataList.map<Recipe>((item) => Recipe.fromJson(item)).toList();
    } else if (tableName == TABLE_MODULE) {
      return dataList.map<Module>((item) => Module.fromJson(item)).toList();
    } else if (tableName == TABLE_LESSON) {
      return dataList.map<Lesson>((item) => Lesson.fromJson(item)).toList();
    } else if (tableName == TABLE_LESSON_CONTENT) {
      return dataList
          .map<LessonContent>((item) => LessonContent.fromJson(item))
          .toList();
    } else if (tableName == TABLE_LESSON_TASK) {
      return dataList
          .map<LessonTask>((item) => LessonTask.fromJson(item))
          .toList();
    } else if (tableName == TABLE_LESSON_LINK) {
      return dataList
          .map<LessonLink>((item) => LessonLink.fromJson(item))
          .toList();
    } else if (tableName == "LessonWiki") {
      return dataList
          .map<LessonWiki>((item) => LessonWiki.fromJson(item))
          .toList();
    } else if (tableName == "LessonRecipe") {
      return dataList
          .map<LessonRecipe>((item) => LessonRecipe.fromJson(item))
          .toList();
    } else if (tableName == TABLE_MESSAGE) {
      return dataList.map<Message>((item) => Message.fromJson(item)).toList();
    } else if (tableName == TABLE_CMS_TEXT) {
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

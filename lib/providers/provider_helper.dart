import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/message.dart';
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
        debugPrint("**************FETCH QUESTIONS FROM API AND SAVE");
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
            'isFavorite': question.isFavorite,
          });
        });

        //save when we got the data
        saveTimestamp(tableName);
      }

      // get items from database
      debugPrint("*********GET DATA FROM DB $tableName");
      return await getAllData(dbProvider, tableName);
    }
    return List<Question>();
  }

  Future<List<Recipe>> fetchAndSaveRecipes(final dbProvider) async {
    final String tableName = "Recipe";
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      if (await _shouldGetDataFromAPI(dbProvider, tableName)) {
        final recipes = await WebServices().getAllRecipes();
        debugPrint("**************FETCH RECIPES FROM API AND SAVE");
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
      debugPrint("*********GET RECIPES FROM DB $tableName");
      return await getAllData(dbProvider, tableName);
    }
    return List<Recipe>();
  }

  //TODO, store notificationId in ID field
  Future<List<Message>> fetchAndSaveMessages(
      final dbProvider, final bool refreshFromAPI) async {
    final String tableName = "Message";
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      if (refreshFromAPI ||
          await _shouldGetDataFromAPI(dbProvider, tableName)) {
        final messages = await WebServices().getAllUserNotifications();
        debugPrint("**************FETCH MESSAGES FROM API AND SAVE");
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
      debugPrint("*********GET MESSAGES FROM DB $tableName");
      return await getAllData(dbProvider, tableName);
    }
    return List<Message>();
  }

  Future<List<dynamic>> filterAndSearch(final dbProvider,
      final String tableName, final String searchText, final String tag) async {
    if (dbProvider.db != null) {
      if (searchText.length > 0 || (tag.length > 0 && tag != "All")) {
        String searchQuery = "";
        if (searchText.length > 0) {
          searchQuery = tableName == "Recipe"
              ? " WHERE title LIKE '%$searchText%' OR description LIKE '%$searchText%'"
              : " WHERE question LIKE '%$searchText%'";
        }
        if (tag.length > 0 && tag != 'All') {
          searchQuery += searchText.length > 0 ? " AND" : " WHERE";
          searchQuery += " tags LIKE '%$tag%'";
        }
        final dataList = await dbProvider.getDataQuery(tableName, searchQuery);
        return mapDataToList(dataList, tableName);
      } else {
        return getAllData(dbProvider, tableName);
      }
    }
    return List<dynamic>();
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
        break;
      case FavouriteType.None:
        break;
    }
    //update in API
    WebServices().addToFavourites(assetType, updateId);
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
    final int cacheSeconds = tableName == "Message" ? 300 : 3600;

    //we have data, so check if the data is older than an hour (3,600,000 milliseconds)
    if (savedTimestamp != null &&
        currentTimestamp - savedTimestamp > (cacheSeconds * 1000)) {
      return true;
    }

    //we have data and it is under an hour old (or 10 mins for Messages), so use the database version
    return false;
  }

  Future<List<dynamic>> getAllData(
      final dbProvider, final String tableName) async {
    final dataList = await dbProvider.getData(tableName);
    return mapDataToList(dataList, tableName);
  }

  List<dynamic> mapDataToList(final dataList, final String tableName) {
    if (tableName == "Recipe") {
      return dataList.map<Recipe>((item) => Recipe.fromJson(item)).toList();
    } else if (tableName == "Message") {
      return dataList.map<Message>((item) => Message.fromJson(item)).toList();
    }
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
    List<Question> questionList = List<Question>();

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

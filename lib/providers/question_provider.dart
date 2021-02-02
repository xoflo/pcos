import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/models/cms.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class QuestionProvider with ChangeNotifier {
  QuestionProvider({this.dbProvider}) {
    if (dbProvider != null) fetchAndSaveData("KnowledgeBase");
  }

  final DatabaseProvider dbProvider;
  List<Question> _items = [];
  final tableName = 'Question';
  LoadingStatus status = LoadingStatus.empty;

  List<Question> get items => [..._items];

  Future<void> fetchAndSaveData(final String cmsType) async {
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      status = LoadingStatus.loading;
      notifyListeners();
      //first get the data from the api if we have no data yet
      if (await shouldGetDataFromAPI()) {
        final cmsItems = await WebServices().getCMSByType(cmsType);
        List<Question> questions = _convertCMSToQuestions(cmsItems, cmsType);
        debugPrint("**************FETCH DATA FROM API AND SAVE");
        //delete all old records before adding new ones
        await dbProvider.deleteAll(tableName);
        //add items to database
        questions.forEach((Question question) async {
          await dbProvider.insert(tableName, {
            'reference': question.reference,
            'questionType': question.questionType,
            'question': question.question,
            'answer': question.answer,
            'tags': question.tags
          });
        });

        //save when we got the data
        saveTimestamp(DateTime.now().millisecondsSinceEpoch);
      }

      // get items from database
      debugPrint("*********GET KBs FROM DB");
      await getAllData();
    }

    status = _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    notifyListeners();
  }

  Future<bool> shouldGetDataFromAPI() async {
    final int rowCount = await dbProvider.getTableRowCount(tableName);

    //no data in table so get data from API
    if (rowCount == 0) return true;

    final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    final int savedTimestamp = await getTimestamp();

    //we have data, so check if the data is older than an hour (3,600,000 milliseconds)
    if (savedTimestamp != null && currentTimestamp - savedTimestamp > 3600000) {
      return true;
    }

    //we have data and it is under an hour old, so use the database version
    return false;
  }

  Future<void> getAllData() async {
    final dataList = await dbProvider.getData(tableName);
    _items = mapDataToList(dataList);
  }

  List<Question> mapDataToList(final dataList) {
    return dataList
        .map<Question>((item) => Question(
            id: item['id'],
            reference: item['reference'],
            questionType: item['questionType'],
            question: item['question'],
            answer: item['answer'],
            tags: item['tags']))
        .toList();
  }

  Future<void> filterAndSearch(
      final String searchText, final String tag) async {
    if (dbProvider.db != null) {
      status = LoadingStatus.loading;
      notifyListeners();
      if (searchText.length > 0 || (tag.length > 0 && tag != "All")) {
        String searchQuery = "";
        if (searchText.length > 0) {
          searchQuery = " WHERE question LIKE '%$searchText%'";
        }
        if (tag.length > 0 && tag != 'All') {
          searchQuery += searchText.length > 0 ? " AND" : " WHERE";
          searchQuery += " tags LIKE '%$tag%'";
        }
        final dataList = await dbProvider.getDataQuery(tableName, searchQuery);
        _items = mapDataToList(dataList);
      } else {
        getAllData();
      }

      status = _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
      notifyListeners();
    }
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
        reference: question.reference,
        questionType: cmsType,
        question: question.body,
        answer: answer.body,
        tags: question.tags,
      );

      questionList.add(newQuestion);
    }
    return questionList;
  }

  Future<bool> saveTimestamp(final int timestamp) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(SharedPreferencesKeys.KB_SAVED_TIMESTAMP, timestamp);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<int> getTimestamp() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt(SharedPreferencesKeys.KB_SAVED_TIMESTAMP);
    } catch (ex) {
      return 0;
    }
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/models/cms.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class QuestionProvider with ChangeNotifier {
  QuestionProvider({this.dbProvider}) {
    if (dbProvider != null) fetchAndSetData("KnowledgeBase");
  }

  final DatabaseProvider dbProvider;
  List<Question> _items = [];
  final tableName = 'Question';
  LoadingStatus status = LoadingStatus.empty;

  List<Question> get items => [..._items];

  Future<void> fetchAndSetData(final String cmsType) async {
    //TODO: think about how to check whether to get from database or from api, be good to cache for say 24 hours, or until next day?
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      status = LoadingStatus.loading;
      notifyListeners();
      //first get the data from the api if we have no data yet
      if (_items.length == 0) {
        final cmsItems = await WebServices().getCMSByType(cmsType);
        List<Question> questions = _convertCMSToQuestions(cmsItems, cmsType);
        debugPrint("**************FETCH AND SET DATA CALLED");
        //delete all old records before adding new ones
        debugPrint("*********DELETE KBs FROM DB");
        await dbProvider.deleteAll(tableName);
        //add items to database
        debugPrint("*********ADD KBs TO DB");
        questions.forEach((Question question) async {
          debugPrint("*****SAVE Question=${question.reference}");
          await dbProvider.insert(tableName, {
            'reference': question.reference,
            'questionType': question.questionType,
            'question': question.question,
            'answer': question.answer,
            'tags': question.tags
          });
        });
      }
      // get items from database
      debugPrint("*********GET KBs FROM DB");
      final dataList = await dbProvider.getData(tableName);
      _items = dataList
          .map((item) => Question(
              id: item['id'],
              reference: item['reference'],
              questionType: item['questionType'],
              question: item['question'],
              answer: item['answer'],
              tags: item['tags']))
          .toList();
      status = dataList.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
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
}

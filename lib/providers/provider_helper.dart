import 'package:flutter/foundation.dart';
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
import 'package:thepcosprotocol_app/models/quiz.dart';
import 'package:thepcosprotocol_app/models/quiz_answer.dart';
import 'package:thepcosprotocol_app/models/quiz_question.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/models/cms.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/constants/table_names.dart';

// This provider is used for App Help
class ProviderHelper {
  Future<List<Question>> fetchAndSaveQuestions(
    final DatabaseProvider? dbProvider,
    final String tableName,
    final String assetType,
  ) async {
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    if (dbProvider?.db != null) {
      //first get the data from the api if we have no data yet
      if (await _shouldGetDataFromAPI(dbProvider, tableName)) {
        final cmsItems = await WebServices().getCMSByType(assetType);
        List<Question> questions = _convertCMSToQuestions(cmsItems, assetType);
        //delete all old records before adding new ones
        await dbProvider?.deleteAll(tableName);
        //add items to database
        questions.forEach((Question question) async {
          await dbProvider?.insert(tableName, {
            'id': question.id,
            'reference': question.reference,
            'question': question.question,
            'answer': question.answer,
            'tags': question.tags,
            'isFavorite': (question.isFavorite ?? false) ? 1 : 0,
          });
        });
        //save when we got the data
        saveTimestamp(tableName);
      }
      // get items from database
      List questions = await getAllData(dbProvider, tableName);
      return questions as List<Question>;
    }
    return [];
  }

  Future<List<Recipe>> fetchAndSaveRecipes(
      final DatabaseProvider? dbProvider) async {
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    if (dbProvider?.db != null) {
      //first get the data from the api if we have no data yet
      if (await _shouldGetDataFromAPI(dbProvider, TABLE_RECIPE)) {
        final recipes = await WebServices().getAllRecipes();
        //delete all old records before adding new ones
        await dbProvider?.deleteAll(TABLE_RECIPE);
        //add items to database
        recipes?.forEach((Recipe recipe) async {
          await dbProvider?.insert(TABLE_RECIPE, {
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
            'isFavorite': (recipe.isFavorite ?? false) ? 1 : 0,
          });
        });

        //save when we got the data
        saveTimestamp(TABLE_RECIPE);
      }
      // get items from database
      List recipes = await getAllData(dbProvider, TABLE_RECIPE);
      return recipes as List<Recipe>;
    }
    return [];
  }

  Future<List<LessonTask>> fetchAndSaveTaskForLesson(
      final DatabaseProvider? dbProvider,
      {final int? lessonID}) async {
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    if (dbProvider?.db != null) {
      //first get the data from the api if we have no data yet
      if (await _shouldGetDataFromAPI(dbProvider, TABLE_LESSON_TASK,
          where: "WHERE lessonID = $lessonID")) {
        final tasks = await WebServices().getTasksForLesson(lessonID ?? -1);
        //delete all old records before adding new ones
        await dbProvider?.deleteAll(TABLE_LESSON_TASK);
        //add items to database
        tasks?.forEach((LessonTask lessonTask) async {
          await dbProvider?.insert(TABLE_LESSON_TASK, {
            'lessonTaskID': lessonTask.lessonTaskID,
            'lessonID': lessonTask.lessonID ?? lessonID,
            'metaName': lessonTask.metaName,
            'title': lessonTask.title,
            'description': lessonTask.description,
            'taskType': lessonTask.taskType,
            'orderIndex': lessonTask.orderIndex,
            'isComplete': lessonTask.isComplete == true ? 1 : 0,
            'dateCreatedUTC': lessonTask.dateCreatedUTC?.toIso8601String(),
          });
        });

        //save when we got the data
        saveTimestamp(TABLE_LESSON_TASK);
      }
      // get items from database
      List lessonTasks = await getAllData(dbProvider, TABLE_LESSON_TASK);
      return lessonTasks as List<LessonTask>;
    }
    return [];
  }

  Future<ModulesAndLessons> fetchAndSaveModuleExport(
    final DatabaseProvider? dbProvider,
    final bool forceRefresh,
    final DateTime nextLessonAvailableDate,
  ) async {
    final bool isNextLessonAvailable =
        nextLessonAvailableDate.isBefore(DateTime.now());

    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    if (dbProvider?.db != null) {
      //first get the data from the api if we have no data yet
      if (forceRefresh ||
          await _shouldGetDataFromAPI(dbProvider, TABLE_MODULE)) {
        //first get the Wiki items and store in local DB
        await ProviderHelper()
            .fetchAndSaveQuestions(dbProvider, TABLE_WIKI, TABLE_WIKI);
        //now get the modules, lessons etc
        final List<ModuleExport>? moduleExport =
            await WebServices().getModulesExport();
        //delete all old records before adding new ones
        await dbProvider?.deleteAll(TABLE_MODULE);
        await dbProvider?.deleteAll(TABLE_LESSON);
        await dbProvider?.deleteAll(TABLE_LESSON_CONTENT);
        await dbProvider?.deleteAll(TABLE_LESSON_TASK);
        await dbProvider?.deleteAll(TABLE_LESSON_LINK);
        await dbProvider?.deleteAll(TABLE_QUIZ);
        await dbProvider?.deleteAll(TABLE_QUIZ_QUESTION);
        await dbProvider?.deleteAll(TABLE_QUIZ_ANSWER);

        //add modules to database
        await _addModulesAndLessonsToDatabase(dbProvider, moduleExport);

        //save when we got the data
        await saveTimestamp(TABLE_MODULE);
      }

      // get items from database
      final List modulesFromDB = await getAllData(
        dbProvider,
        TABLE_MODULE,
        orderByColumn: "orderIndex",
      );

      final List<Lesson> lessonsFromDB = await getAllData(
        dbProvider,
        TABLE_LESSON,
        orderByColumn: "moduleID, orderIndex",
      ) as List<Lesson>;
      final List<LessonContent> lessonContentFromDB = await getAllData(
        dbProvider,
        TABLE_LESSON_CONTENT,
        orderByColumn: "lessonID, orderIndex",
      ) as List<LessonContent>;

      //get and add the Quizzes including questions and answers to the DB
      //do this after modules and lessons so we can check the lesson links to see which quizzes are for this member
      final List<LessonTask>? lessonQuizTasks =
          await WebServices().getQuizTasks();
      debugPrint("Got Lesson Quiz TASKS count = ${lessonQuizTasks?.length}");
      await _addQuizzesToDatabase(dbProvider, lessonQuizTasks);

      final List quizzesFromDB = await getAllData(
        dbProvider,
        TABLE_QUIZ,
        orderByColumn: "quizID",
      );

      final List quizQuestionsFromDB = await getAllData(
        dbProvider,
        TABLE_QUIZ_QUESTION,
        orderByColumn: "quizID, orderIndex",
      );

      final List quizAnswersFromDB = await getAllData(
        dbProvider,
        TABLE_QUIZ_ANSWER,
        orderByColumn: "quizQuestionID, orderIndex",
      );

      debugPrint("QUIZZES FROM DB = ${quizzesFromDB.length}");
      debugPrint("QUIZ QUESTIONS FROM DB = ${quizQuestionsFromDB.length}");

      for (Quiz quiz in quizzesFromDB) {
        List<QuizQuestion> thisQuizQuestions = [];
        for (QuizQuestion question in quizQuestionsFromDB) {
          List<QuizAnswer> thisQuestionAnswers = [];
          int trueAnswerCount = 0;
          for (QuizAnswer answer in quizAnswersFromDB) {
            if (answer.quizQuestionID == question.quizQuestionID) {
              thisQuestionAnswers.add(answer);
              if (answer.isCorrect == true) {
                trueAnswerCount++;
              }
            }
          }
          question.answers = thisQuestionAnswers;
          question.isMultiChoice = trueAnswerCount > 1 ? true : false;
          if (question.quizID == quiz.quizID) {
            thisQuizQuestions.add(question);
          }
        }
        quiz.questions = thisQuizQuestions;
      }
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

      //get the lesson wikis by joining the wiki and lesson table and only return the lessonWikis for lessons in lessonsToReturn
      final wikiList = await dbProvider?.getDataQueryWithJoin(
        "$TABLE_WIKI.*, $TABLE_LESSON_LINK.LessonID, $TABLE_LESSON_LINK.ModuleID",
        "$TABLE_WIKI INNER JOIN $TABLE_LESSON_LINK ON $TABLE_WIKI.id = $TABLE_LESSON_LINK.objectID",
        "WHERE objectType = 'wiki'",
      );

      final List<LessonWiki> lessonWikisToReturn =
          mapDataToList(wikiList, "LessonWiki") as List<LessonWiki>;

      //get the lesson recipes by joining the recipe and lesson table and only return the lessonRecipes for lessons in lessonsToReturn
      final recipeList = await dbProvider?.getDataQueryWithJoin(
        "$TABLE_RECIPE.*, $TABLE_LESSON_LINK.LessonID",
        "$TABLE_RECIPE INNER JOIN $TABLE_LESSON_LINK ON $TABLE_RECIPE.recipeId = $TABLE_LESSON_LINK.objectID",
        "WHERE objectType = 'recipe'",
      );

      final List<LessonRecipe> lessonRecipesToReturn =
          mapDataToList(recipeList, "LessonRecipe") as List<LessonRecipe>;

      //TODO: need to check whether complete when available
      final List<Quiz> quizzesToReturn = [];
      for (Quiz quiz in quizzesFromDB) {
        //does the member need this quiz?
        if (lessonIDs.contains(quiz.lessonID)) {
          //&& !lessonTask.isComplete)

          List<QuizQuestion> thisQuizQuestions = [];
          for (QuizQuestion question in quizQuestionsFromDB) {
            List<QuizAnswer> thisQuestionAnswers = [];
            for (QuizAnswer answer in quizAnswersFromDB) {
              if (answer.quizQuestionID == question.quizQuestionID) {
                thisQuestionAnswers.add(answer);
              }
            }
            question.answers = thisQuestionAnswers;
            if (question.quizID == quiz.quizID) {
              thisQuizQuestions.add(question);
            }
          }
          quiz.questions = thisQuizQuestions;
          quizzesToReturn.add(quiz);
        }
      }

      final ModulesAndLessons modulesAndLessons = ModulesAndLessons(
        modules: modulesToReturn,
        lessons: lessonsToReturn,
        lessonContent: lessonContentToReturn,
        lessonWikis: lessonWikisToReturn,
        lessonRecipes: lessonRecipesToReturn,
        lessonQuizzes: quizzesToReturn,
      );
      return modulesAndLessons;
    }
    return ModulesAndLessons();
  }

  Future<void> _addModulesAndLessonsToDatabase(
      final DatabaseProvider? dbProvider,
      final List<ModuleExport>? moduleExport) async {
    moduleExport?.forEach((ModuleExport moduleExport) async {
      Module? module = moduleExport.module;
      await dbProvider?.insert(TABLE_MODULE, {
        'moduleID': module?.moduleID,
        'title': module?.title,
        'isComplete': module?.isComplete == true ? 1 : 0,
        'orderIndex': module?.orderIndex,
        'dateCreatedUTC': module?.dateCreatedUTC?.toIso8601String(),
      });
    });

    //add lessons, lesson content and lesson tasks to database
    moduleExport?.forEach((ModuleExport moduleExport) async {
      List<LessonExport>? lessons = moduleExport.lessons;
      lessons?.forEach((LessonExport lessonExport) async {
        Lesson? lesson = lessonExport.lesson;
        List<LessonContent>? lessonContent = lessonExport.content;
        List<LessonLink>? lessonLinks = lessonExport.links;
        //add lesson to database
        await dbProvider?.insert(TABLE_LESSON, {
          'lessonID': lesson?.lessonID,
          'moduleID': moduleExport.module?.moduleID,
          'title': lesson?.title,
          'introduction': lesson?.introduction,
          'imageUrl': lesson?.imageUrl,
          'orderIndex': lesson?.orderIndex,
          'isFavorite': lesson?.isFavorite == true ? 1 : 0,
          'isComplete': lesson?.isComplete == true ? 1 : 0,
          'isToolkit': lesson?.isToolkit == true ? 1 : 0,
          'dateCreatedUTC': lesson?.dateCreatedUTC.toIso8601String(),
        });
        //add lesson content to database
        await _addLessonContentToDatabase(dbProvider, lessonContent);
        await _addLessonLinkToDatabase(
            dbProvider, lessonLinks, moduleExport.module?.moduleID);
      });
    });
  }

  Future<void> _addLessonContentToDatabase(final DatabaseProvider? dbProvider,
      List<LessonContent>? lessonContents) async {
    lessonContents?.forEach((LessonContent lessonContent) async {
      await dbProvider?.insert(TABLE_LESSON_CONTENT, {
        'lessonContentID': lessonContent.lessonContentID,
        'lessonID': lessonContent.lessonID,
        'title': lessonContent.title,
        'mediaUrl': lessonContent.mediaUrl,
        'mediaMimeType': lessonContent.mediaMimeType,
        'body': lessonContent.body,
        'summary': lessonContent.summary,
        'orderIndex': lessonContent.orderIndex,
        'dateCreatedUTC': lessonContent.dateCreatedUTC?.toIso8601String(),
      });
    });
  }

  Future<void> _addLessonLinkToDatabase(final DatabaseProvider? dbProvider,
      final List<LessonLink>? lessonLinks, final int? moduleID) async {
    lessonLinks?.forEach((LessonLink lessonLink) async {
      await dbProvider?.insert(TABLE_LESSON_LINK, {
        'lessonLinkID': lessonLink.lessonLinkID,
        'lessonID': lessonLink.lessonID,
        'moduleID': moduleID,
        'objectID': lessonLink.objectID,
        'objectType': lessonLink.objectType,
        'orderIndex': lessonLink.orderIndex,
        'dateCreatedUTC': lessonLink.dateCreatedUTC?.toIso8601String(),
      });
    });
  }

  Future<void> _addQuizzesToDatabase(final DatabaseProvider? dbProvider,
      final List<LessonTask>? lessonQuizTasks) async {
    final List<LessonLink> lessonLinksFromDB = mapDataToList(
        await dbProvider?.getDataQuery(
          TABLE_LESSON_LINK,
          "WHERE objectType = 'quiz'",
        ),
        TABLE_LESSON_LINK) as List<LessonLink>;
    //using TaskType split the tasks into five groups, quiz, quiz-question, quiz-question-resp, quiz-answer, quiz-answer-resp
    final List<LessonTask>? quizzes =
        lessonQuizTasks?.where((task) => task.taskType == "quiz").toList();
    final List<LessonTask>? quizMessages =
        lessonQuizTasks?.where((task) => task.taskType == "quiz-msg").toList();
    final List<LessonTask>? quizQuestions = lessonQuizTasks
        ?.where((task) => task.taskType == "quiz-question")
        .toList();
    final List<LessonTask>? quizQuestionResponses = lessonQuizTasks
        ?.where((task) => task.taskType == "quiz-question-resp")
        .toList();
    final List<LessonTask>? quizAnswers = lessonQuizTasks
        ?.where((task) => task.taskType == "quiz-answer")
        .toList();
    final List<LessonTask>? quizAnswerResponses = lessonQuizTasks
        ?.where((task) => task.taskType == "quiz-answer-resp")
        .toList();

    debugPrint("QUIZ=${quizzes?.length}");
    debugPrint("QUIZ MSGS=${quizMessages?.length}");
    debugPrint("QUESTIONS=${quizQuestions?.length}");
    debugPrint("Q RESPS=${quizQuestionResponses?.length}");
    debugPrint("ANSWERS=${quizAnswers?.length}");
    debugPrint("A RESPS=${quizAnswerResponses?.length}");

    quizzes?.forEach((LessonTask quiz) async {
      //only insert if there is a lesson link in the LessonLink table
      final LessonLink? quizLink = lessonLinksFromDB.firstWhereOrNull(
        (link) => link.objectID == quiz.lessonTaskID,
      );
      if (quizLink != null) {
        debugPrint(
            "FOUND QUIZ LINK quizid=${quizLink.objectID} lessonID=${quizLink.lessonID}");
        //has this quiz got an end title and message?
        String quizEndTitle = "";
        String quizEndMessage = "";
        final LessonTask? quizMsg = quizMessages?.firstWhereOrNull(
          (task) => task.metaName?.startsWith(quiz.metaName ?? "") ?? false,
        );

        if (quizMsg != null) {
          quizEndTitle = quizMessages?[0].title ?? "";
          quizEndMessage = quizMessages?[0].description ?? "";
        }

        //insert the quiz with the lessonID
        await dbProvider?.insert(TABLE_QUIZ, {
          'quizID': quiz.lessonTaskID,
          'lessonID': quizLink.lessonID,
          'title': quiz.title,
          'description': quiz.description,
          'endTitle': quizEndTitle,
          'endMessage': quizEndMessage,
        });
        //insert the questions for this quiz
        final List<LessonTask>? thisQuizQuestions = quizQuestions
            ?.where((question) =>
                question.metaName?.startsWith(quiz.metaName ?? "") ?? false)
            .toList();

        thisQuizQuestions?.forEach((LessonTask question) async {
          //get the question response if there is one
          final LessonTask? thisQuestionResponse =
              quizQuestionResponses?.firstWhereOrNull(
            (response) =>
                response.metaName?.startsWith(question.metaName ?? "") ?? false,
          );
          if (thisQuestionResponse != null)
            debugPrint(
                "found a question response id=${thisQuestionResponse.lessonTaskID}");
          //insert the question with the response
          await dbProvider?.insert(TABLE_QUIZ_QUESTION, {
            'quizQuestionID': question.lessonTaskID,
            'quizID': quiz.lessonTaskID,
            'questionType': question.description,
            'questionText': question.title,
            'response':
                thisQuestionResponse == null ? "" : thisQuestionResponse.title,
            'orderIndex': question.orderIndex,
          });

          //now get the answers for this question
          final List<LessonTask>? thisQuestionAnswers = quizAnswers
              ?.where((answer) =>
                  answer.metaName?.startsWith(question.metaName ?? "") ?? false)
              .toList();

          thisQuestionAnswers?.forEach((LessonTask answer) async {
            //get the answer response if there is one
            final LessonTask? thisAnswerResponse =
                quizAnswerResponses?.firstWhereOrNull(
              (response) =>
                  response.metaName?.startsWith(answer.metaName ?? "") ?? false,
            );
            if (thisAnswerResponse != null)
              debugPrint(
                  "found a answer response id=${thisAnswerResponse.lessonTaskID}");
            //insert the answer with the response
            await dbProvider?.insert(TABLE_QUIZ_ANSWER, {
              'quizAnswerID': answer.lessonTaskID,
              'quizQuestionID': question.lessonTaskID,
              'answerText': answer.title,
              'isCorrect': answer.description?.toLowerCase() == "true" ? 1 : 0,
              'response':
                  thisAnswerResponse == null ? "" : thisAnswerResponse.title,
              'orderIndex': answer.orderIndex,
            });
          });
        });
      }
    });
  }

  Future<List<Message>> fetchAndSaveMessages(
      final DatabaseProvider? dbProvider, final bool refreshFromAPI) async {
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    if (dbProvider?.db != null) {
      //first get the data from the api if we have no data yet
      if (refreshFromAPI ||
          await _shouldGetDataFromAPI(dbProvider, TABLE_MESSAGE)) {
        final messages = await WebServices().getAllUserNotifications();
        //delete all old records before adding new ones
        await dbProvider?.deleteAll(TABLE_MESSAGE);
        //add items to database
        messages?.forEach((Message message) async {
          await dbProvider?.insert(TABLE_MESSAGE, {
            'notificationId': message.notificationId,
            'title': message.title,
            'message': message.message,
            'isRead': message.isRead == true ? 1 : 0,
            'action': message.action,
            'dateReadUTC': message.dateReadUTC?.toIso8601String(),
            'dateCreatedUTC': message.dateCreatedUTC?.toIso8601String(),
          });
        });

        //save when we got the data
        saveTimestamp(TABLE_MESSAGE);
      }

      // get items from database
      List message = await getAllData(dbProvider, TABLE_MESSAGE);
      return message as List<Message>;
    }
    return [];
  }

  Future<List<String>> fetchAndSaveCMSText(
      final DatabaseProvider? dbProvider) async {
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    if (dbProvider?.db != null) {
      //first get the data from the api if we have no data yet
      if (await _shouldGetDataFromAPI(dbProvider, TABLE_CMS_TEXT)) {
        final String? gettingStarted =
            await WebServices().getCmsAssetByReference("GettingStarted");
        final String? privacyStatement =
            await WebServices().getCmsAssetByReference("Privacy");
        final String? termsAndConditions =
            await WebServices().getCmsAssetByReference("Terms");
        List<String?> cmsItems = [
          gettingStarted,
          privacyStatement,
          termsAndConditions
        ];

        //delete all old records before adding new ones
        await dbProvider?.deleteAll(TABLE_CMS_TEXT);
        //add items to database
        cmsItems.forEach((String? cmsItem) async {
          await dbProvider?.insert(TABLE_CMS_TEXT, {
            'cmsText': cmsItem,
          });
        });

        //save when we got the data
        saveTimestamp(TABLE_CMS_TEXT);
      }

      // get items from database
      List data = await getAllData(dbProvider, TABLE_CMS_TEXT);
      return data as List<String>;
    }
    return [];
  }

  Future<AllFavourites> getFavourites(
      final DatabaseProvider? dbProvider) async {
    List toolkits =
        await getAllData(dbProvider, TABLE_LESSON, toolkitsOnly: true);
    List lessons =
        await getAllData(dbProvider, TABLE_LESSON, favouritesOnly: true);
    List wikis = await getAllData(dbProvider, TABLE_WIKI, favouritesOnly: true);
    List recipes =
        await getAllData(dbProvider, TABLE_RECIPE, favouritesOnly: true);

    return AllFavourites(
      toolkits: toolkits as List<Lesson>,
      lessons: lessons as List<Lesson>,
      lessonWikis: wikis as List<LessonWiki>,
      recipes: recipes as List<Recipe>,
    );
  }

  Future<List<dynamic>> filterAndSearch(
      final DatabaseProvider? dbProvider,
      final String tableName,
      final String searchText,
      final String tag,
      final List<String> secondaryTags) async {
    if (dbProvider?.db != null) {
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
        final dataList = await dbProvider?.getDataQuery(tableName, searchQuery);
        return mapDataToList(dataList, tableName);
      } else {
        return getAllData(dbProvider, tableName);
      }
    }
    return [];
  }

  Future<void> markNotificationAsRead(
      final DatabaseProvider? dbProvider, final int? notificationId) async {
    //update on server
    WebServices().markNotificationAsRead(notificationId);
    if (dbProvider?.db != null) {
      //update in sqlite
      await dbProvider?.updateQuery(
        table: TABLE_MESSAGE,
        setFields: "isRead = 1",
        whereClause: "notificationId = $notificationId",
        limitRowCount: 1,
      );
    }
  }

  Future<void> markNotificationAsDeleted(
      final DatabaseProvider? dbProvider, final int? notificationId) async {
    //update on server
    WebServices().markNotificationAsDeleted(notificationId);
    if (dbProvider?.db != null) {
      //update in sqlite
      await dbProvider?.deleteQuery(
        table: TABLE_MESSAGE,
        whereClause: "notificationId = $notificationId",
        limitRowCount: 1,
      );
    }
  }

  Future<bool> markTaskAsCompleted(final DatabaseProvider? dbProvider,
      final int? lessonTaskID, final String value) async {
    //update on server
    final bool setComplete =
        await WebServices().setTaskComplete(lessonTaskID, value);
    //refresh the data from the API
    if (setComplete && dbProvider?.db != null) {
      //set isComplete in local database and delete from displayLessonTasks
      await dbProvider?.updateQuery(
        table: TABLE_LESSON_TASK,
        setFields: "isComplete = 1",
        whereClause: "lessonTaskID = $lessonTaskID",
        limitRowCount: 1,
      );
    }
    return setComplete;
  }

  Future<void> addToFavourites(
    final bool isAdd,
    final DatabaseProvider? dbProvider,
    final FavouriteType favouriteType,
    final int? itemId,
  ) async {
    int? updateId = 0;
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
    if (dbProvider?.db != null && tableName.length > 0) {
      final int isFavorite = isAdd ? 1 : 0;
      await dbProvider?.updateQuery(
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
      final DatabaseProvider? dbProvider, final String tableName,
      {final String? where}) async {
    final int? rowCount =
        (await dbProvider?.getDataQuery(tableName, where ?? ""))?.length;

    //no data in table so get data from API
    if (rowCount == 0) return true;

    final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    final int? savedTimestamp = await getTimestamp(tableName);
    final int cacheSeconds = tableName == TABLE_MESSAGE ? 300 : 900;

    //we have data, so check if the data is older than 15 minutes (900 seconds) or 5 mins for messages
    if (savedTimestamp != null &&
        currentTimestamp - savedTimestamp > (cacheSeconds * 1000)) {
      return true;
    }

    //we have data and it is under 15 mins old (or 5 mins for Messages), so use the database version
    return false;
  }

  Future<List> getAllData(
    final DatabaseProvider? dbProvider,
    final String tableName, {
    final String orderByColumn = "",
    final bool incompleteOnly = false,
    final bool favouritesOnly = false,
    final bool toolkitsOnly = false,
  }) async {
    final dataList = await dbProvider?.getData(
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
    } else if (tableName == "LessonTask") {
      return dataList
          .map<LessonTask>((item) => LessonTask.fromJson(item))
          .toList();
    } else if (tableName == TABLE_QUIZ) {
      return dataList.map<Quiz>((item) => Quiz.fromJson(item)).toList();
    } else if (tableName == TABLE_QUIZ_QUESTION) {
      return dataList
          .map<QuizQuestion>((item) => QuizQuestion.fromJson(item))
          .toList();
    } else if (tableName == TABLE_QUIZ_ANSWER) {
      return dataList
          .map<QuizAnswer>((item) => QuizAnswer.fromJson(item))
          .toList();
    } else if (tableName == TABLE_MESSAGE) {
      return dataList.map<Message>((item) => Message.fromJson(item)).toList();
    } else if (tableName == TABLE_CMS_TEXT) {
      List<CMSText> cmsItems =
          dataList.map<CMSText>((item) => CMSText.fromJson(item)).toList();
      List<String> cmsStrings = [];
      for (CMSText cmsText in cmsItems) {
        cmsStrings.add(cmsText.cmsText ?? "");
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
      final List<CMS>? cmsItems, final String cmsType) {
    List<Question> questionList = [];

    if ((cmsItems?.length ?? 0).isOdd) {
      //an odd number of items, so remove the last one as they should be in pairs
      cmsItems?.removeAt(cmsItems.length);
    }

    for (var i = 0; i < (cmsItems?.length ?? 0) - 1; i = i + 2) {
      final question = cmsItems?[i];
      final answer = cmsItems?[i + 1];

      Question newQuestion = Question(
        id: question?.cmsId,
        reference: question?.reference,
        question: question?.body,
        answer: answer?.body,
        tags: question?.tags,
        isFavorite: question?.isFavorite,
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

  Future<int?> getTimestamp(final String tableName) async {
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

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

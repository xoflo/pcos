import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thepcosprotocol_app/constants/table_names.dart';
import 'package:thepcosprotocol_app/models/cms.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/models/module_export.dart';
import 'package:thepcosprotocol_app/models/modules_and_lessons.dart';

import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'test_helper.dart';

import 'provider_helper_test.mocks.dart';

@GenerateMocks([DatabaseProvider, WebServices, FlavorConfig])
void main() {
  group('fetchAndSaveModuleExport', () {
    test('returns modules and lessons', () async {
      MockDatabaseProvider databaseProvider = await _mockDatabaseProvider();

      ProviderHelper providerHelper = await _setupProviderHelper();

      ModulesAndLessons modulesAndLessons = await providerHelper
          .fetchAndSaveModuleExport(databaseProvider, true, DateTime.now());

      expect(modulesAndLessons.modules?.length == 3, true);
      expect(modulesAndLessons.lessons?.length == 54, true);
      expect(modulesAndLessons.lessonContent?.length == 210, true);
      expect(modulesAndLessons.lessonWikis?.length == 50, true);
      expect(modulesAndLessons.lessonRecipes?.length == 20, true);
      expect(modulesAndLessons.lessonQuizzes?.length == 14, true);
    });
  });
}

Future<ProviderHelper> _setupProviderHelper() async {
  ProviderHelper providerHelper = ProviderHelper();
  providerHelper.webServices = await _mockWebServices();

  _mockDatabaseProvider();
  return providerHelper;
}

Future<MockWebServices> _mockWebServices() async {
  MockWebServices webServices = MockWebServices();
  when(webServices.baseUrl).thenReturn("anyString-Since-This-Is-Mocked");

  List<CMS> cmsList =
      await constructListFromFile("CMSMultiResponse_Wiki") as List<CMS>;
  when(webServices.getCMSByType(TABLE_WIKI))
      .thenAnswer((_) => new Future(() => cmsList));

  List<ModuleExport> moduleExport =
      await constructListFromFile("ModuleExportResponse") as List<ModuleExport>;
  when(webServices.getModulesExport())
      .thenAnswer((_) => new Future(() => moduleExport));

  List<LessonTask> lessonTasks =
      await constructListFromFile("LessonTaskResponse_quizTasks")
          as List<LessonTask>;
  when(webServices.getQuizTasks())
      .thenAnswer((_) => new Future(() => lessonTasks));

  return webServices;
}

Future<MockDatabaseProvider> _mockDatabaseProvider() async {
  MockDatabaseProvider dbaseProvider = MockDatabaseProvider();
  sqfliteFfiInit();
  Database database =
      await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  dbaseProvider.db = database;

  when(dbaseProvider.db).thenReturn(database);

  List<Map<String, Object>> wikiList =
      await constructMapFromFile(TABLE_WIKI, TABLE_WIKI)
          as List<Map<String, Object>>;
  when(dbaseProvider.getData(TABLE_WIKI, "", false, false, false))
      .thenAnswer((_) => new Future(() => wikiList));

  List<Map<String, Object>> moduleList =
      await constructMapFromFile("ModuleExportResponse", "Module")
          as List<Map<String, Object>>;
  when(dbaseProvider.getData(TABLE_MODULE, "orderIndex", false, false, false))
      .thenAnswer((_) => new Future(() => moduleList));

  List<Map<String, Object>> lessonList =
      await constructMapFromFile(TABLE_LESSON, TABLE_LESSON)
          as List<Map<String, Object>>;
  when(dbaseProvider.getData(
          TABLE_LESSON, "moduleID, orderIndex", false, false, false))
      .thenAnswer((_) => new Future(() => lessonList));

  when(dbaseProvider.getDataQuery(TABLE_WIKI, ""))
      .thenAnswer((_) => new Future(() => wikiList));

  List<Map<String, Object>> lessonContentList =
      await constructMapFromFile("ModuleExportResponse", "LessonContent")
          as List<Map<String, Object>>;
  when(dbaseProvider.getData(
          'LessonContent', 'lessonID, orderIndex', false, false, false))
      .thenAnswer((_) => new Future(() => lessonContentList));

  List<Map<String, Object>> lessonLinks =
      await constructMapFromFile(TABLE_LESSON_LINK, TABLE_LESSON_LINK)
          as List<Map<String, Object>>;
  when(dbaseProvider.getDataQuery(
          TABLE_LESSON_LINK, "WHERE objectType = 'quiz'"))
      .thenAnswer((_) => new Future(() => lessonLinks));

  List<Map<String, Object>> lessonQuizList =
      await constructMapFromFile(TABLE_QUIZ, TABLE_QUIZ)
          as List<Map<String, Object>>;
  when(dbaseProvider.getData(TABLE_QUIZ, 'quizID', false, false, false))
      .thenAnswer((_) => new Future(() => lessonQuizList));

  List<Map<String, Object>> lessonQuizQuestions =
      await constructMapFromFile(TABLE_QUIZ_QUESTION, TABLE_QUIZ_QUESTION)
          as List<Map<String, Object>>;
  when(dbaseProvider.getData(
          TABLE_QUIZ_QUESTION, 'quizID, orderIndex', false, false, false))
      .thenAnswer((_) => new Future(() => lessonQuizQuestions));

  List<Map<String, Object>> lessonQuizAnswers =
      await constructMapFromFile(TABLE_QUIZ_ANSWER, TABLE_QUIZ_ANSWER)
          as List<Map<String, Object>>;
  when(dbaseProvider.getData(
          TABLE_QUIZ_ANSWER, 'quizQuestionID, orderIndex', false, false, false))
      .thenAnswer((_) => new Future(() => lessonQuizAnswers));

  List<Map<String, Object>> wikiListWithJoin =
      await constructMapFromFile("getDataQueryWithJoin_Wiki", TABLE_WIKI)
          as List<Map<String, Object>>;
  when(dbaseProvider.getDataQueryWithJoin(
          "Wiki.*, LessonLink.LessonID, LessonLink.ModuleID",
          "Wiki INNER JOIN LessonLink ON Wiki.id = LessonLink.objectID",
          "WHERE objectType = 'wiki'"))
      .thenAnswer((_) => new Future(() => wikiListWithJoin));

  List<Map<String, Object>> recipeListWithJoin =
      await constructMapFromFile("getDataQueryWithJoin_Recipe", TABLE_RECIPE)
          as List<Map<String, Object>>;
  when(dbaseProvider.getDataQueryWithJoin(
          "Recipe.*, LessonLink.LessonID",
          "Recipe INNER JOIN LessonLink ON Recipe.recipeId = LessonLink.objectID",
          "WHERE objectType = 'recipe'"))
      .thenAnswer((_) => new Future(() => recipeListWithJoin));

  return dbaseProvider;
}

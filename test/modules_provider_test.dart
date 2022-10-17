import 'dart:convert';
import 'dart:io';
import 'package:sqflite/sqflite.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/models/modules_and_lessons.dart';
import 'package:thepcosprotocol_app/models/quiz.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/constants/table_names.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'test_helper.dart';

import 'modules_provider_test.mocks.dart';

/// Run
/// flutter packages pub run build_runner build --delete-conflicting-outputs
/// or
/// flutter pub run build_runner build --delete-conflicting-outputs
/// when mocks change
@GenerateMocks([
  DatabaseProvider,
  PreferencesController,
  ProviderHelper,
  WebServices,
  FlavorConfig
])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('fetchAndSaveData', () {
    test(
        'returns modules and lessons, current module, previous modules, current module lessons, current lesson',
        () async {
      ModulesProvider modulesProvider = await _setupModulesProvider();
      await modulesProvider.fetchAndSaveData(true);

      expect(modulesProvider.currentModule?.moduleID, 10,
          reason: "should be 10 because that's the last module.");

      expect(
          _isAllBelongToCurrentModuleID(modulesProvider.currentModuleLessons,
              modulesProvider.currentModule?.moduleID),
          true);

      expect(
          _isShouldBeCurrentLesson(modulesProvider.currentLesson,
              modulesProvider.currentModuleLessons, modulesProvider),
          true);

      const LESSON_ID_WITH_CONTENTS = 26;
      expect(
          modulesProvider.getLessonContent(LESSON_ID_WITH_CONTENTS).length > 0,
          true,
          reason: "length of lessonContents should not be zero");

      expect(modulesProvider.loadingStatus, LoadingStatus.success,
          reason: "should be success");
    });
  });
}

bool _isShouldBeCurrentLesson(Lesson? currentLesson, currentModuleLessons,
    ModulesProvider modulesProvider) {
  Lesson foundCurrentLesson = currentModuleLessons.firstWhere(
    (element) =>
        !element.isComplete ||
        modulesProvider.getQuizByLessonID(element.lessonID)?.isComplete ==
            false,
    orElse: () => modulesProvider.currentModuleLessons.last,
  );

  if (foundCurrentLesson.lessonID == currentLesson?.lessonID) {
    return true;
  } else {
    return false;
  }
}

bool _isAllBelongToCurrentModuleID(List<Lesson> lessons, currentModuleID) {
  for (Lesson lesson in lessons) {
    if (lesson.moduleID != currentModuleID) {
      return false;
    }
  }
  return true;
}

Future<ModulesProvider> _setupModulesProvider() async {
  MockPreferencesController preferencesController =
      _mockPreferencesController();

  MockDatabaseProvider dbaseProvider = await _mockDatabaseProvider();

  MockWebServices webServices = MockWebServices();
  when(webServices.baseUrl).thenReturn("anyString-Since-This-Is-Mocked");

  MockProviderHelper providerHelper = await _mockProviderHelper(dbaseProvider);
  providerHelper = await _mockProviderHelperFetchAndSaveModuleExport(
      providerHelper, dbaseProvider);
  providerHelper.webServices = webServices;

  ModulesProvider modulesProvider = ModulesProvider(dbProvider: dbaseProvider);
  modulesProvider.preferencesController = preferencesController;
  modulesProvider.providerHelper = providerHelper;
  modulesProvider.webServices = webServices;

  return modulesProvider;
}

MockPreferencesController _mockPreferencesController() {
  MockPreferencesController mockPreferencesController =
      MockPreferencesController();
  when(mockPreferencesController
          .getString(SharedPreferencesKeys.NEXT_LESSON_AVAILABLE_DATE))
      .thenAnswer((_) => new Future(() => "2022-08-31 22:34:13.708643"));

  return mockPreferencesController;
}

Future<MockDatabaseProvider> _mockDatabaseProvider() async {
  MockDatabaseProvider dbaseProvider = MockDatabaseProvider();
  sqfliteFfiInit();
  Database database =
      await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  // await database.execute(databaseRules);
  dbaseProvider.db = database;

  when(dbaseProvider.db).thenReturn(database);

  List<Map<String, Object?>>? list = [];
  when(dbaseProvider.getDataQuery("Module", null))
      .thenAnswer((_) => new Future(() => list));

  when(dbaseProvider.getDataQuery("Module", ""))
      .thenAnswer((_) => new Future(() => list));

  when(dbaseProvider.getDataQuery("Wiki", ""))
      .thenAnswer((_) => new Future(() => list));

  when(dbaseProvider.getData('Wiki', '', false, false, false))
      .thenAnswer((_) => new Future(() => list));

  return dbaseProvider;
}

Future<MockProviderHelper> _mockProviderHelper(
    MockDatabaseProvider mockDatabaseProvider) async {
  var input = await File("test_resources/Questions.json").readAsString();
  List<dynamic> questionsDynamicList = jsonDecode(input);

  // TODO redundant with existing operation of .map in provider_helper
  var questionsList = questionsDynamicList
      .map<Question>((item) => Question(
            id: item['id'],
            reference: item['reference'],
            question: item['question'],
            answer: item['answer'],
            tags: item['tags'],
            isFavorite: item['isFavorite'] == 1 ? true : false,
          ))
      .toList();

  MockProviderHelper providerHelper = MockProviderHelper();
  when(providerHelper.fetchAndSaveQuestions(
          mockDatabaseProvider, TABLE_WIKI, TABLE_WIKI))
      .thenAnswer((_) => new Future(() => questionsList));

  return providerHelper;
}

Future<MockProviderHelper> _mockProviderHelperFetchAndSaveModuleExport(
    MockProviderHelper providerHelper,
    MockDatabaseProvider mockDatabaseProvider) async {
  List<Lesson> lessons = await constructListFromFile("Lesson") as List<Lesson>;
  List<LessonContent> lessonContents =
      await constructListFromFile("LessonContent") as List<LessonContent>;
  List<Quiz> lessonQuizzes =
      await constructListFromFile("LessonQuiz") as List<Quiz>;
  List<Module> modules = await constructListFromFile("Module") as List<Module>;

  ModulesAndLessons modulesAndLessons = ModulesAndLessons(
      lessonContent: lessonContents,
      lessonQuizzes: lessonQuizzes,
      lessonRecipes: [],
      lessonTasks: [],
      lessonWikis: [],
      lessons: lessons,
      modules: modules);

  DateTime dateTimeValueDoesNotMatterHere =
      DateTime.parse("2022-08-31 22:34:13.708643");
  when(providerHelper.fetchAndSaveModuleExport(
          mockDatabaseProvider, true, dateTimeValueDoesNotMatterHere))
      .thenAnswer((_) => new Future(() => modulesAndLessons));

  return providerHelper;
}

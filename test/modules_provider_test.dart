import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/models/modules_and_lessons.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thepcosprotocol_app/constants/table_names.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'modules_provider_test.mocks.dart';

@GenerateMocks([DatabaseProvider, ProviderHelper, WebServices, FlavorConfig])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('fetchAndSaveData', () {
    test('returns an Album if the http call completes successfully', () async {
      // ////////
      MockDatabaseProvider dbaseProvider = MockDatabaseProvider();
      sqfliteFfiInit();
      Database database =
          await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
      // await database.execute(databaseRules);
      dbaseProvider.db = database;

      when(dbaseProvider.db).thenReturn(database);

      // Map<String, Object?>? map = new Map<String, Object?>();
      List<Map<String, Object?>>? list = [];
      // list.add(map);
      when(dbaseProvider.getDataQuery("Module", null))
          .thenAnswer((_) => new Future(() => list));

      when(dbaseProvider.getDataQuery("Module", ""))
          .thenAnswer((_) => new Future(() => list));

      when(dbaseProvider.getDataQuery("Wiki", ""))
          .thenAnswer((_) => new Future(() => list));

      when(dbaseProvider.getData('Wiki', '', false, false, false))
          .thenAnswer((_) => new Future(() => list));

      List<Question> questionsList = [];

      MockProviderHelper providerHelper = MockProviderHelper();
      when(providerHelper.fetchAndSaveQuestions(
              dbaseProvider, TABLE_WIKI, TABLE_WIKI))
          .thenAnswer((_) => new Future(() => questionsList));

      ModulesAndLessons modulesAndLessons = ModulesAndLessons(
          lessonContent: [],
          lessonQuizzes: [],
          lessonRecipes: [],
          lessonTasks: [],
          lessonWikis: [],
          lessons: [],
          modules: []);

      DateTime nextLessonAvailableDate =
          DateTime.parse("2022-08-31 22:34:13.708643");
      when(providerHelper.fetchAndSaveModuleExport(
              dbaseProvider, true, nextLessonAvailableDate))
          .thenAnswer((_) => new Future(() => modulesAndLessons));

      ModulesProvider modulesProvider =
          ModulesProvider(dbProvider: dbaseProvider);
      modulesProvider.providerHelper = providerHelper;

      await modulesProvider.fetchAndSaveData(true);
      print(
          "currentModuleLessons.length:: ${modulesProvider.currentModuleLessons.length}");
      expect(modulesProvider.loadingStatus, LoadingStatus.success, reason: "should be success");
    });
  });
}

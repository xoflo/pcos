import 'dart:convert';
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
import 'dart:io';

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

      var input = await File("test_resources/Questions.json").readAsString();

      List<dynamic> questionsDynamicList = jsonDecode(input);
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

      // List<Question> questionsList = [];
      Question question1 = Question(
          id: 255,
          reference: "fc979cab-9c63-4374-8b39-7168eaa295d4",
          question:
              "What are some insulin and gluten-friendly pantry staples I should\ngrab?",
          answer:
              " Here are some ideas. <br>\n<br>\n<i>Please note this is NOT an “allowed” food list and there is\nabsolutely no requirement to purchase all of these foods. We want\nyou to be as flexible as possible! </i><br>\n<br>\nHere is a list of some real whole foods, to give you an idea of\ngreat foods to make your meals from. This is not an exhaustive list\n– it simply provides some ideas to help you get started.<br>\n<br>\n<b>Nuts (raw)</b> - almonds, cashews, Brazil nuts, walnuts, pecans,\npistachios, macadamias, hazelnuts <br>\n<br>\n<b>Nut butter </b>- made from 100% nuts (no added sugar or oil)<br>\n<br>\n<b>Naturally gluten free whole grains </b>- quinoa, millet,\namaranth, polenta, buckwheat groats, rice (red, brown, black,\nbasmati)<br>\n<br>\n<b>Seeds </b>- sunflower, pumpkin (pepitas), flax (linseeds), chia,\nhemp, sesame, tahini (sesame seed paste)<br>\n<br>\n<b>Legumes/Pulses</b> - lentils (red, brown, Puy) green or yellow\nsplit peas, chickpeas, beans (cannellini, adzuki, black, red kidney,\npinto, butter) <br>\n<br>\n<b>Oils </b>- extra virgin olive oil (EVOO), avocado oil,\nsesame/peanut oil, coconut oil, macadamia oil, ghee (if you tolerate\ndairy foods) - if possible, opt for the freshest and highest quality\noils you can afford <br>\n<br>\n<b>Vinegars</b> - apple cider, balsamic, red/white wine, rice wine <br>\n<br>\n<b>Mustards</b> - dijon, hot <br>\n<br>\n<b>Flavourings</b> - iodised salt (sea salt, Himalayan pink rock),\npepper (black, white, cayenne), seeds (cumin, caraway, mustard,\nfennel), powdered spices (garam masala, curry powder, turmeric,\nsweet/smoked paprika, nutmeg, cinnamon), dried herbs (oregano,\nbasil, thyme, rosemary), cocoa/cacao powder, cacao nibs, nutritional\nyeast flakes (for cheesy flavoring)<br>\n<br>\n<b>Other packaged goods (these are minimally processed): </b><br>\n<ul>\n<li><b>Coconut:</b> desiccated coconut (preservative-free),\ncoconut milk, coconut yogurt (please check the label and be\nmindful of avoiding additives), coconut cream</li>\n<li><b>Unsweetened dairy-free milks: </b>rice, almond, coconut\n(drinking variety), cashew, macadamia - be sure to check the\nlabels and be mindful of avoiding additives, or better yet, make\nyour own </li>\n<li><b>Additional: </b>Tamari (wheat-free soy sauce), tomato\npassata (opt for no added sugar or oil), canned tomatoes,\nunpasteurized brown rice miso paste, stevia granules, raw honey,\ngood quality gluten-free bread (please check the label to ensure\nit contains ‘real food’ ingredients and be mindful of avoiding\nadditives)</li>\n</ul>",
          tags: "",
          isFavorite: false);

      MockProviderHelper providerHelper = MockProviderHelper();
      // when(providerHelper.fetchAndSaveQuestions(
      //         dbaseProvider, TABLE_WIKI, TABLE_WIKI))
      //     .thenAnswer((_) => new Future(() => questionsList));

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
      expect(modulesProvider.loadingStatus, LoadingStatus.success,
          reason: "should be success");
    });
  });
}

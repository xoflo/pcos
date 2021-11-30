import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/models/modules_and_lessons.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class ModulesProvider with ChangeNotifier {
  final DatabaseProvider dbProvider;

  ModulesProvider({@required this.dbProvider}) {
    if (dbProvider != null) fetchAndSaveData(false);
  }

  LoadingStatus status = LoadingStatus.empty;
  LoadingStatus searchStatus = LoadingStatus.empty;

  List<Module> _modules = [];
  List<Lesson> _lessons = [];
  List<LessonContent> _lessonContent = [];
  List<LessonTask> _lessonTasks = [];
  List<LessonWiki> _lessonWikis = [];
  List<LessonRecipe> _lessonRecipes = [];

  Module _currentModule;
  List<Module> _previousModules = [];
  List<Lesson> _currentModuleLessons = [];
  Lesson _currentLesson;
  List<LessonTask> _displayLessonTasks = [];
  List<Lesson> _favouriteLessons = [];
  List<Lesson> _favouriteToolkitLessons = [];
  List<LessonWiki> _favouriteLessonWikis = [];
  List<Lesson> _searchLessons = [];
  List<LessonWiki> _initialLessonWikis = [];
  List<LessonRecipe> _initialLessonRecipes = [];
  List<bool> _initialLessonWikiFavourites = [];

  Module get currentModule => _currentModule;
  Lesson get currentLesson => _currentLesson;
  List<Lesson> get currentModuleLessons => [..._currentModuleLessons];
  List<Module> get allModules => [..._modules];
  List<Module> get previousModules => [..._previousModules];
  List<Lesson> get favouriteLessons => [..._favouriteLessons];
  List<Lesson> get favouriteToolkitLessons => [..._favouriteToolkitLessons];
  List<LessonWiki> get favouriteLessonWikis => [..._favouriteLessonWikis];
  List<LessonTask> get displayLessonTasks => [..._displayLessonTasks];
  List<Lesson> get searchLessons => [..._searchLessons];
  List<LessonWiki> get initialLessonWikis => [..._initialLessonWikis];
  List<LessonRecipe> get initialLessonRecipes => [..._initialLessonRecipes];
  List<bool> get initialLessonWikiFavourites =>
      [..._initialLessonWikiFavourites];

  Future<void> fetchAndSaveData(final bool forceRefresh) async {
    status = LoadingStatus.loading;
    notifyListeners();
    final String nextLessonAvailableDateString = await PreferencesController()
        .getString(SharedPreferencesKeys.NEXT_LESSON_AVAILABLE_DATE);
    DateTime nextLessonAvailableDate =
        DateTime.now().add(const Duration(minutes: -1));
    if (nextLessonAvailableDateString.length > 0) {
      nextLessonAvailableDate = DateTime.parse(nextLessonAvailableDateString);
    }
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      final ModulesAndLessons modulesAndLessons = await ProviderHelper()
          .fetchAndSaveModuleExport(
              dbProvider, forceRefresh, nextLessonAvailableDate);
      _modules = modulesAndLessons.modules;
      _lessons = modulesAndLessons.lessons;
      _lessonContent = modulesAndLessons.lessonContent;
      _lessonTasks = modulesAndLessons.lessonTasks;
      _lessonWikis = modulesAndLessons.lessonWikis;
      _lessonRecipes = modulesAndLessons.lessonRecipes;

      _currentModule = _modules.last;
      _previousModules = await _getPreviousModules();
      _currentModuleLessons = await getModuleLessons(_currentModule.moduleID);
      _currentLesson = _currentModuleLessons.last;
      //display the past lesson tasks not completed, and the current lesson if the lesson is complete
      _displayLessonTasks.clear();
      for (LessonTask lessonTask in _lessonTasks) {
        if (lessonTask.lessonID == currentLesson.lessonID) {
          if (currentLesson.isComplete) {
            _displayLessonTasks.add(lessonTask);
          }
        } else {
          _displayLessonTasks.add(lessonTask);
        }
      }
      //set initial lesson wikis & recipes to display on dashboard when it loads
      if (_initialLessonWikis.length == 0) {
        for (LessonWiki lessonWiki in _lessonWikis) {
          if (lessonWiki.lessonId == currentLesson.lessonID) {
            _initialLessonWikis.add(lessonWiki);
            _initialLessonWikiFavourites.add(lessonWiki.isFavorite);
          }
        }
      }
      if (_initialLessonRecipes.length == 0) {
        for (LessonRecipe lessonRecipe in _lessonRecipes) {
          if (lessonRecipe.lessonId == currentLesson.lessonID) {
            _initialLessonRecipes.add(lessonRecipe);
          }
        }
      }

      await _refreshFavourites();
    }

    status = _modules.isEmpty || _lessons.isEmpty || _lessonContent.isEmpty
        ? LoadingStatus.empty
        : LoadingStatus.success;
    notifyListeners();
  }

  Future<List<Lesson>> getModuleLessons(final int moduleID) async {
    List<Lesson> moduleLessons = [];
    for (Lesson lesson in _lessons) {
      if (lesson.moduleID == moduleID) {
        moduleLessons.add(lesson);
      }
    }
    return moduleLessons;
  }

  String getModuleTitleByModuleID(final int moduleID) {
    for (Module module in _modules) {
      if (module.moduleID == moduleID) {
        return module.title;
      }
    }
    return "";
  }

  Future<List<LessonTask>> getLessonTasks(final int lessonID) async {
    List<LessonTask> lessonTasks = [];
    for (LessonTask lessonTask in _lessonTasks) {
      if (lessonTask.lessonID == lessonID) {
        lessonTasks.add(lessonTask);
      }
    }
    return lessonTasks;
  }

  Future<List<LessonContent>> getLessonContent(final int lessonID) async {
    List<LessonContent> lessonContent = [];
    for (LessonContent content in _lessonContent) {
      if (content.lessonID == lessonID) {
        lessonContent.add(content);
      }
    }
    return lessonContent;
  }

  List<LessonWiki> getLessonWikis(final int lessonID) {
    List<LessonWiki> displayLessonWikis = [];
    for (LessonWiki lessonWiki in _lessonWikis) {
      if (lessonWiki.lessonId == lessonID) {
        displayLessonWikis.add(lessonWiki);
      }
    }
    return displayLessonWikis;
  }

  Future<List<LessonWiki>> searchLessonWikis(
      final int moduleID, final String searchText) async {
    List<LessonWiki> searchLessonWikis = [];
    List<int> questionIDs = [];
    for (LessonWiki lessonWiki in _lessonWikis) {
      if ((lessonWiki.moduleId == moduleID || moduleID == 0) &&
          (lessonWiki.question
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              searchText.length == 0)) {
        //check if this question has already been added
        if (!questionIDs.contains(lessonWiki.questionId)) {
          searchLessonWikis.add(lessonWiki);
          questionIDs.add(lessonWiki.questionId);
        }
      }
    }
    return searchLessonWikis;
  }

  List<LessonRecipe> getLessonRecipes(final int lessonID) {
    List<LessonRecipe> displayLessonRecipes = [];
    for (LessonRecipe lessonRecipe in _lessonRecipes) {
      if (lessonRecipe.lessonId == lessonID) {
        displayLessonRecipes.add(lessonRecipe);
      }
    }
    return displayLessonRecipes;
  }

  bool getLessonFavourite(final int lessonID) {
    for (Lesson lesson in _lessons) {
      if (lesson.lessonID == lessonID) {
        return lesson.isFavorite;
      }
    }
    return false;
  }

  bool getLessonWikiFavourite(final int questionID, final int lessonID) {
    for (LessonWiki lessonWiki in _lessonWikis) {
      if (lessonWiki.lessonId == lessonID &&
          lessonWiki.questionId == questionID) {
        return lessonWiki.isFavorite;
      }
    }
    return false;
  }

  Future<void> setLessonAsComplete(final int lessonID, final int moduleID,
      final bool setModuleComplete) async {
    final DateTime nextLessonAvailable =
        await WebServices().setLessonComplete(lessonID);
    await PreferencesController().saveString(
        SharedPreferencesKeys.NEXT_LESSON_AVAILABLE_DATE,
        nextLessonAvailable.toIso8601String());
    if (setModuleComplete) {
      await WebServices().setModuleComplete(moduleID);
    }
    //refresh the data from the API
    fetchAndSaveData(true);
  }

  Future<void> setTaskAsComplete(final int taskID, final String value) async {
    final bool markTaskComplete =
        await ProviderHelper().markTaskAsCompleted(dbProvider, taskID, value);
    if (markTaskComplete) {
      _lessonTasks.removeWhere((task) => task.lessonTaskID == taskID);
      _displayLessonTasks.removeWhere((task) => task.lessonTaskID == taskID);
    }
    notifyListeners();
  }

  Future<void> addLessonToFavourites(
      final dynamic lesson, final bool add, final bool refreshData) async {
    if (dbProvider.db != null) {
      await ProviderHelper()
          .addToFavourites(add, dbProvider, FavouriteType.Lesson, lesson);
      if (refreshData) {
        await fetchAndSaveData(false);
      } else {
        for (int lessonCounter = 0;
            lessonCounter < _lessons.length;
            lessonCounter++) {
          if (_lessons[lessonCounter].lessonID == lesson.lessonID) {
            _lessons[lessonCounter].isFavorite = !lesson.isFavorite;
          }
        }
      }
    }
  }

  Future<void> addWikiToFavourites(final dynamic wiki, final bool add) async {
    debugPrint("addWikiToFaves add=$add");
    if (dbProvider.db != null) {
      LessonWiki lessonWiki = wiki;
      debugPrint("wiki faves count before= ${_favouriteLessonWikis.length}");
      await ProviderHelper()
          .addToFavourites(add, dbProvider, FavouriteType.Wiki, wiki);
      //update the wiki in memory to reflect in app heart icons on Dashboard
      debugPrint(
          "modules provider update wiki fave in memory for qid=${lessonWiki.questionId}");
      for (int wikiCounter = 0;
          wikiCounter < _lessonWikis.length;
          wikiCounter++) {
        debugPrint(
            "LOOPING checking qid = ${_lessonWikis[wikiCounter].questionId}");
        if (_lessonWikis[wikiCounter].questionId == lessonWiki.questionId) {
          debugPrint("FOUND IT, NOW UPDATE IT");
          debugPrint(
              "UPDATE QUESTION = ${_lessonWikis[wikiCounter].question} to ${!lessonWiki.isFavorite}");
          debugPrint(
              "WIKI qid=${lessonWiki.questionId} lid=${lessonWiki.lessonId} mid=${lessonWiki.moduleId} ref=${lessonWiki.reference} q=${lessonWiki.question} a=${lessonWiki.answer} t=${lessonWiki.tags} isfave=${lessonWiki.isFavorite} islong=${lessonWiki.isLongAnswer}");
          _lessonWikis[wikiCounter].isFavorite = !lessonWiki.isFavorite;
          debugPrint(
              "AFTER UPDATE isFAVE in list=${_lessonWikis[wikiCounter].isFavorite}");
          debugPrint("wiki faves count after= ${_favouriteLessonWikis.length}");
          break;
        }
      }
    }
    notifyListeners();
  }

  Future<void> _refreshFavourites() async {
    _favouriteLessons.clear();
    _favouriteToolkitLessons.clear();
    for (Lesson lesson in _lessons) {
      if (lesson.isFavorite) {
        if (lesson.isToolkit) {
          _favouriteToolkitLessons.add(lesson);
        } else {
          _favouriteLessons.add(lesson);
        }
      }
    }
    _favouriteLessonWikis.clear();
    for (LessonWiki lessonWiki in _lessonWikis) {
      if (lessonWiki.isFavorite) {
        _favouriteLessonWikis.add(lessonWiki);
      }
    }
  }

  Future<List<Module>> _getPreviousModules() async {
    List<Module> modules = [];
    for (Module module in _modules) {
      if (module.moduleID != _currentModule.moduleID) {
        modules.add(module);
      }
    }
    return modules;
  }

  Future<void> filterAndSearch(final String searchText) async {
    searchStatus = LoadingStatus.loading;
    notifyListeners();
    if (dbProvider.db != null) {
      _searchLessons = await ProviderHelper()
          .filterAndSearch(dbProvider, "Lesson", searchText, "", []);
      await _refreshFavourites();
    }
    searchStatus =
        _searchLessons.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    notifyListeners();
  }

  Future<void> clearSearch() async {
    _searchLessons.clear();
    searchStatus = LoadingStatus.empty;
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/models/modules_and_lessons.dart';
import 'package:thepcosprotocol_app/models/quiz.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class ModulesProvider with ChangeNotifier {
  final DatabaseProvider? dbProvider;

  ModulesProvider({required this.dbProvider}) {
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
  List<Quiz> _lessonQuizzes = [];

  late Module _currentModule;
  List<Module> _previousModules = [];
  List<Lesson> _currentModuleLessons = [];
  Lesson? _currentLesson;
  List<LessonTask> _displayLessonTasks = [];
  List<Lesson> _searchLessons = [];
  List<LessonWiki> _initialLessonWikis = [];
  List<LessonRecipe> _initialLessonRecipes = [];

  Module? get currentModule => _currentModule;
  Lesson? get currentLesson => _currentLesson;
  List<Lesson> get currentModuleLessons => [..._currentModuleLessons];
  List<Module> get allModules => [..._modules];
  List<Module> get previousModules => [..._previousModules];
  List<LessonTask> get displayLessonTasks => [..._displayLessonTasks];
  List<Lesson> get searchLessons => [..._searchLessons];
  List<LessonWiki> get initialLessonWikis => [..._initialLessonWikis];
  List<LessonRecipe> get initialLessonRecipes => [..._initialLessonRecipes];
  List<Quiz> get lessonQuizzes => [..._lessonQuizzes];
  List<LessonWiki> get lessonWikis => [..._lessonWikis];

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
    if (dbProvider?.db != null) {
      //first get the data from the api if we have no data yet
      final ModulesAndLessons modulesAndLessons = await ProviderHelper()
          .fetchAndSaveModuleExport(
              dbProvider, forceRefresh, nextLessonAvailableDate);
      _modules = modulesAndLessons.modules ?? [];
      _lessons = modulesAndLessons.lessons ?? [];
      _lessonContent = modulesAndLessons.lessonContent ?? [];
      _lessonTasks = modulesAndLessons.lessonTasks ?? [];
      _lessonWikis = modulesAndLessons.lessonWikis ?? [];
      _lessonRecipes = modulesAndLessons.lessonRecipes ?? [];
      _lessonQuizzes = modulesAndLessons.lessonQuizzes ?? [];

      if (_modules.length > 0) {
        _currentModule = _modules.last;
        _previousModules = await _getPreviousModules();
        _currentModuleLessons = getModuleLessons(_currentModule.moduleID);
        _currentLesson = _currentModuleLessons.last;
      }

      //display the past lesson tasks not completed, and the current lesson if the lesson is complete
      _displayLessonTasks.clear();
      for (LessonTask lessonTask in _lessonTasks) {
        if (lessonTask.lessonID == currentLesson?.lessonID) {
          if (currentLesson?.isComplete == true) {
            _displayLessonTasks.add(lessonTask);
          }
        } else {
          _displayLessonTasks.add(lessonTask);
        }
      }
      //set initial lesson wikis & recipes to display on dashboard when it loads
      if (_initialLessonWikis.length == 0) {
        for (LessonWiki lessonWiki in _lessonWikis) {
          if (currentLesson != null) {
            if (lessonWiki.lessonId == currentLesson?.lessonID) {
              _initialLessonWikis.add(lessonWiki);
            }
          }
        }
      }
      if (_initialLessonRecipes.length == 0) {
        for (LessonRecipe lessonRecipe in _lessonRecipes) {
          if (currentLesson != null) {
            if (lessonRecipe.lessonId == currentLesson?.lessonID) {
              _initialLessonRecipes.add(lessonRecipe);
            }
          }
        }
      }
    }

    status = _modules.isEmpty || _lessons.isEmpty || _lessonContent.isEmpty
        ? LoadingStatus.empty
        : LoadingStatus.success;
    notifyListeners();
  }

  List<Lesson> getModuleLessons(final int? moduleID) {
    List<Lesson> moduleLessons = [];
    for (Lesson lesson in _lessons) {
      if (lesson.moduleID == moduleID) {
        moduleLessons.add(lesson);
      }
    }
    return moduleLessons;
  }

  List<LessonWiki> getModuleWikis(final int? moduleID) {
    List<LessonWiki> moduleWikis = [];
    for (LessonWiki wiki in _lessonWikis) {
      if (wiki.moduleId == moduleID) {
        moduleWikis.add(wiki);
      }
    }
    return moduleWikis;
  }

  String getModuleTitleByModuleID(final int moduleID) {
    Module? moduleFound = _modules.firstWhereOrNull(
      (module) => module.moduleID == moduleID,
    );
    if (moduleFound != null) {
      return moduleFound.title ?? "";
    }
    return "";
  }

  String getLessonTitleByLessonID(final int lessonID) {
    Lesson? lessonFound = _lessons.firstWhereOrNull(
      (lesson) => lesson.lessonID == lessonID,
    );
    if (lessonFound != null) {
      return lessonFound.title;
    }
    return "";
  }

  String getLessonTitleByQuestionID(final int questionId) {
    for (LessonWiki wiki in _lessonWikis) {
      if (wiki.questionId == questionId) {
        return getLessonTitleByLessonID(wiki.lessonId ?? -1);
      }
    }
    return "";
  }

  List<LessonTask> getLessonTasks(final int lessonID) {
    List<LessonTask> lessonTasks = [];
    for (LessonTask lessonTask in _lessonTasks) {
      if (lessonTask.lessonID == lessonID) {
        lessonTasks.add(lessonTask);
      }
    }
    return lessonTasks;
  }

  List<LessonContent> getLessonContent(final int lessonID) {
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
          ((lessonWiki.question ?? "")
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              searchText.length == 0)) {
        //check if this question has already been added
        if (!questionIDs.contains(lessonWiki.questionId)) {
          searchLessonWikis.add(lessonWiki);
          questionIDs.add(lessonWiki.questionId ?? -1);
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

  Future<void> setLessonAsComplete(final int lessonID, final int moduleID,
      final bool setModuleComplete) async {
    status = LoadingStatus.loading;
    notifyListeners();
    final DateTime nextLessonAvailable =
        await WebServices().setLessonComplete(lessonID);
    await PreferencesController().saveString(
        SharedPreferencesKeys.NEXT_LESSON_AVAILABLE_DATE,
        nextLessonAvailable.toIso8601String());
    if (setModuleComplete) {
      await WebServices().setModuleComplete(moduleID);
    }
    status = LoadingStatus.success;
    notifyListeners();
    //refresh the data from the API
    fetchAndSaveData(true);
  }

  Future<void> setTaskAsComplete(final int? taskID, final String value) async {
    status = LoadingStatus.loading;
    notifyListeners();
    final bool markTaskComplete =
        await ProviderHelper().markTaskAsCompleted(dbProvider, taskID, value);
    if (markTaskComplete) {
      _lessonTasks.removeWhere((task) => task.lessonTaskID == taskID);
      _displayLessonTasks.removeWhere((task) => task.lessonTaskID == taskID);
    }
    status = LoadingStatus.success;
    notifyListeners();
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
    if (dbProvider?.db != null) {
      _searchLessons = await ProviderHelper().filterAndSearch(
          dbProvider, "Lesson", searchText, "", []) as List<Lesson>;
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

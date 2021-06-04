import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
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

  Module _currentModule;
  List<Module> _previousModules = [];
  List<Lesson> _currentModuleLessons = [];
  Lesson _currentLesson;
  List<LessonTask> _displayLessonTasks = [];
  List<Lesson> _favouriteLessons = [];
  List<Lesson> _searchLessons = [];

  Module get currentModule => _currentModule;
  Lesson get currentLesson => _currentLesson;
  List<Lesson> get currentModuleLessons => [..._currentModuleLessons];
  List<Module> get previousModules => [..._previousModules];
  List<Lesson> get favouriteLessons => [..._favouriteLessons];
  List<LessonTask> get displayLessonTasks => [..._displayLessonTasks];
  List<Lesson> get searchLessons => [..._searchLessons];

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

  Future<void> addToFavourites(final dynamic lesson, final bool add) async {
    if (dbProvider.db != null) {
      await ProviderHelper()
          .addToFavourites(add, dbProvider, FavouriteType.Lesson, lesson);
      fetchAndSaveData(false);
    }
  }

  Future<void> _refreshFavourites() async {
    _favouriteLessons.clear();
    for (Lesson lesson in _lessons) {
      if (lesson.isFavorite) {
        _favouriteLessons.add(lesson);
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

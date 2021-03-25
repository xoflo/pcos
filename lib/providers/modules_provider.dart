import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';

class ModulesProvider with ChangeNotifier {
  final DatabaseProvider dbProvider;

  ModulesProvider({@required this.dbProvider}) {
    if (dbProvider != null) _fetchAndSaveData(false);
  }

  final String moduleTableName = "Module";
  final String lessonTableName = "Lesson";

  Module _currentModule;
  List<Lesson> _currentModuleLessons = [];
  List<Module> _previousModules = [];
  List<Module> _modules = [];
  List<Lesson> _lessons = [];
  List<Lesson> _favourites = [];
  List<LessonTask> _lessonTasks = [];
  LoadingStatus status = LoadingStatus.empty;
  List<Module> get modules => [..._modules];
  List<Module> get previousModules => [..._previousModules];
  List<Lesson> get lessons => [..._lessons];
  List<Lesson> get favourites => [..._favourites];
  Module get currentModule => _currentModule;
  List<Lesson> get currentModuleLessons => [..._currentModuleLessons];
  List<LessonTask> get currentLessonTasks {
    List<LessonTask> tasksToDisplay = [];
    debugPrint(
        "****** _currentModuleLessons.length = ${_currentModuleLessons.length}");
    //TODO: need to check isComplete for this lesson, if not then don't show task
    if (_currentModuleLessons.length > 0 && true) {
      //_currentModuleLessons[_currentModuleLessons.length - 1].isComplete) {
      debugPrint("***** _lessonTasks.length = ${_lessonTasks.length}");
      for (LessonTask task in _lessonTasks) {
        tasksToDisplay.add(task);
      }
    }

    return tasksToDisplay;
  }

  Future<void> _fetchAndSaveData(final bool forceRefresh) async {
    status = LoadingStatus.loading;
    notifyListeners();
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      _modules =
          await ProviderHelper().fetchAndSaveModules(dbProvider, forceRefresh);
      _lessons =
          await ProviderHelper().fetchAndSaveLessons(dbProvider, forceRefresh);
      //TODO check this, needs to be getting the lessonID of the lesson being displayed last for the current module
      final int lessonIDForTasks = _lessons[_lessons.length - 1].lessonID;
      _lessonTasks = await ProviderHelper()
          .fetchAndSaveTasks(dbProvider, lessonIDForTasks, forceRefresh);
      await _refreshFavourites();
      debugPrint("MODULES IN FETCH&SAVE = ${_modules.length}");
      if (_modules.length > 0) {
        await _setCurrentModule();
        await _setCurrentModuleLessons();
        if (_modules.length > 1) {
          await _setPreviousModules();
        }
      }
    }

    status = _modules.isEmpty || _lessons.isEmpty
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

  Future<void> setLessonAsComplete(final int lessonID, final int moduleID,
      final bool setModuleComplete) async {
    await WebServices().setLessonComplete(lessonID);
    if (setModuleComplete) {
      await WebServices().setModuleComplete(moduleID);
    }
    //refresh the data from the API
    _fetchAndSaveData(true);
  }

  //TODO: Add to favourites when field is available
  Future<void> _refreshFavourites() async {
    _favourites.clear();
    for (Lesson lesson in _lessons) {
      //if (lesson.isFavorite) {
      _favourites.add(lesson);
      //}
    }
  }

  Future<void> _setCurrentModule() async {
    _currentModule = _modules[_modules.length - 1];
  }

  Future<void> _setCurrentModuleLessons() async {
    _currentModuleLessons.clear();
    debugPrint("TOTAL LESSONS = ${_lessons.length}");
    for (Lesson lesson in _lessons) {
      debugPrint("_currentModule.moduleID = ${_currentModule.moduleID}");
      debugPrint("_currentModule.title = ${_currentModule.title}");
      debugPrint("modules ids ${_currentModule.moduleID} = ${lesson.moduleID}");
      debugPrint("this lesson.lessonId = ${lesson.lessonID}");
      if (lesson.moduleID == _currentModule.moduleID) {
        debugPrint("ADD LESSON TO CURRENT MODULE LESSONS");
        _currentModuleLessons.add(lesson);
      }
    }
  }

  Future<void> _setPreviousModules() async {
    _previousModules.clear();
    for (Module module in _modules) {
      if (module.moduleID != _currentModule.moduleID) {
        _previousModules.add(module);
      }
    }
  }
}

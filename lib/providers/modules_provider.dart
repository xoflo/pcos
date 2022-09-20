import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/models/modules_and_lessons.dart';
import 'package:thepcosprotocol_app/models/quiz.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/providers/loading_status_notifier.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class ModulesProvider extends LoadingStatusNotifier {
  DatabaseProvider? dbProvider;
  late PreferencesController preferencesController;
  late ProviderHelper providerHelper;
  late WebServices webServices;

  ModulesProvider({required this.dbProvider}) {
    preferencesController = PreferencesController();
    providerHelper = ProviderHelper();
    webServices = WebServices();
  }

  List<Module> _modules = [];
  List<Lesson> _lessons = [];
  List<LessonContent> _lessonContent = [];
  List<LessonTask> _lessonTasks = [];
  List<LessonWiki> _lessonWikis = [];
  List<LessonRecipe> _lessonRecipes = [];
  List<Quiz> _lessonQuizzes = [];

  Module? _currentModule;
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
  List<LessonTask> get lessonTasks => [..._lessonTasks];

  Future<void> fetchAndSaveData(final bool forceRefresh) async {
    setLoadingStatus(LoadingStatus.loading, false);

    final String nextLessonAvailableDateString = await preferencesController
        .getString(SharedPreferencesKeys.NEXT_LESSON_AVAILABLE_DATE);
    DateTime nextLessonAvailableDate =
        DateTime.now().add(const Duration(minutes: -1));
    if (nextLessonAvailableDateString.length > 0) {
      nextLessonAvailableDate = DateTime.parse(nextLessonAvailableDateString);
    }
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)

    if (dbProvider?.db == null) {
      await dbProvider?.init();
    }

    //first get the data from the api if we have no data yet
    ModulesAndLessons modulesAndLessons = ModulesAndLessons();
    try {
      modulesAndLessons = await providerHelper.fetchAndSaveModuleExport(
          dbProvider, forceRefresh, nextLessonAvailableDate);
    } catch (e) {
      setLoadingStatus(LoadingStatus.failed, true);
      return;
    }

    _modules = modulesAndLessons.modules ?? [];
    _lessons = modulesAndLessons.lessons ?? [];
    _lessonContent = modulesAndLessons.lessonContent ?? [];
    _lessonWikis = modulesAndLessons.lessonWikis ?? [];
    _lessonRecipes = modulesAndLessons.lessonRecipes ?? [];
    _lessonQuizzes = modulesAndLessons.lessonQuizzes ?? [];

    _currentModule = null;
    _previousModules = [];
    _currentModuleLessons = [];
    _currentLesson = null;

    if (_modules.length > 0) {
      _currentModule = _modules.last;
      _previousModules = await _getPreviousModules();
      _currentModuleLessons = getModuleLessons(_currentModule?.moduleID);
      _currentLesson = _currentModuleLessons.firstWhere(
        (element) =>
            !element.isComplete ||
            getQuizByLessonID(element.lessonID)?.isComplete == false,
        orElse: () => _currentModuleLessons.last,
      );
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

    setLoadingStatus(
        _modules.isEmpty || _lessons.isEmpty || _lessonContent.isEmpty
            ? LoadingStatus.empty
            : LoadingStatus.success,
        true);
  }

  List<Lesson> getModuleLessons(final int? moduleID) {
    List<Lesson> moduleLessons = [];
    for (Lesson lesson in _lessons) {
      if (lesson.moduleID == moduleID) {
        moduleLessons.add(lesson);
      }
    }
    moduleLessons.sort();
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
      return moduleFound.title;
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

  List<LessonContent> getLessonContent(final int lessonID) {
    List<LessonContent> lessonContent = [];
    for (LessonContent content in _lessonContent) {
      if (content.lessonID == lessonID) {
        lessonContent.add(content);
      }
    }
    lessonContent.sort();
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

  Quiz? getQuizByLessonID(final int lessonID) {
    for (Quiz quiz in _lessonQuizzes) {
      if (quiz.lessonID == lessonID) {
        return quiz;
      }
    }
    return null;
  }

  Future<void> setLessonAsComplete(final int lessonID, final int moduleID,
      final bool setModuleComplete) async {
    setLoadingStatus(LoadingStatus.loading, true);

    final DateTime nextLessonAvailable =
        await WebServices().setLessonComplete(lessonID);
    await PreferencesController().saveString(
        SharedPreferencesKeys.NEXT_LESSON_AVAILABLE_DATE,
        nextLessonAvailable.toIso8601String());
    if (setModuleComplete) {
      await WebServices().setModuleComplete(moduleID);
    }

    setLoadingStatus(LoadingStatus.success, true);

    await fetchAndSaveData(true);
  }

  Future<void> fetchLessonTasks(final int lessonID) async {
    _lessonTasks.clear();
    setLoadingStatus(LoadingStatus.loading, false);

    if (dbProvider?.db != null) {
      //first get the data from the api if we have no data yet
      List<LessonTask> lessonTasks = [];
      try {
        lessonTasks = await ProviderHelper()
            .fetchAndSaveTaskForLesson(dbProvider, lessonID: lessonID);
      } catch (e) {
        setLoadingStatus(LoadingStatus.failed, true);
        return;
      }

      lessonTasks.sort();
      _lessonTasks = lessonTasks;

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

      setLoadingStatus(LoadingStatus.success, true);
    }
  }

  Future<void> setTaskAsComplete(final int? taskID,
      {final String? value,
      final int? lessonID,
      final bool? forceRefresh}) async {
    setLoadingStatus(LoadingStatus.loading, true);

    await ProviderHelper().markTaskAsCompleted(dbProvider, taskID, value ?? "");

    if (lessonID != null) {
      await fetchLessonTasks(lessonID);
    }
    if (forceRefresh != null) {
      await fetchAndSaveData(forceRefresh);
    }

    setLoadingStatus(LoadingStatus.success, true);
  }

  Future<List<Module>> _getPreviousModules() async {
    List<Module> modules = [];
    for (Module module in _modules) {
      if (module.moduleID != _currentModule?.moduleID) {
        modules.add(module);
      }
    }
    return modules;
  }

  Future<void> filterAndSearch(final String searchText) async {
    setLoadingStatus(LoadingStatus.loading, false);

    if (dbProvider?.db != null) {
      _searchLessons = await ProviderHelper().filterAndSearch(
          dbProvider, "Lesson", searchText, "", []) as List<Lesson>;
    }

    setLoadingStatus(
        _searchLessons.isEmpty ? LoadingStatus.empty : LoadingStatus.success,
        true);
  }

  Future<void> clearSearch() async {
    _searchLessons.clear();
    setLoadingStatus(LoadingStatus.empty, true);
  }
}

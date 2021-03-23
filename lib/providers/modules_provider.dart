import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class ModulesProvider with ChangeNotifier {
  final DatabaseProvider dbProvider;

  ModulesProvider({@required this.dbProvider}) {
    if (dbProvider != null) fetchAndSaveData();
  }

  final String moduleTableName = "Module";
  final String lessonTableName = "Lesson";

  Module _currentModule;
  List<Lesson> _currentModuleLessons = [];
  List<Module> _modules = [];
  List<Lesson> _lessons = [];
  List<Lesson> _favourites = [];
  LoadingStatus status = LoadingStatus.empty;
  List<Module> get modules => [..._modules];
  List<Lesson> get lessons => [..._lessons];
  List<Lesson> get favourites => [..._favourites];
  Module get currentModule => _currentModule;
  List<Lesson> get currentModuleLessons => [..._currentModuleLessons];

  Future<void> fetchAndSaveData() async {
    status = LoadingStatus.loading;
    notifyListeners();
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      _modules = await ProviderHelper().fetchAndSaveModules(dbProvider);
      _lessons = await ProviderHelper().fetchAndSaveLessons(dbProvider);
      await _refreshFavourites();
      debugPrint("MODULES IN FETCH&SAVE = ${_modules.length}");
      if (_modules.length > 0) {
        await _setCurrentModule();
        await _setCurrentModuleLessons();
      }
    }

    status = _modules.isEmpty || _lessons.isEmpty
        ? LoadingStatus.empty
        : LoadingStatus.success;
    notifyListeners();
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
    for (Lesson lesson in _lessons) {
      debugPrint("_currentModule.moduleID = ${_currentModule.moduleID}");
      debugPrint("_currentModule.title = ${_currentModule.title}");
      debugPrint("lesson.moduleId = ${lesson.moduleID}");
      if (lesson.moduleID == _currentModule.moduleID) {
        _currentModuleLessons.add(lesson);
      }
    }
  }
}

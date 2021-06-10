import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class FavouritesProvider with ChangeNotifier {
  final DatabaseProvider dbProvider;

  FavouritesProvider({@required this.dbProvider}) {
    if (dbProvider != null) getDataFromDatabase();
  }

  List<Lesson> _itemsLessons = [];
  LoadingStatus statusLessons = LoadingStatus.empty;

  List<Lesson> get itemsLessons => [..._itemsLessons];

  Future<void> getDataFromDatabase() async {
    statusLessons = LoadingStatus.loading;
    notifyListeners();
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    _itemsLessons = [];

    statusLessons =
        _itemsLessons.isEmpty ? LoadingStatus.empty : LoadingStatus.success;

    notifyListeners();
  }
}

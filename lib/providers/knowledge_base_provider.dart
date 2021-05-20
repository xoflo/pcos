import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';

class KnowledgeBaseProvider with ChangeNotifier {
  final DatabaseProvider dbProvider;

  KnowledgeBaseProvider({@required this.dbProvider}) {
    if (dbProvider != null) fetchAndSaveData();
  }
  final String tableName = "KnowledgeBase";
  List<Question> _items = [];
  List<Question> _favourites = [];
  LoadingStatus status = LoadingStatus.empty;
  List<Question> get items => [..._items];
  List<Question> get favourites => [..._favourites];

  Future<void> fetchAndSaveData() async {
    status = LoadingStatus.loading;
    notifyListeners();
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      _items = await ProviderHelper()
          .fetchAndSaveQuestions(dbProvider, tableName, tableName);
      await refreshFavourites(false, false);
    }

    status = _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    notifyListeners();
  }

  Future<void> filterAndSearch(
      final String searchText, final String tag) async {
    status = LoadingStatus.loading;
    notifyListeners();
    if (dbProvider.db != null) {
      _items = await ProviderHelper()
          .filterAndSearch(dbProvider, tableName, searchText, tag, []);
      await refreshFavourites(false, false);
    }
    status = _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    notifyListeners();
  }

  Future<void> refreshFavourites(
      final bool notify, final bool getItemsFromDB) async {
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      final List<Question> itemsForFaves = getItemsFromDB
          ? await ProviderHelper()
              .fetchAndSaveQuestions(dbProvider, tableName, tableName)
          : _items;
      _favourites.clear();
      for (Question question in itemsForFaves) {
        if (question.isFavorite) {
          _favourites.add(question);
        }
      }
      if (notify) {
        notifyListeners();
      }
    }
  }

  Future<void> addToFavourites(final dynamic question, final bool add) async {
    if (dbProvider.db != null) {
      await ProviderHelper().addToFavourites(
          add, dbProvider, FavouriteType.KnowledgeBase, question);
    }
  }
}

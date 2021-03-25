import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class FAQProvider with ChangeNotifier {
  final DatabaseProvider dbProvider;

  FAQProvider({@required this.dbProvider}) {
    if (dbProvider != null) _fetchAndSaveData();
  }
  final String tableName = "FrequentlyAskedQuestions";
  final String assetType = "FAQ";
  List<Question> _items = [];
  LoadingStatus status = LoadingStatus.empty;
  List<Question> get items => [..._items];

  Future<void> _fetchAndSaveData() async {
    status = LoadingStatus.loading;
    notifyListeners();
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      _items = await ProviderHelper()
          .fetchAndSaveQuestions(dbProvider, tableName, assetType);
    }

    status = _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    notifyListeners();
  }
}

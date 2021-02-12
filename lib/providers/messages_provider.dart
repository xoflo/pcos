import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class MessagesProvider with ChangeNotifier {
  final DatabaseProvider dbProvider;

  MessagesProvider({@required this.dbProvider}) {
    if (dbProvider != null) fetchAndSaveData();
  }

  final String tableName = "Message";
  List<Message> _items = [];
  LoadingStatus status = LoadingStatus.empty;

  List<Message> get items => [..._items];

  Future<void> fetchAndSaveData() async {
    status = LoadingStatus.loading;
    notifyListeners();
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      _items = await ProviderHelper().fetchAndSaveMessages(dbProvider);
    }

    status = _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    notifyListeners();
  }

  Future<void> updateNotificationAsRead(final int notificationId) async {
    await ProviderHelper().markNotificationAsRead(dbProvider, notificationId);
    _items = await ProviderHelper().getAllData(dbProvider, tableName);
    notifyListeners();
  }

  int getUnreadCount() {
    if (_items.isEmpty) return 0;

    int unreadCount = 0;
    _items.forEach((Message message) {
      if (!message.isRead) unreadCount++;
    });
    return unreadCount;
  }
}

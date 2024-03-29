import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/loading_status_notifier.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/global_vars.dart';

class MessagesProvider extends LoadingStatusNotifier {
  final DatabaseProvider? dbProvider;

  MessagesProvider({required this.dbProvider}) {
    if (dbProvider != null) fetchAndSaveData();
  }

  final String tableName = "Message";
  List<Message> _items = [];
  GlobalVars refreshMessages = GlobalVars();

  List<Message> get items => [..._items];

  Future<void> fetchAndSaveData() async {
    setLoadingStatus(LoadingStatus.loading, false);

    final bool refreshFromAPI = refreshMessages.getRefreshMessagesFromAPI();

    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    if (dbProvider?.db != null) {
      //first get the data from the api if we have no data yet
      _items = await ProviderHelper()
          .fetchAndSaveMessages(dbProvider, refreshFromAPI);
    }

    setLoadingStatus(
        _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success, false);

    if (refreshFromAPI) {
      refreshMessages.setRefreshMessagesFromAPI(false);
    }
  }

  Future<void> updateNotificationAsRead(final int? notificationId) async {
    setLoadingStatus(LoadingStatus.loading, true);

    await ProviderHelper().markNotificationAsRead(dbProvider, notificationId);
    _items = await ProviderHelper().getAllData(dbProvider, tableName)
        as List<Message>;

    setLoadingStatus(
        _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success, true);
  }

  Future<void> updateNotificationAsDeleted(final int? notificationId) async {
    await ProviderHelper()
        .markNotificationAsDeleted(dbProvider, notificationId);
    _items = await ProviderHelper().getAllData(dbProvider, tableName)
        as List<Message>;
    setLoadingStatus(
        _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success, true);
  }

  int getUnreadCount() {
    if (_items.isEmpty) return 0;

    int unreadCount = 0;
    _items.forEach((Message message) {
      if (message.isRead == false) unreadCount++;
    });
    return unreadCount;
  }
}



import 'package:thepcosprotocol_app/constants/table_names.dart';

import '../constants/loading_status.dart';
import '../models/workout.dart';
import 'database_provider.dart';
import 'loading_status_notifier.dart';
import 'provider_helper.dart';

class WorkoutsProvider extends LoadingStatusNotifier {
  final DatabaseProvider? dbProvider;

  WorkoutsProvider({required this.dbProvider}) {
    if (dbProvider != null) fetchAndSaveData();
  }

  final String tableName = TABLE_WORKOUT;
  List<Workout> _items = [];

  List<Workout> get items => [..._items];

  Future<void> fetchAndSaveData() async {
    setLoadingStatus(LoadingStatus.loading, false);
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    if (dbProvider?.db != null) {
      //first get the data from the api if we have no data yet
      _items = await ProviderHelper().fetchAndSaveWorkouts(dbProvider);
    }

    setLoadingStatus(
        _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success, false);
  }
}
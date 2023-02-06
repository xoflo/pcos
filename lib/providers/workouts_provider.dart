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
    // if (dbProvider?.db != null) {
    //   //first get the data from the api if we have no data yet
      // _items = await ProviderHelper().fetchAndSaveWorkouts(dbProvider);
    // }

    // FOR TESTING (START)
    List<Workout> workouts = [];
    workouts.add(Workout(
        workoutID: 1,
        title: "Workout#1",
        description: "This is workout number 1",
        imageUrl:
            'https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
            tags: 'Intermediate, Weighted'));
        
    workouts.add(Workout(
        workoutID: 2,
        title: "Workout#2",
        description: "This is workout number 2",
        imageUrl:
            'https://static.nike.com/a/images/f_auto/dpr_3.0,cs_srgb/h_484,c_limit/6326aa72-196f-4d99-8a44-295b8b355d91/how-long-does-your-workout-really-need-to-be.jpg',
            tags: 'Beginner, Bodyweight'));

    workouts.add(Workout(
        workoutID: 3,
        title: "Workout#3",
        description: "This is workout number 3",
        imageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
            tags: 'Beginner, Pregnancy friendly'));

    workouts.forEach((Workout workout) async {
          await dbProvider?.insert(TABLE_WORKOUT, {
            'workoutID': workout.workoutID,
            'title': workout.title,
            'description': workout.description,
            'tags': workout.tags,
            'minsToComplete': workout.minsToComplete,
            'orderIndex': workout.orderIndex,
            'imageUrl': workout.imageUrl,
            'isFavorite': (workout.isFavorite ?? false) ? 1 : 0,
            'isComplete': (workout.isComplete ?? false) ? 1 : 0,
          });
        });

    _items = workouts;
    // FOR TESTING (END)

    setLoadingStatus(
        _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success, false);
  }

  Future<void> filterAndSearch(final String searchText, final String tag,
      final List<String> secondaryTags) async {
    setLoadingStatus(LoadingStatus.loading, true);
    if (dbProvider?.db != null) {
      _items = await ProviderHelper().filterAndSearch(
              dbProvider, tableName, searchText, tag, secondaryTags)
          as List<Workout>;
    }
    setLoadingStatus(
        _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success, true);
  }
}

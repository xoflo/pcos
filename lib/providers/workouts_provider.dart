import 'package:thepcosprotocol_app/constants/table_names.dart';
import 'package:thepcosprotocol_app/models/workout_exercise.dart';

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

  List<WorkoutExercise> _workoutExercises = [];
  List<WorkoutExercise> get workoutExercises => [..._workoutExercises];

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

  Future<void> getWorkoutExercises(final int workoutID) async {
    _workoutExercises.clear();
    setLoadingStatus(LoadingStatus.loading, false);

    if (dbProvider?.db != null) {
      //first get the data from the api if we have no data yet
      List<WorkoutExercise> exercises = [];
      try {
        exercises = await ProviderHelper()
            .fetchAndSaveExercisesForWorkout(dbProvider, workoutID: workoutID);
      } catch (e) {
        setLoadingStatus(LoadingStatus.failed, true);
        return;
      }

      _workoutExercises = exercises;
      setLoadingStatus(LoadingStatus.success, true);
    }
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

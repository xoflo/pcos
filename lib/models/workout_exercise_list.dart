
import 'workout_exercise.dart';

class WorkoutExerciseList {
  List<WorkoutExercise>? results;

  WorkoutExerciseList({this.results});

  factory WorkoutExerciseList.fromList(List<dynamic> json) {
    List<WorkoutExercise> exerciseList = [];
    if (json.length > 0) {
      json.forEach((item) {
        exerciseList.add(WorkoutExercise.fromJson(item));
      });
    }
    return WorkoutExerciseList(results: exerciseList);
  }
}

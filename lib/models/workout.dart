import 'package:thepcosprotocol_app/models/workout_exercise.dart';
import 'package:thepcosprotocol_app/models/workout_exercise_list.dart';

class Workout {
  final int? workoutID;
  final String? title;
  final String? description;
  final String? tags;
  final int? minsToComplete;
  final int? orderIndex;
  final String? imageUrl;
  final bool? isFavorite;
  final bool? isComplete;
  final List<WorkoutExercise>? exercises;

  Workout({
    this.workoutID,
    this.title,
    this.description,
    this.tags,
    this.minsToComplete,
    this.orderIndex,
    this.imageUrl,
    this.isFavorite,
    this.isComplete,
    this.exercises,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      workoutID: json['workoutID'],
      title: json['title'],
      description: json['description'],
      tags: json['tags'],
      minsToComplete: json['minsToComplete'],
      orderIndex: json['orderIndex'],
      imageUrl: json['imageUrl'],
      isFavorite:
          json['isFavorite'] == 1 || json['isFavorite'] == true ? true : false,
      isComplete:
          json['isComplete'] == 1 || json['isComplete'] == true ? true : false,
      exercises: WorkoutExerciseList.fromList(json['exercises'] ?? []).results,
    );
  }
}

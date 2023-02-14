class WorkoutExercise {
  final int? exerciseID;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? mediaUrl;
  final String? equipmentRequired;
  final String? tags;
  final int? setsMinimum;
  final int? setsMaximum;
  final int? repsMinimum;
  final int? repsMaximum;
  final int? secsBetweenSets;

  WorkoutExercise({
    this.exerciseID,
    this.title,
    this.description,
    this.imageUrl,
    this.mediaUrl,
    this.equipmentRequired,
    this.tags,
    this.setsMinimum,
    this.setsMaximum,
    this.repsMinimum,
    this.repsMaximum,
    this.secsBetweenSets,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      exerciseID: json['exerciseID'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      mediaUrl: json['mediaUrl'],
      equipmentRequired: json['equipmentRequired'],
      tags: json['tags'],
      setsMinimum: json['setsMinimum'],
      setsMaximum: json['setsMaximum'],
      repsMinimum: json['repsMinimum'],
      repsMaximum: json['repsMaximum'],
      secsBetweenSets: json['secsBetweenSets'],
    );
  }
}

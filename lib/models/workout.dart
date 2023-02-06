// TODO: change attributes with the Workout attributes
class Workout {
  final bool? isFavorite;
  final int? recipeId;
  final int? lessonId;
  final String? title;
  final String? description;
  final String? thumbnail;
  final String? ingredients;
  final String? method;
  final String? tips;
  final String? tags;
  final int? difficulty;
  final int? servings;
  final int? duration;

  Workout({
    this.isFavorite, 
    this.recipeId, 
    this.lessonId, 
    this.title, 
    this.description, 
    this.thumbnail, 
    this.ingredients, 
    this.method, 
    this.tips, 
    this.tags, 
    this.difficulty, 
    this.servings, 
    this.duration,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      recipeId: json['recipeId'],
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      ingredients: json['ingredients'],
      method: json['method'],
      tips: json['tips'],
      tags: json['tags'],
      difficulty: json['difficulty'],
      servings: json['servings'],
      duration: json['duration'],
      isFavorite:
          json['isFavorite'] == 1 || json['isFavorite'] == true ? true : false,
    );
  }
}

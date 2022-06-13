import 'package:thepcosprotocol_app/models/lesson_recipe.dart';

class Recipe extends LessonRecipe {
  final bool? isFavorite;

  Recipe({
    int? recipeId,
    String? title,
    String? description,
    String? thumbnail,
    String? ingredients,
    String? method,
    String? tips,
    String? tags,
    int? difficulty,
    int? servings,
    int? duration,
    this.isFavorite,
  }) : super(
          recipeId: recipeId,
          title: title,
          description: description,
          thumbnail: thumbnail,
          ingredients: ingredients,
          method: method,
          tips: tips,
          tags: tags,
          difficulty: difficulty,
          servings: servings,
          duration: duration,
        );

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
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

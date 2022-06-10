class Recipe {
  final int? recipeId;
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
  final bool? isFavorite;

  Recipe({
    this.recipeId,
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
    this.isFavorite,
  });

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

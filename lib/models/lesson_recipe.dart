class LessonRecipe {
  final int recipeId;
  final int lessonId;
  final String title;
  final String description;
  final String thumbnail;
  final String ingredients;
  final String method;
  final String tips;
  final String tags;
  final int difficulty;
  final int servings;
  final int duration;
  final bool isFavorite;

  LessonRecipe({
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
    this.isFavorite,
  });

  bool _isExpanded = false;

  bool get isExpanded {
    return this._isExpanded;
  }

  set isExpanded(final bool isExpanded) {
    this._isExpanded = isExpanded;
  }

  factory LessonRecipe.fromJson(Map<String, dynamic> json) {
    return LessonRecipe(
      recipeId: json['recipeId'],
      lessonId: json['lessonID'],
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

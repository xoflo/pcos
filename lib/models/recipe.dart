class Recipe {
  final int recipeId;
  final String title;
  final String description;
  final String slug;
  final String thumbnail;
  final String ingredients;
  final String method;
  final String tips;
  final int difficulty;
  final int servings;
  final int duration;
  final String lastUpdatedUTC;
  final String dateCreatedUTC;

  Recipe({
    this.recipeId,
    this.title,
    this.description,
    this.slug,
    this.thumbnail,
    this.ingredients,
    this.method,
    this.tips,
    this.difficulty,
    this.servings,
    this.duration,
    this.lastUpdatedUTC,
    this.dateCreatedUTC,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      recipeId: json['recipeId'],
      title: json['title'],
      description: json['description'],
      slug: json['slug'],
      thumbnail: json['thumbnail'],
      ingredients: json['ingredients'],
      method: json['method'],
      tips: json['tips'],
      difficulty: json['difficulty'],
      servings: json['servings'],
      duration: json['duration'],
      lastUpdatedUTC: json['lastUpdatedUTC'],
      dateCreatedUTC: json['dateCreatedUTC'],
    );
  }
}

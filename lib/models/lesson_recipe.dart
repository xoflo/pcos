import 'dart:convert';

LessonRecipe cmsFromJson(String str) {
  final jsonData = json.decode(str);
  return LessonRecipe.fromMap(jsonData);
}

String cmsToJson(LessonRecipe data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class LessonRecipe {
  final int recipeId;
  final String title;
  final String thumbnail;

  LessonRecipe({
    this.recipeId,
    this.title,
    this.thumbnail,
  });

  factory LessonRecipe.fromMap(Map<String, dynamic> json) => new LessonRecipe(
        recipeId: json["recipeId"],
        title: json["title"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toMap() => {
        "recipeId": recipeId,
        "title": title,
        "thumbnail": thumbnail,
      };
}

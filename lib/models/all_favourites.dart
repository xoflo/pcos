import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';

class AllFavourites {
  final List<Lesson> toolkits;
  final List<Lesson> lessons;
  final List<LessonWiki> lessonWikis;
  final List<Recipe> recipes;

  AllFavourites({
    required this.toolkits,
    required this.lessons,
    required this.lessonWikis,
    required this.recipes,
  });
}

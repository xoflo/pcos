import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/constants/lesson_type.dart';

class FavouritesProvider with ChangeNotifier {
  final DatabaseProvider dbProvider;

  FavouritesProvider({@required this.dbProvider}) {
    if (dbProvider != null) getDataFromDatabase(dbProvider);
  }

  List<Lesson> _itemsLessons = [];
  List<Question> _itemsKnowledgeBase = [];
  List<Recipe> _itemsRecipes = [];
  LoadingStatus statusLessons = LoadingStatus.empty;
  LoadingStatus statusKnowledgeBase = LoadingStatus.empty;
  LoadingStatus statusRecipes = LoadingStatus.empty;

  List<Lesson> get itemsLessons => [..._itemsLessons];
  List<Question> get itemsKnowledgeBase => [..._itemsKnowledgeBase];
  List<Recipe> get itemsRecipes => [..._itemsRecipes];

  Future<void> getDataFromDatabase(
    final dbProvider,
  ) async {
    statusLessons = LoadingStatus.loading;
    statusKnowledgeBase = LoadingStatus.loading;
    statusRecipes = LoadingStatus.loading;

    debugPrint("****************** GET THE FAVOURITES");

    notifyListeners();
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    List<Lesson> lessonFavourites = List<Lesson>();
    List<Question> knowledgeBaseFavourites = List<Question>();
    List<Recipe> recipeFavourites = List<Recipe>();

    final Lesson fave1 = Lesson(
        lessonId: 1,
        lessonType: LessonType.Video,
        title: "This is a lesson",
        description:
            "This lesson is really good, it is a video and you can watch it.");
    final Question fave2 = Question(
      id: 1,
      reference: "xyz123",
      question: "This is a knowledge base question?",
      answer: "This is the answer to the question.",
      tags: "Diet",
    );
    final Recipe fave3 = Recipe(
      id: 1,
      title: "This is a recipe",
      description: "This is a tasty recipe",
      thumbnail: "images/4_Ingredient_Protein_Pancakes.jpg",
      ingredients: "some ingredients",
      method: "how to make it",
      tips: "tips",
      tags: "Breakfast",
      difficulty: 2,
      servings: 4,
      duration: 360000,
    );
    lessonFavourites.add(fave1);
    lessonFavourites.add(fave1);
    lessonFavourites.add(fave1);
    lessonFavourites.add(fave1);
    lessonFavourites.add(fave1);
    knowledgeBaseFavourites.add(fave2);
    knowledgeBaseFavourites.add(fave2);
    knowledgeBaseFavourites.add(fave2);
    recipeFavourites.add(fave3);
    recipeFavourites.add(fave3);
    recipeFavourites.add(fave3);
    recipeFavourites.add(fave3);
    recipeFavourites.add(fave3);
    recipeFavourites.add(fave3);

    _itemsLessons = lessonFavourites;
    _itemsKnowledgeBase = knowledgeBaseFavourites;
    _itemsRecipes = recipeFavourites;

    statusLessons =
        _itemsLessons.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    statusKnowledgeBase = _itemsKnowledgeBase.isEmpty
        ? LoadingStatus.empty
        : LoadingStatus.success;
    statusRecipes =
        _itemsRecipes.isEmpty ? LoadingStatus.empty : LoadingStatus.success;

    notifyListeners();
  }
}

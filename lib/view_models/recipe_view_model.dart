import 'package:thepcosprotocol_app/models/recipe.dart';

class RecipeViewModel {
  final Recipe recipe;

  RecipeViewModel({this.recipe});

  String get title {
    return this.recipe.title;
  }

  String get description {
    return this.recipe.description;
  }
}

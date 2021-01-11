import 'package:thepcosprotocol_app/models/recipe.dart';

class RecipeViewModel {
  final Recipe recipe;

  RecipeViewModel({this.recipe});

  int get recipeId {
    return this.recipe.recipeId;
  }

  String get title {
    return this.recipe.title;
  }

  String get description {
    return this.recipe.description;
  }

  String get thumbnail {
    return "https://pcosprotocolstorage.blob.core.windows.net/media/${this.recipe.thumbnail}";
  }
}

import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

class RecipeViewModel {
  final Recipe recipe;

  RecipeViewModel({this.recipe});

  bool _isFavourite = false;

  int get recipeId {
    return this.recipe.recipeId;
  }

  String get title {
    return this.recipe.title;
  }

  String get thumbnail {
    return FlavorConfig.instance.values.blobStorageUrl + this.recipe.thumbnail;
  }

  String get ingredients {
    return this.recipe.ingredients;
  }

  String get method {
    return this.recipe.method;
  }

  String get tips {
    return this.recipe.tips;
  }

  int get difficulty {
    return this.recipe.difficulty;
  }

  int get servings {
    return this.recipe.servings;
  }

  int get duration {
    return this.recipe.duration;
  }

  int get durationMinutes {
    return (this.recipe.duration / 60000000).round();
  }

  bool get isFavourite {
    return _isFavourite;
  }
}

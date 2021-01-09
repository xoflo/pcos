import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/view_models/recipe_view_model.dart';

enum Status { loading, empty, success }

class RecipeListViewModel extends ChangeNotifier {
  List<RecipeViewModel> recipes = List<RecipeViewModel>();
  Status status = Status.empty;

  Future<void> getAllRecipes() async {
    status = Status.loading;
    final results = await WebServices().getAllRecipes();
    recipes = results.map((recipe) => RecipeViewModel(recipe: recipe)).toList();
    status = recipes.isEmpty ? Status.empty : Status.success;
    notifyListeners();
  }
}

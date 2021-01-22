import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/view_models/recipe_view_model.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class RecipeListViewModel extends ChangeNotifier {
  List<RecipeViewModel> recipes = List<RecipeViewModel>();
  LoadingStatus status = LoadingStatus.empty;

  Future<void> getAllRecipes() async {
    status = LoadingStatus.loading;
    final results = await WebServices().getAllRecipes();
    recipes = results.map((recipe) => RecipeViewModel(recipe: recipe)).toList();
    status = recipes.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    notifyListeners();
  }
}

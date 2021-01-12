import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/view_models/recipe_list_view_model.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipes_filter.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipes_list.dart';
import 'package:thepcosprotocol_app/view_models/recipe_view_model.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_details.dart';

class RecipesLayout extends StatefulWidget {
  @override
  _RecipesLayoutState createState() => _RecipesLayoutState();
}

class _RecipesLayoutState extends State<RecipesLayout> {
  bool _showRecipeDetails = false;
  RecipeViewModel _recipeDetails;

  @override
  void initState() {
    super.initState();
    _populateAllRecipes();
  }

  void _populateAllRecipes() {
    debugPrint("**********************GETTING RECIPES**********************");
    Provider.of<RecipeListViewModel>(context, listen: false).getAllRecipes();
  }

  void _openRecipeDetails(RecipeViewModel recipe) {
    setState(() {
      _recipeDetails = recipe;
      _showRecipeDetails = true;
    });
  }

  void _closeRecipeDetails() {
    setState(() {
      _recipeDetails = null;
      _showRecipeDetails = false;
    });
  }

  void _addToFavourites() {
    debugPrint("Add to favourites");
  }

  Widget _displayUI(Size screenSize, RecipeListViewModel vm) {
    if (_showRecipeDetails) {
      return RecipeDetails(
        recipe: _recipeDetails,
        closeRecipeDetails: _closeRecipeDetails,
        addToFavourites: _addToFavourites,
      );
    } else {
      switch (vm.status) {
        case Status.loading:
          return Align(child: CircularProgressIndicator());
        case Status.empty:
          return Text("No recipes found!");
        case Status.success:
          return Column(
            children: [
              RecipeFilter(),
              RecipesList(
                  screenSize: screenSize,
                  recipes: vm.recipes,
                  openRecipeDetails: _openRecipeDetails)
            ],
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RecipeListViewModel>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return _displayUI(screenSize, vm);
  }
}

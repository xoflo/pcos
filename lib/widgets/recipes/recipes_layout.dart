import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/view_models/recipe_list_view_model.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipes_list.dart';

class RecipesLayout extends StatefulWidget {
  @override
  _RecipesLayoutState createState() => _RecipesLayoutState();
}

class _RecipesLayoutState extends State<RecipesLayout> {
  @override
  void initState() {
    super.initState();
    _populateAllRecipes();
  }

  void _populateAllRecipes() {
    debugPrint("**********************GETTING RECIPES");
    Provider.of<RecipeListViewModel>(context, listen: false).getAllRecipes();
  }

  Widget _displayUI(Size screenSize, RecipeListViewModel vm) {
    switch (vm.status) {
      case Status.loading:
        return Align(child: CircularProgressIndicator());
      case Status.empty:
        return Text("No recipes found!");
      case Status.success:
        return RecipesList(screenSize: screenSize, recipes: vm.recipes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RecipeListViewModel>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return _displayUI(screenSize, vm);
  }
}

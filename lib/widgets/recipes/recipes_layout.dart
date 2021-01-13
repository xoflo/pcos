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

class _RecipesLayoutState extends State<RecipesLayout>
    with SingleTickerProviderStateMixin {
  RecipeViewModel _recipeDetails;
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _populateAllRecipes();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _offsetAnimation =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
            .animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _populateAllRecipes() {
    debugPrint("**********************GETTING RECIPES**********************");
    Provider.of<RecipeListViewModel>(context, listen: false).getAllRecipes();
  }

  void _openRecipeDetails(RecipeViewModel recipe) async {
    setState(() {
      _recipeDetails = recipe;
    });
    await Future.delayed(const Duration(milliseconds: 300), () {
      _controller.forward();
    });
  }

  void _closeRecipeDetails() async {
    _controller.reverse();
    await Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _recipeDetails = null;
      });
    });
  }

  void _addToFavourites() {
    debugPrint("Add to favourites");
  }

  Widget _displayUI(Size screenSize, RecipeListViewModel vm) {
    return Stack(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: _getRecipesList(screenSize, vm),
      ),
      SlideTransition(
        position: _offsetAnimation,
        child: RecipeDetails(
          recipe: _recipeDetails,
          closeRecipeDetails: _closeRecipeDetails,
          addToFavourites: _addToFavourites,
        ),
      ),
    ]);
  }

  Widget _getRecipesList(Size screenSize, RecipeListViewModel vm) {
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

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RecipeListViewModel>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return _displayUI(screenSize, vm);
  }
}

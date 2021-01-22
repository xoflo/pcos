import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/view_models/recipe_list_view_model.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipes_filter.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipes_list.dart';
import 'package:thepcosprotocol_app/view_models/recipe_view_model.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_details.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class RecipesLayout extends StatefulWidget {
  @override
  _RecipesLayoutState createState() => _RecipesLayoutState();
}

class _RecipesLayoutState extends State<RecipesLayout>
    with SingleTickerProviderStateMixin {
  RecipeViewModel _recipeDetails;
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _populateAllRecipes();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _offsetAnimation =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
            .animate(_animationController);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
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
      _animationController.forward();
    });
  }

  void _closeRecipeDetails() async {
    _animationController.reverse();
    await Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _recipeDetails = null;
      });
    });
  }

  Widget _getRecipesList(Size screenSize, RecipeListViewModel vm) {
    switch (vm.status) {
      case LoadingStatus.loading:
        // TODO: does this need wrapping in a widget with more layout?
        return Align(child: CircularProgressIndicator());
      case LoadingStatus.empty:
        // TODO: create a widget for nothing found and test how it looks
        return Text("No recipes found!");
      case LoadingStatus.success:
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
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RecipeListViewModel>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: _getRecipesList(screenSize, vm),
        ),
        SlideTransition(
          position: _offsetAnimation,
          child: RecipeDetails(
            recipe: _recipeDetails,
            closeRecipeDetails: _closeRecipeDetails,
          ),
        ),
      ],
    );
  }
}

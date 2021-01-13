import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/view_models/recipe_list_view_model.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipes_layout.dart';
import 'package:provider/provider.dart';

class Recipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecipeListViewModel(),
      child: RecipesLayout(),
    );
  }
}

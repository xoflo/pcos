import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/view_models/recipe_list_view_model.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipes_layout.dart';
import 'package:provider/provider.dart';

class Recipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox.expand(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: ChangeNotifierProvider(
              create: (context) => RecipeListViewModel(),
              child: RecipesLayout(),
            ),
          ),
        ),
      ),
    );
  }
}

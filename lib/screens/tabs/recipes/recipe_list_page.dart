import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/image_view_item.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';

import '../../../models/navigation/lesson_recipe_arguments.dart';
import 'recipe_details_page.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({Key? key}) : super(key: key);

  static const id = "recipes_list_page";

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  @override
  Widget build(BuildContext context) {
    final List<LessonRecipe> recipes =
        ModalRoute.of(context)?.settings.arguments as List<LessonRecipe>;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(
          top: 12.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Header(
                title: "Lesson Recipe",
                closeItem: () => Navigator.pop(context),
              ),
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: List.generate(
                    recipes.length,
                    (index) {
                      final recipe = recipes[index];
                      return ImageViewItem(
                        thumbnail: recipe.thumbnail,
                        onViewPressed: () => RecipeDetailsPage(args: LessonRecipeArguments(true, recipe)),
                        title: recipe.title
                      );
                    },
                    growable: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

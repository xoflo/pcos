import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class RecipeCard extends StatelessWidget {
  final double width;
  final LessonRecipe lessonRecipe;
  final Function(BuildContext, int?) openRecipe;

  RecipeCard({
    required this.width,
    required this.lessonRecipe,
    required this.openRecipe,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.openRecipe(context, this.lessonRecipe.recipeId);
      },
      child: Container(
        width: width,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  FadeInImage.memoryNetwork(
                    alignment: Alignment.center,
                    placeholder: kTransparentImage,
                    image: lessonRecipe.thumbnail ?? "",
                    fit: BoxFit.fitWidth,
                    width: double.maxFinite,
                    height: 200,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xccffffff),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Text(
                        lessonRecipe.title ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

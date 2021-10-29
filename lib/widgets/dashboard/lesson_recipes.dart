import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/recipe_card.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class LessonRecipes extends StatelessWidget {
  final List<LessonRecipe> recipes;
  final int selectedRecipe;
  final double width;
  final bool isHorizontal;
  final Function(int) onSelected;
  final Function(BuildContext, int) openRecipe;

  LessonRecipes({
    @required this.recipes,
    @required this.selectedRecipe,
    @required this.width,
    @required this.isHorizontal,
    @required this.onSelected,
    @required this.openRecipe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                S.of(context).lessonRecipes,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SizedBox(
              width: width,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  enableInfiniteScroll: false,
                  viewportFraction: isHorizontal ? 0.50 : 0.92,
                  initialPage: selectedRecipe,
                  onPageChanged: (index, reason) {
                    onSelected(index);
                  },
                ),
                items: recipes.map((lessonRecipe) {
                  return Builder(
                    builder: (BuildContext context) {
                      return RecipeCard(
                        width: this.width,
                        lessonRecipe: lessonRecipe,
                        openRecipe: openRecipe,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

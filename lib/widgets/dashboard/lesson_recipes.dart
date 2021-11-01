import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/recipe_card.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class LessonRecipes extends StatefulWidget {
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
  _LessonRecipesState createState() => _LessonRecipesState();
}

class _LessonRecipesState extends State<LessonRecipes> {
  bool _isNoneMessageVisible = false;

  void _changeVisibility() {
    debugPrint("CHANGE VIS");
    debugPrint("_isVisible=$_isNoneMessageVisible");
    debugPrint("recipes len=${widget.recipes.length}");
    if (!_isNoneMessageVisible && widget.recipes.length == 0) {
      //play animation to show no wikis msg
      setState(() {
        _isNoneMessageVisible = true;
      });
    } else if (_isNoneMessageVisible && widget.recipes.length > 0) {
      //play animation to show no wikis msg
      setState(() {
        _isNoneMessageVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _changeVisibility();

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
              width: widget.width,
              child: Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      enableInfiniteScroll: false,
                      viewportFraction: widget.isHorizontal ? 0.50 : 0.92,
                      initialPage: widget.selectedRecipe,
                      onPageChanged: (index, reason) {
                        widget.onSelected(index);
                      },
                    ),
                    items: widget.recipes.map((lessonRecipe) {
                      return Builder(
                        builder: (BuildContext context) {
                          return RecipeCard(
                            width: this.widget.width,
                            lessonRecipe: lessonRecipe,
                            openRecipe: widget.openRecipe,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  AnimatedOpacity(
                    // If the widget is visible, animate to 0.0 (invisible).
                    // If the widget is hidden, animate to 1.0 (fully visible).
                    opacity: _isNoneMessageVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 1000),
                    // The green box must be a child of the AnimatedOpacity widget.
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: widget.width,
                        height: 200.0,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.block, size: 44, color: backgroundColor),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                S.of(context).noRecipes,
                                style: TextStyle(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

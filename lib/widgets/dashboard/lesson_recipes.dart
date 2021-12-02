import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/recipe_card.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';

class LessonRecipes extends StatefulWidget {
  final List<LessonRecipe> recipes;
  final LoadingStatus loadingStatus;
  final int selectedRecipe;
  final bool isComplete;
  final double width;
  final bool isHorizontal;
  final Function(BuildContext, int) openRecipe;

  LessonRecipes({
    @required this.recipes,
    @required this.loadingStatus,
    @required this.selectedRecipe,
    @required this.isComplete,
    @required this.width,
    @required this.isHorizontal,
    @required this.openRecipe,
  });

  @override
  _LessonRecipesState createState() => _LessonRecipesState();
}

class _LessonRecipesState extends State<LessonRecipes> {
  bool _isNoneMessageVisible = false;
  bool _isCarouselVisible = true;

  void _changeVisibility() {
    if (!_isNoneMessageVisible &&
        (widget.recipes.length == 0 || !widget.isComplete)) {
      //play animation to show no recipes msg
      setState(() {
        _isNoneMessageVisible = true;
        _isCarouselVisible = false;
      });
    } else if (_isNoneMessageVisible && widget.recipes.length > 0) {
      //play animation to show no recipes msg
      setState(() {
        _isNoneMessageVisible = false;
        _isCarouselVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String noRecipesMessage = "";
    if (widget.loadingStatus == LoadingStatus.success) {
      if (!widget.isComplete && widget.recipes.length > 0) {
        noRecipesMessage = S.current.lockedRecipes;
      } else {
        noRecipesMessage = S.current.noRecipes;
      }
      _changeVisibility();
    }

    return widget.loadingStatus == LoadingStatus.success
        ? Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: Container(
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
                        S.current.lessonRecipes,
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
                          AnimatedOpacity(
                            // If the widget is visible, animate to 0.0 (invisible).
                            // If the widget is hidden, animate to 1.0 (fully visible).
                            opacity: _isNoneMessageVisible ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 1000),
                            // The green box must be a child of the AnimatedOpacity widget.
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                width: widget.width,
                                height: 200.0,
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    noRecipesMessage.length > 0
                                        ? Icon(
                                            !widget.isComplete &&
                                                    widget.recipes.length > 0
                                                ? Icons.lock_outline
                                                : Icons.block,
                                            size: 44,
                                            color: backgroundColor)
                                        : Container(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        noRecipesMessage,
                                        style: TextStyle(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            // If the widget is visible, animate to 0.0 (invisible).
                            // If the widget is hidden, animate to 1.0 (fully visible).
                            opacity: _isCarouselVisible ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 1000),
                            // The green box must be a child of the AnimatedOpacity widget.
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 200,
                                enableInfiniteScroll: false,
                                viewportFraction:
                                    widget.isHorizontal ? 0.50 : 0.92,
                                initialPage: widget.selectedRecipe,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : widget.loadingStatus == LoadingStatus.empty
            ? NoResults(message: S.current.noResultsLessons)
            : Container();
  }
}

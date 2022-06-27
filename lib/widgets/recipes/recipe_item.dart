import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_recipe_arguments.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_details_page.dart';

class RecipeItem extends StatefulWidget {
  const RecipeItem({
    Key? key,
    required this.recipe,
    this.isFromLesson = true,
    this.onPressFavourite,
  }) : super(key: key);

  final bool isFromLesson;
  final LessonRecipe recipe;
  final Function()? onPressFavourite;

  @override
  State<RecipeItem> createState() => _RecipeItemState();
}

class _RecipeItemState extends State<RecipeItem> {
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          RecipeDetailsPage.id,
          arguments: LessonRecipeArguments(widget.isFromLesson, widget.recipe),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.recipe.thumbnail ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment(1, 0.8),
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7)
                          ],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: HtmlWidget(
                      widget.recipe.title ?? "",
                      textStyle:
                          Theme.of(context).textTheme.subtitle1?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.onPressFavourite != null)
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  onPressed: () => widget.onPressFavourite?.call(),
                  icon: Icon(
                    Icons.favorite,
                    color: redColor,
                  ),
                ),
              )
          ],
        ),
      );
}

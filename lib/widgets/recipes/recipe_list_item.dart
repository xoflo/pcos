import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;
  final int itemsPerRow;
  final Function(BuildContext, Recipe) openRecipeDetails;
  final Size screenSize;

  RecipeListItem({
    @required this.recipe,
    @required this.itemsPerRow,
    @required this.openRecipeDetails,
    @required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openRecipeDetails(context, recipe);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 4.0, horizontal: itemsPerRow > 1 ? 0.5 : 0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInImage.memoryNetwork(
                alignment: Alignment.center,
                placeholder: kTransparentImage,
                image: recipe.thumbnail,
                width: screenSize.width,
                height: 220,
                fit: BoxFit.fitWidth,
              ),
              Container(
                height: 46,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      recipe.title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

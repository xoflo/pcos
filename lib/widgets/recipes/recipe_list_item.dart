import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;
  final Function(BuildContext, Recipe) openRecipeDetails;

  RecipeListItem({this.recipe, this.openRecipeDetails});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openRecipeDetails(context, recipe);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInImage.memoryNetwork(
                alignment: Alignment.center,
                placeholder: kTransparentImage,
                image: FlavorConfig.instance.values.imageStorageUrl +
                    recipe.thumbnail,
                fit: BoxFit.fitWidth,
                width: double.maxFinite,
                height: 220,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  top: 12.0,
                ),
                child: Text(
                  recipe.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

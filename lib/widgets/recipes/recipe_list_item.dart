import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;
  final Function(Recipe) openRecipeDetails;

  RecipeListItem({this.recipe, this.openRecipeDetails});

  @override
  Widget build(BuildContext context) {
    debugPrint("thumbnail=${recipe.thumbnail}");
    return Container(
      height: 200.0,
      child: GestureDetector(
        onTap: () {
          openRecipeDetails(recipe);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: FadeInImage.memoryNetwork(
                    alignment: Alignment.center,
                    placeholder: kTransparentImage,
                    image: FlavorConfig.instance.values.blobStorageUrl +
                        recipe.thumbnail,
                    fit: BoxFit.fitWidth,
                    width: double.maxFinite,
                    height: 221,
                  ),
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
      ),
    );
  }
}

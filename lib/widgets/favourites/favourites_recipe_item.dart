import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

class FavouritesRecipeItem extends StatelessWidget {
  final Recipe recipe;
  final double width;
  final Function(FavouriteType, int) removeFavourite;
  final Function(FavouriteType, dynamic) openFavourite;

  FavouritesRecipeItem({
    @required this.recipe,
    @required this.width,
    @required this.removeFavourite,
    @required this.openFavourite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width - 60,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  recipe.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                removeFavourite(FavouriteType.Recipe, recipe.id);
              },
              child: Icon(
                Icons.delete,
                size: 24.0,
                color: secondaryColorLight,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                openFavourite(FavouriteType.Recipe, recipe);
              },
              child: Container(
                width: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: FadeInImage.memoryNetwork(
                    alignment: Alignment.center,
                    placeholder: kTransparentImage,
                    image: FlavorConfig.instance.values.blobStorageUrl +
                        recipe.thumbnail,
                    fit: BoxFit.fitWidth,
                    width: double.maxFinite,
                    height: 60,
                  ),
                ),
              ),
            ),
            Container(
              width: width - 170,
              child: Text(recipe.description),
            ),
            Container(
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      openFavourite(FavouriteType.Recipe, recipe);
                    },
                    child: Icon(
                      Icons.chevron_right,
                      size: 30.0,
                      color: secondaryColorLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: Divider(
            color: primaryColorDark,
          ),
        )
      ],
    );
  }
}

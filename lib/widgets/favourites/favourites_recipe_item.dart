import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

class FavouritesRecipeItem extends StatelessWidget {
  final Recipe recipe;
  final double width;
  final Function(FavouriteType, dynamic) removeFavourite;
  final Function(FavouriteType, dynamic) openFavourite;

  FavouritesRecipeItem({
    @required this.recipe,
    @required this.width,
    @required this.removeFavourite,
    @required this.openFavourite,
  });

  String _getThumbnailUrl(final String imageUrl) {
    return imageUrl.replaceAll(FlavorConfig.instance.values.imageStorageFolder,
        FlavorConfig.instance.values.thumbnailStorageFolder);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
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
                  removeFavourite(FavouriteType.Recipe, recipe);
                },
                child: Icon(
                  Icons.delete,
                  size: 24.0,
                  color: secondaryColor,
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
                      image: _getThumbnailUrl(recipe.thumbnail),
                      fit: BoxFit.fitWidth,
                      width: double.maxFinite,
                      height: 60,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Container(
                  width: width - 224,
                  child: Text(recipe.description),
                ),
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
                      child: Row(
                        children: [
                          Text(S.current.favouritesViewRecipe,
                              style: TextStyle(color: secondaryColor)),
                          Icon(
                            Icons.open_in_new,
                            size: 26.0,
                            color: secondaryColor,
                          ),
                        ],
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
              color: primaryColor,
            ),
          )
        ],
      ),
    );
  }
}

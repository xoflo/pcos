import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_details_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class FavouritesRecipes extends StatefulWidget {
  const FavouritesRecipes({Key? key, required this.favouritesProvider})
      : super(key: key);

  final FavouritesProvider favouritesProvider;

  @override
  State<FavouritesRecipes> createState() => _FavouritesRecipesState();
}

class _FavouritesRecipesState extends State<FavouritesRecipes> {
  late ModulesProvider modulesProvider;

  @override
  void initState() {
    super.initState();
    modulesProvider = Provider.of<ModulesProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.favouritesProvider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.current.noFavouriteRecipe);
      case LoadingStatus.success:
        return GridView.count(
          padding: EdgeInsets.all(10),
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(
            widget.favouritesProvider.recipes.length,
            (index) {
              final recipe = widget.favouritesProvider.recipes[index];

              final isFavouriteRecipe = widget.favouritesProvider.isFavourite(
                FavouriteType.Recipe,
                recipe.recipeId,
              );
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  RecipeDetailsPage.id,
                  arguments: recipe,
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
                              recipe.thumbnail ?? "",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
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
                            child: Text(
                              recipe.title ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: IconButton(
                        onPressed: () {
                          widget.favouritesProvider.addToFavourites(
                            FavouriteType.Recipe,
                            recipe.recipeId,
                          );
                        },
                        icon: Icon(
                          isFavouriteRecipe
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: redColor,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
            growable: false,
          ),
        );
    }
  }
}

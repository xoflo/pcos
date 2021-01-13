import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/view_models/recipe_view_model.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_details_summary.dart';

class RecipeDetails extends StatelessWidget {
  final RecipeViewModel recipe;
  final Function closeRecipeDetails;
  final Function addToFavourites;

  RecipeDetails({this.recipe, this.closeRecipeDetails, this.addToFavourites});

  Widget _getRecipeDetails(
      BuildContext context, bool isHorizontal, Size screenSize) {
    if (isHorizontal) {
      final tabControllerWidth = screenSize.width * 0.65;
      final summaryWidth = screenSize.width - (tabControllerWidth + 28);
      return Container(
        width: screenSize.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: summaryWidth,
                child: RecipeDetailsSummary(
                  recipe: recipe,
                ),
              ),
            ),
            Container(
              width: tabControllerWidth,
              child: _getTabController(context, isHorizontal),
            ),
          ],
        ),
      );
    } else {
      return _getTabController(context, isHorizontal);
    }
  }

  DefaultTabController _getTabController(
      BuildContext context, bool isHorizontal) {
    return DefaultTabController(
      length: isHorizontal ? 3 : 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(
              isScrollable: true,
              tabs: _getRecipeDetailTabs(context, isHorizontal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              //Add this to give height
              height: MediaQuery.of(context).size.height -
                  (kToolbarHeight + kBottomNavigationBarHeight),
              child: TabBarView(
                children: _getRecipeDetailTabViews(context, isHorizontal),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Tab> _getRecipeDetailTabs(BuildContext context, bool isHorizontal) {
    List<Tab> tabs = List<Tab>();
    if (!isHorizontal) {
      tabs.add(Tab(text: S.of(context).recipeDetailsSummaryTab));
    }
    tabs.add(Tab(text: S.of(context).recipeDetailsIngredientsTab));
    tabs.add(Tab(text: S.of(context).recipeDetailsMethodTab));
    tabs.add(Tab(text: S.of(context).recipeDetailsTipsTab));
    debugPrint("**************************TABS LENGTH=${tabs.length}");
    return tabs;
  }

  List<Widget> _getRecipeDetailTabViews(
      BuildContext context, bool isHorizontal) {
    List<Widget> tabViews = List<Widget>();
    if (!isHorizontal) {
      tabViews.add(RecipeDetailsSummary(
        recipe: recipe,
      ));
    }
    tabViews.add(Html(
      data: recipe.ingredients,
    ));
    tabViews.add(Html(
      data: recipe.method,
    ));
    tabViews.add(Html(
      data: recipe.tips,
    ));
    debugPrint("**************************TABVIEWS LENGTH=${tabViews.length}");
    return tabViews;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return SizedBox.expand(
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        addToFavourites();
                      },
                      child: Icon(
                        recipe.isFavourite
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: primaryColorDark,
                        size: 35,
                      ),
                    ),
                    Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    GestureDetector(
                      onTap: () {
                        closeRecipeDetails();
                      },
                      child: SizedBox(
                        width: 35,
                        height: 35,
                        child: Container(
                          color: primaryColorDark,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _getRecipeDetails(context, isHorizontal, screenSize),
            ],
          ),
        ),
      ),
    );
  }
}

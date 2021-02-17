import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_details_summary.dart';
import 'package:thepcosprotocol_app/widgets/shared/dialog_header.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';

class RecipeDetails extends StatelessWidget {
  final Recipe recipe;
  final Function closeRecipeDetails;
  final Function(dynamic, bool) addToFavourites;

  RecipeDetails({this.recipe, this.closeRecipeDetails, this.addToFavourites});

  Widget _getRecipeDetails(
      BuildContext context, bool isHorizontal, Size screenSize) {
    if (isHorizontal) {
      final tabControllerWidth = screenSize.width * 0.65;
      final summaryWidth = screenSize.width - (tabControllerWidth + 28);
      return Container(
        width: screenSize.width,
        height: screenSize.height - 140,
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
              height: _getTabBarHeight(context, isHorizontal),
              child: TabBarView(
                children: _getRecipeDetailTabViews(context, isHorizontal),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getTabBarHeight(BuildContext context, bool isHorizontal) {
    final int adjustmentAmount = isHorizontal ? 148 : 150;
    return MediaQuery.of(context).size.height -
        (kToolbarHeight + adjustmentAmount);
  }

  List<Tab> _getRecipeDetailTabs(BuildContext context, bool isHorizontal) {
    List<Tab> tabs = List<Tab>();
    if (!isHorizontal) {
      tabs.add(Tab(text: S.of(context).recipeDetailsSummaryTab));
    }
    tabs.add(Tab(text: S.of(context).recipeDetailsIngredientsTab));
    tabs.add(Tab(text: S.of(context).recipeDetailsMethodTab));
    tabs.add(Tab(text: S.of(context).recipeDetailsTipsTab));
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
    return tabViews;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);
    if (recipe == null) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 1.0,
        top: 1.0,
        right: 1.0,
      ),
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DialogHeader(
                screenSize: screenSize,
                item: recipe,
                favouriteType: FavouriteType.Recipe,
                title: recipe.title,
                isFavourite: recipe.isFavorite,
                closeItem: closeRecipeDetails,
                addToFavourites: addToFavourites,
              ),
              _getRecipeDetails(context, isHorizontal, screenSize),
            ],
          ),
        ),
      ),
    );
  }
}

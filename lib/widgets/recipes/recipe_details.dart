import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_details_summary.dart';
import 'package:thepcosprotocol_app/widgets/shared/dialog_header.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';

class RecipeDetails extends StatelessWidget {
  final Recipe? recipe;
  final bool isFavourite;
  final Function closeRecipeDetails;

  RecipeDetails({
    required this.recipe,
    required this.isFavourite,
    required this.closeRecipeDetails,
  });

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
    final int adjustmentAmount = isHorizontal ? 148 : 140;
    return MediaQuery.of(context).size.height -
        (kToolbarHeight + adjustmentAmount);
  }

  List<Tab> _getRecipeDetailTabs(BuildContext context, bool isHorizontal) {
    List<Tab> tabs = [];
    if (!isHorizontal) {
      tabs.add(Tab(text: S.current.recipeDetailsSummaryTab));
    }
    tabs.add(Tab(text: S.current.recipeDetailsIngredientsTab));
    tabs.add(Tab(text: S.current.recipeDetailsMethodTab));
    tabs.add(Tab(text: S.current.recipeDetailsTipsTab));
    return tabs;
  }

  List<Widget> _getRecipeDetailTabViews(
      BuildContext context, bool isHorizontal) {
    List<Widget> tabViews = [];
    if (!isHorizontal) {
      tabViews.add(RecipeDetailsSummary(
        recipe: recipe,
      ));
    }
    tabViews.add(SingleChildScrollView(
      child: HtmlWidget(
        recipe?.ingredients ?? "",
      ),
    ));
    tabViews.add(SingleChildScrollView(
      child: HtmlWidget(
        recipe?.method ?? "",
      ),
    ));
    tabViews.add(SingleChildScrollView(
      child: HtmlWidget(
        recipe?.tips ?? "",
      ),
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

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: <Widget>[
              DialogHeader(
                screenSize: screenSize,
                item: recipe,
                favouriteType: FavouriteType.Recipe,
                title: recipe?.title ?? "",
                isFavourite: this.isFavourite,
                closeItem: closeRecipeDetails,
                onAction: () {},
              ),
              _getRecipeDetails(context, isHorizontal, screenSize),
            ],
          ),
        ),
      ),
    );
  }
}

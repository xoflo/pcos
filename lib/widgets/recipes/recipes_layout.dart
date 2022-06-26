import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_item.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';

class RecipesLayout extends StatefulWidget {
  @override
  _RecipesLayoutState createState() => _RecipesLayoutState();
}

class _RecipesLayoutState extends State<RecipesLayout> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool isSearchDisabled = true;
  String _tagSelectedValue = "All";
  List<String> _tagValuesSelectedSecondary = [];
  List<MultiSelectItem<String>> _tagValuesSecondary = [];

  List<String> _getTagValues() {
    final stringContext = S.of(context);
    return <String>[
      stringContext.tagAll,
      stringContext.recipesTagBreakfast,
      stringContext.recipesTagLunch,
      stringContext.recipesTagDinner,
      stringContext.recipesTagSnack,
      stringContext.recipesTagDessert,
      stringContext.recipesTagCondiments,
      stringContext.recipesTagDrinks,
    ];
  }

  List<MultiSelectItem<String>> _getTagValuesSecondary(
      final String tagSelected) {
    //TODO: need to update these once info is available
    final stringContext = S.of(context);
    final String plantBased = stringContext.recipesTagSecondaryPlantBased;
    final String vegetarian = stringContext.recipesTagSecondaryVegetarian;
    final String dairyFree = stringContext.recipesTagSecondaryDairyFree;
    final String nutFree = stringContext.recipesTagSecondaryNutFree;
    final String eggFree = stringContext.recipesTagSecondaryEggFree;

    if (tagSelected == stringContext.recipesTagBreakfast) {
      return [
        MultiSelectItem(vegetarian, vegetarian),
        MultiSelectItem(nutFree, nutFree),
        MultiSelectItem(eggFree, eggFree),
      ];
    }

    if (tagSelected == stringContext.recipesTagLunch) {
      return [
        MultiSelectItem(plantBased, plantBased),
        MultiSelectItem(dairyFree, dairyFree),
      ];
    }

    return [];
  }

  void _onTagSelected(String tagValue) {
    setState(() {
      _tagSelectedValue = tagValue;
      _tagValuesSecondary = _getTagValuesSecondary(tagValue);
      _tagValuesSelectedSecondary.clear();
    });
    _onSearchClicked();
  }

  void _onSecondaryTagSelected(List<String> tagValues) {
    setState(() {
      _tagValuesSelectedSecondary = tagValues;
    });
    _onSearchClicked();
  }

  void _onSearchClicked() async {
    analytics.logEvent(
      name: Analytics.ANALYTICS_EVENT_SEARCH,
      parameters: {
        Analytics.ANALYTICS_PARAMETER_SEARCH_TYPE:
            Analytics.ANALYTICS_SEARCH_RECIPE
      },
    );
    final recipeProvider = Provider.of<RecipesProvider>(context, listen: false);
    recipeProvider.filterAndSearch(_searchController.text.trim(),
        _tagSelectedValue, _tagValuesSelectedSecondary);
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
  }

  Widget _getRecipesList(
      final Size screenSize,
      final RecipesProvider recipesProvider,
      final FavouritesProvider favouritesProvider) {
    if (_tagSelectedValue.length == 0) {
      _tagSelectedValue = S.current.tagAll;
    }
    switch (recipesProvider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.current.noResultsRecipes);
      case LoadingStatus.success:
        return Expanded(
          child: GridView.count(
            shrinkWrap: true,
            padding: EdgeInsets.all(15),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: recipesProvider.items
                .map((recipe) => RecipeItem(recipe: recipe))
                .toList(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          width: double.maxFinite,
          color: primaryColor,
          child: TextFormField(
            controller: _searchController,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (_) => _onSearchClicked(),
            onChanged: (text) =>
                setState(() => isSearchDisabled = text.isEmpty),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Opacity(
                  opacity: isSearchDisabled ? 0.5 : 1,
                  child: Icon(
                    Icons.search,
                    color: backgroundColor,
                    size: 20,
                  ),
                ),
                onPressed: isSearchDisabled ? null : _onSearchClicked,
              ),
              hintText: "Search",
              isDense: true,
              contentPadding: EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: backgroundColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: backgroundColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: backgroundColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: backgroundColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        // SearchHeader(
        //   formKey: _formKey,
        //   searchController: _searchController,
        //   tagValues: _getTagValues(),
        //   tagValueSelected: _tagSelectedValue,
        //   onTagSelected: _onTagSelected,
        //   onSearchClicked: _onSearchClicked,
        //   isSearching: _isSearching,
        //   tagValuesSecondary: _tagValuesSecondary,
        //   tagValuesSelectedSecondary: _tagValuesSelectedSecondary,
        //   onSecondaryTagSelected: _onSecondaryTagSelected,
        // ),

        Consumer2<RecipesProvider, FavouritesProvider>(
          builder: (context, recipesProvider, favouritesProvider, child) =>
              _getRecipesList(screenSize, recipesProvider, favouritesProvider),
        ),
      ],
    );
  }
}

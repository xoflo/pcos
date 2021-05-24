import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/shared/search_header.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipes_list.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_details.dart';
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
    final String glutenFree = stringContext.recipesTagSecondaryGlutenFree;
    final String dairyFree = stringContext.recipesTagSecondaryDairyFree;
    final String nutFree = stringContext.recipesTagSecondaryNutFree;
    final String eggFree = stringContext.recipesTagSecondaryEggFree;
    final String pescatarian = stringContext.recipesTagSecondaryPescatarian;
    final String fodmapFriendly =
        stringContext.recipesTagSecondaryFodmapFriendly;
    final String calorieControlled =
        stringContext.recipesTagSecondaryCalorieControlled;
    final String slowCooker = stringContext.recipesTagSecondarySlowCooker;

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

  void _openRecipeDetails(BuildContext context, Recipe recipe) async {
    //remove the focus from the searchbox if necessary, to hide the keyboard
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

    openBottomSheet(
      context,
      RecipeDetails(
        recipe: recipe,
        closeRecipeDetails: _closeRecipeDetails,
        addToFavourites: _addToFavourites,
      ),
      Analytics.ANALYTICS_SCREEN_RECIPE_DETAIL,
      recipe.recipeId.toString(),
    );
  }

  void _closeRecipeDetails() {
    Navigator.pop(context);
  }

  void _addToFavourites(final dynamic recipe, final bool add) async {
    final recipeProvider = Provider.of<RecipesProvider>(context, listen: false);
    await recipeProvider.addToFavourites(recipe, add);
    recipeProvider.filterAndSearch(_searchController.text.trim(),
        _tagSelectedValue, _tagValuesSelectedSecondary);
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
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  }

  Widget _getRecipesList(
      final Size screenSize, final RecipesProvider recipesProvider) {
    if (_tagSelectedValue.length == 0) {
      _tagSelectedValue = S.of(context).tagAll;
    }
    switch (recipesProvider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.of(context).noResultsRecipes);
      case LoadingStatus.success:
        return RecipesList(
            screenSize: screenSize,
            recipes: recipesProvider.items,
            openRecipeDetails: _openRecipeDetails);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        SearchHeader(
          screenSize: screenSize,
          searchController: _searchController,
          tagValues: _getTagValues(),
          tagValueSelected: _tagSelectedValue,
          onTagSelected: _onTagSelected,
          onSearchClicked: _onSearchClicked,
          isSearching: _isSearching,
          tagValuesSecondary: _tagValuesSecondary,
          tagValuesSelectedSecondary: _tagValuesSelectedSecondary,
          onSecondaryTagSelected: _onSecondaryTagSelected,
        ),
        Consumer<RecipesProvider>(
          builder: (context, model, child) =>
              _getRecipesList(screenSize, model),
        ),
      ],
    );
  }
}

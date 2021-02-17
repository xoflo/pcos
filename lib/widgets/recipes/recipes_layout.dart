import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/search_header.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipes_list.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_details.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';

class RecipesLayout extends StatefulWidget {
  @override
  _RecipesLayoutState createState() => _RecipesLayoutState();
}

class _RecipesLayoutState extends State<RecipesLayout> {
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String tagSelectedValue = "All";

  List<String> getTagValues() {
    final stringContext = S.of(context);
    return <String>[
      stringContext.tagAll,
      stringContext.recipesTagBreakfast,
      stringContext.recipesTagMains,
      stringContext.recipesTagSnack,
      stringContext.recipesTagSweet,
      stringContext.recipesTagSavoury,
      stringContext.recipesTagVegetarian,
      stringContext.recipesTagVegan,
      stringContext.recipesTagEggFree,
      stringContext.recipesTagFodmap
    ];
  }

  void openRecipeDetails(BuildContext context, Recipe recipe) async {
    //remove the focus from the searchbox if necessary, to hide the keyboard
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    //removeFocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => RecipeDetails(
        recipe: recipe,
        closeRecipeDetails: closeRecipeDetails,
        addToFavourites: addToFavourites,
      ),
    );
  }

  void closeRecipeDetails() {
    Navigator.pop(context);
  }

  void addToFavourites(final dynamic recipe, final bool add) async {
    final recipeProvider = Provider.of<RecipesProvider>(context, listen: false);
    await recipeProvider.addToFavourites(recipe, add);
    recipeProvider.filterAndSearch(
        searchController.text.trim(), tagSelectedValue);
  }

  void onTagSelected(String tagValue) {
    setState(() {
      tagSelectedValue = tagValue;
    });
  }

  void onSearchClicked() async {
    final recipeProvider = Provider.of<RecipesProvider>(context, listen: false);
    recipeProvider.filterAndSearch(
        searchController.text.trim(), tagSelectedValue);
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    //removeFocus();
  }

  void removeFocus() {
    //remove focus from the searchInput
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Widget getRecipesList(
      final Size screenSize, final RecipesProvider recipesProvider) {
    if (tagSelectedValue.length == 0) {
      tagSelectedValue = S.of(context).tagAll;
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
            openRecipeDetails: openRecipeDetails);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          SearchHeader(
            searchController: searchController,
            tagValues: getTagValues(),
            tagValue: tagSelectedValue,
            onTagSelected: onTagSelected,
            onSearchClicked: onSearchClicked,
            isSearching: isSearching,
          ),
          Consumer<RecipesProvider>(
            builder: (context, model, child) =>
                getRecipesList(screenSize, model),
          ),
        ],
      ),
    );
  }
}

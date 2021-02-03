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

class RecipesLayout extends StatefulWidget {
  @override
  _RecipesLayoutState createState() => _RecipesLayoutState();
}

class _RecipesLayoutState extends State<RecipesLayout>
    with SingleTickerProviderStateMixin {
  Recipe _recipeDetails;
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String tagSelectedValue = "All";

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _offsetAnimation =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
            .animate(_animationController);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

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

  void openRecipeDetails(Recipe recipe) async {
    setState(() {
      _recipeDetails = recipe;
    });
    await Future.delayed(const Duration(milliseconds: 300), () {
      _animationController.forward();
    });
  }

  void closeRecipeDetails() async {
    _animationController.reverse();
    await Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _recipeDetails = null;
      });
    });
  }

  void onTagSelected(String tagValue) {
    debugPrint("********************tagSelected=$tagValue");
    setState(() {
      tagSelectedValue = tagValue;
    });
  }

  void onSearchClicked() async {
    final recipeProvider = Provider.of<RecipesProvider>(context, listen: false);
    recipeProvider.filterAndSearch(
        searchController.text.trim(), tagSelectedValue);
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
        // TODO: create a widget for nothing found and test how it looks
        return Text("No recipes found!");
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

    return Stack(
      children: <Widget>[
        Consumer<RecipesProvider>(
          builder: (context, model, child) => Padding(
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
                getRecipesList(screenSize, model),
              ],
            ),
          ),
        ),
        SlideTransition(
          position: _offsetAnimation,
          child: RecipeDetails(
            recipe: _recipeDetails,
            closeRecipeDetails: closeRecipeDetails,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_filter_sheet.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_item.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/widgets/shared/search_component.dart';

class RecipesLayout extends StatefulWidget {
  @override
  _RecipesLayoutState createState() => _RecipesLayoutState();
}

class _RecipesLayoutState extends State<RecipesLayout> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  String _mealTag = "";
  List<String> _dietTags = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
    _initializeMealDietTags();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
  }

  void _initializeMealDietTags() async {
    if (await PreferencesController()
        .getBool(SharedPreferencesKeys.RECIPE_SEARCH_DEFAULT)) {
      final meals = await PreferencesController()
          .getString(SharedPreferencesKeys.RECIPE_SEARCH_MEALS);
      final diets = await PreferencesController()
          .getStringList(SharedPreferencesKeys.RECIPE_SEARCH_DIETS);

      _mealTag = meals;
      _dietTags = diets;
    } else {
      _mealTag = "All";
      _dietTags = [];
    }

    _onSearchClicked();
  }

  void _onFocusChanged() {
    setState(() => _isSearching = _focusNode.hasFocus);
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
    recipeProvider.filterAndSearch(
        _searchController.text.trim(), _mealTag, _dietTags);
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: Column(
          children: [
            SearchComponent(
              searchController: _searchController,
              focusNode: _focusNode,
              searchBackgroundColor: primaryColor,
              onSearchPressed: _onSearchClicked,
            ),
            if (_isSearching && _searchController.text.trim().isEmpty)
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 70),
                  alignment: Alignment.center,
                  child: Text(
                    "Search any ingredients, recipes names, or meal types.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: textColor.withOpacity(0.5),
                    ),
                  ),
                ),
              )
            else ...[
              GestureDetector(
                onTap: () => openBottomSheet(
                  context,
                  RecipeFilterSheet(
                    selectedMealType: _mealTag,
                    selectedDietType: _dietTags,
                    onSearchPressed: (meal, diet) {
                      setState(() {
                        _mealTag = meal;
                        _dietTags = diet ?? [];
                      });

                      _onSearchClicked();
                    },
                  ),
                  Analytics.ANALYTICS_RECIPE_FILTER,
                  null,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: backgroundColor,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Filters",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: backgroundColor),
                      ),
                    ],
                  ),
                ),
              ),
              Consumer2<RecipesProvider, FavouritesProvider>(
                builder: (context, recipesProvider, favouritesProvider, child) {
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
                              .map((recipe) => RecipeItem(
                                    recipe: recipe,
                                    isFromLesson: false,
                                  ))
                              .toList(),
                        ),
                      );
                  }
                },
              ),
            ],
          ],
        ),
      );
}

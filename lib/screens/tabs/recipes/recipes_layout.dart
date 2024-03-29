import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/shared/image_view_item.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_with_change_notifier.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/widgets/shared/search_component.dart';

import '../../../models/navigation/lesson_recipe_arguments.dart';
import '../../../providers/favourites_provider.dart';
import '../../../widgets/shared/favorites_toggle_button.dart';
import 'recipe_details_page.dart';
import 'recipe_filter_sheet.dart';

class RecipesLayout extends StatefulWidget {
  @override
  _RecipesLayoutState createState() => _RecipesLayoutState();
}

class _RecipesLayoutState extends State<RecipesLayout> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  bool isInitialized = false;

  bool _isSearching = false;
  String _mealTag = "All";
  List<String> _dietTags = [];
  bool _isShowFavoritesOnly = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
  }

  void _initializeMealDietTags(RecipesProvider recipesProvider) async {
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

    _onSearchClicked(recipesProvider);
  }

  void _onFocusChanged() {
    setState(() => _isSearching = _focusNode.hasFocus);
  }

  void _onSearchClicked(RecipesProvider recipesProvider) async {
    analytics.logEvent(
      name: Analytics.ANALYTICS_EVENT_SEARCH,
      parameters: {
        Analytics.ANALYTICS_PARAMETER_SEARCH_TYPE:
            Analytics.ANALYTICS_SEARCH_RECIPE
      },
    );

    recipesProvider.filterAndSearch(
        _searchController.text.trim(), _mealTag, _dietTags);
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final recipesProvider = Provider.of<RecipesProvider>(context);
    final favoritesProvider = Provider.of<FavouritesProvider>(context);
    if (!isInitialized) {
      isInitialized = true;
      _initializeMealDietTags(recipesProvider);
    }

    var recipeItems = _isShowFavoritesOnly ? favoritesProvider.recipes : recipesProvider.randomizedItems;

    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Column(
        children: [
          SearchComponent(
            searchController: _searchController,
            focusNode: _focusNode,
            searchBackgroundColor: primaryColor,
            onSearchPressed: () => _onSearchClicked(recipesProvider),
          ),
          if (_isSearching && _searchController.text.trim().isEmpty)
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 60),
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
            Row(
              children: [
                FavoritesToggleButton(
                  label: 'My favorite recipes', 
                  onToggleCallback: (bool isShowFavoritesOnly) async {
                    await favoritesProvider.fetchAndSaveData();
                    setState(
                        () => _isShowFavoritesOnly = isShowFavoritesOnly);
                  }
                ),
                GestureDetector(
                  onTap: () => openBottomSheet(
                    context,
                    RecipeFilterSheet(
                      currentPrimaryCriteria: _mealTag,
                      currentSecondaryCriteria: _dietTags,
                      onSearchPressed: (meal, diet) {
                        setState(() {
                          _mealTag = meal;
                          _dietTags = diet ?? [];
                        });

                        _onSearchClicked(recipesProvider);
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
              ],
            ),
            Expanded(
              child: LoaderOverlay(
                height: double.maxFinite,
                indicatorPosition: Alignment.topCenter,
                loadingStatusNotifier: recipesProvider,
                emptyMessage: S.current.noResultsRecipes,
                overlayBackgroundColor: Colors.transparent,
                child: GridView.count(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(15),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: recipeItems.map(
                        (recipe) => ImageViewItem(
                          thumbnail: recipe.thumbnail,
                          onViewPressed: () => RecipeDetailsPage(args: LessonRecipeArguments(false, recipe)),
                          onViewClosed: () => Provider.of<FavouritesProvider>(context, listen: false).fetchRecipesStatus(),
                          title: recipe.title,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

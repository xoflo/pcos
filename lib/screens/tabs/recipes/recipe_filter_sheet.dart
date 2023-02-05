import '../../../widgets/shared/filter/filter_sheet.dart';
import '../../../constants/analytics.dart' as Analytics;
import '../../../constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class RecipeFilterSheet extends FilterSheet {
  RecipeFilterSheet({
    required String currentPrimaryCriteria,
    List<String>? currentSecondaryCriteria,
    Function(String, List<String>?)? onSearchPressed
    })
      : super(currentPrimaryCriteria: currentPrimaryCriteria, 
      currentSecondaryCriteria: currentSecondaryCriteria, 
      onSearchPressed: onSearchPressed);

  @override
  String getAnalyticsPrimaryCriteria() {
    return Analytics.ANALYTICS_SEARCH_RECIPE_MEAL;
  }

  @override
  String getAnalyticsSecondaryCriteria() {
    return Analytics.ANALYTICS_SEARCH_RECIPE_DIET;
  }

  @override
  List<String> getPrimaryCriteriaChoices() {
    const List<String> mealValues = <String>[
      "All",
      "Breakfast",
      "Lunch",
      "Dinner",
      "Snacks",
      "Sweets",
      "Condiments",
      "Sides",
      // We need the blank state, which will not be selectable. Not having
      // this tends to cut the last element off from the list for some reason
      "",
    ];
    return mealValues;
  }

  @override
  String getPrimaryCriteriaLabel() {
    return "Types of meal";
  }

  @override
  String getPrimaryCriteriaPreferenceKey() {
    return SharedPreferencesKeys.RECIPE_SEARCH_MEALS;
  }

  @override
  String getSearchDefaultPreferenceKey() {
    return SharedPreferencesKeys.RECIPE_SEARCH_DEFAULT;
  }

  @override
  List<String> getSecondaryCriteriaChoices() {
    const List<String> dietaryRequirementValues = [
      "Gluten Free",
      "Dairy Free",
      "Nut Free",
      "Egg Free",
      "Soy Free",
      "Vegetarian",
      "Vegan",
      "Insulin Friendly",
      // We need the blank state, which will not be selectable. Not having
      // this tends to cut the last element off from the list for some reason
      "",
    ];
    return dietaryRequirementValues;
  }

  @override
  String getSecondaryCriteriaLabel() {
    return "Types of diets";
  }

  @override
  String getSecondaryCriteriaPreferenceKey() {
    return SharedPreferencesKeys.RECIPE_SEARCH_DIETS;
  }
}

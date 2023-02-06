import '../../../widgets/shared/filter/filter_sheet.dart';
import '../../../constants/analytics.dart' as Analytics;
import '../../../constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class WorkoutFilterSheet extends FilterSheet {
  WorkoutFilterSheet({
    required String currentPrimaryCriteria,
    List<String>? currentSecondaryCriteria,
    Function(String, List<String>?)? onSearchPressed
    })
      : super(currentPrimaryCriteria: currentPrimaryCriteria, 
      currentSecondaryCriteria: currentSecondaryCriteria, 
      onSearchPressed: onSearchPressed);

  @override
  String getAnalyticsPrimaryCriteria() {
    return Analytics.ANALYTICS_SEARCH_WORKOUT_DIFFICULTY;
  }

  @override
  String getAnalyticsSecondaryCriteria() {
    return Analytics.ANALYTICS_SEARCH_WORKOUT_TYPE;
  }

  @override
  List<String> getPrimaryCriteriaChoices() {
    const List<String> difficultyChoices = <String>[
      "All",
      "Beginner",
      "Intermediate",
      "Advanced",
      "Postpartum",
      "Pregnancy friendly",
      // We need the blank state, which will not be selectable. Not having
      // this tends to cut the last element off from the list for some reason
      "",
    ];
    return difficultyChoices;
  }

  @override
  String getPrimaryCriteriaLabel() {
    return "Difficulty";
  }

  @override
  String getPrimaryCriteriaPreferenceKey() {
    return SharedPreferencesKeys.WORKOUT_DIFFICULTY_FILTER;
  }

  @override
  String getSecondaryCriteriaPreferenceKey() {
    return SharedPreferencesKeys.WORKOUT_TYPE_FILTER;
  }

  @override
  String getSearchDefaultPreferenceKey() {
    return SharedPreferencesKeys.WORKOUT_DEFAULT_FILTER;
  }

  @override
  List<String> getSecondaryCriteriaChoices() {
    const List<String> workoutTypes = [
      "Weighted",
      "Bodyweight",
      "Short (7 mins)",
      "Pregnancy friendly",
      "Equipment free",
      // We need the blank state, which will not be selectable. Not having
      // this tends to cut the last element off from the list for some reason
      "",
    ];
    return workoutTypes;
  }

  @override
  String getSecondaryCriteriaLabel() {
    return "Workout type";
  }
}

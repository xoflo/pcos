import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_filter_list_sheet.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';

import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class RecipeFilterSheet extends StatefulWidget {
  const RecipeFilterSheet(
      {Key? key,
      required this.selectedMealType,
      this.selectedDietType,
      this.onSearchPressed})
      : super(key: key);

  final String selectedMealType;
  final List<String>? selectedDietType;
  final Function(String, List<String>?)? onSearchPressed;

  @override
  State<RecipeFilterSheet> createState() => _RecipeFilterSheetState();
}

class _RecipeFilterSheetState extends State<RecipeFilterSheet> {
  String selectedMealType = "All";
  List<String> selectedDietType = [];
  bool isDefaultFilter = false;

  @override
  void initState() {
    super.initState();
    selectedMealType = widget.selectedMealType;
    selectedDietType = widget.selectedDietType ?? [];

    initializeDefaultFilter();
  }

  void initializeDefaultFilter() async {
    final isDefault = await PreferencesController()
        .getBool(SharedPreferencesKeys.RECIPE_SEARCH_DEFAULT);

    setState(() => isDefaultFilter = isDefault);
  }

  List<String> get mealValues => <String>[
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

  List<String> get dietaryRequirementValues => [
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

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        color: Colors.white,
        child: FractionallySizedBox(
          heightFactor: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: backgroundColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        selectedDietType.clear();
                        selectedMealType = "All";
                        isDefaultFilter = false;
                      }),
                      child: Text(
                        "Clear All",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(color: backgroundColor),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 35),
              Text(
                "Types of meal",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  openBottomSheet(
                    context,
                    RecipeFilterList(
                      values: mealValues,
                      onSelectItem: (tag) {
                        setState(() => selectedMealType = tag);
                      },
                    ),
                    Analytics.ANALYTICS_SEARCH_RECIPE_MEAL,
                    null,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: textColor.withOpacity(0.8), width: 1),
                  ),
                  child: Text(
                    selectedMealType,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              if (selectedMealType != 'All') ...[
                SizedBox(height: 25),
                Text(
                  "Types of diets",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    openBottomSheet(
                      context,
                      RecipeFilterList(
                        values: dietaryRequirementValues,
                        onSelectItem: (tag) => setState(() {
                          if (!selectedDietType.contains(tag)) {
                            selectedDietType.add(tag);
                          } else {
                            selectedDietType.remove(tag);
                          }
                        }),
                        selectedItems: selectedDietType,
                      ),
                      Analytics.ANALYTICS_SEARCH_RECIPE_DIET,
                      null,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: textColor.withOpacity(0.8), width: 1),
                    ),
                    child: Text(
                      selectedDietType.isNotEmpty
                          ? selectedDietType.reduce(
                              (value, element) => value + ", " + element)
                          : "",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 25),
              GestureDetector(
                onTap: () => setState(() => isDefaultFilter = !isDefaultFilter),
                child: Row(
                  children: [
                    Icon(
                      isDefaultFilter
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank,
                      color: backgroundColor,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Set as default filter",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.normal,
                          color: textColor.withOpacity(0.8)),
                    )
                  ],
                ),
              ),
              SizedBox(height: 25),
              FilledButton(
                text: "FILTER SEARCH",
                margin: EdgeInsets.zero,
                foregroundColor: Colors.white,
                backgroundColor: backgroundColor,
                onPressed: () {
                  Navigator.pop(context);

                  PreferencesController().saveBool(
                      SharedPreferencesKeys.RECIPE_SEARCH_DEFAULT,
                      isDefaultFilter);

                  PreferencesController().saveString(
                      SharedPreferencesKeys.RECIPE_SEARCH_MEALS,
                      selectedMealType);

                  selectedDietType.forEach(
                    (diet) => PreferencesController().addToStringList(
                        SharedPreferencesKeys.RECIPE_SEARCH_DIETS, diet),
                  );

                  widget.onSearchPressed
                      ?.call(selectedMealType, selectedDietType);
                },
              )
            ],
          ),
        ),
      );
}

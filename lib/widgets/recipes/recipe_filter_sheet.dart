import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_filter_list_sheet.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';

import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;

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
  }

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

  List<String> _getTagValuesSecondary() {
    //TODO: need to update these once info is available
    final stringContext = S.of(context);
    final String plantBased = stringContext.recipesTagSecondaryPlantBased;
    final String vegetarian = stringContext.recipesTagSecondaryVegetarian;
    final String dairyFree = stringContext.recipesTagSecondaryDairyFree;
    final String nutFree = stringContext.recipesTagSecondaryNutFree;
    final String eggFree = stringContext.recipesTagSecondaryEggFree;

    if (selectedMealType == stringContext.recipesTagBreakfast) {
      return [
        vegetarian,
        nutFree,
        eggFree,
      ];
    }

    if (selectedMealType == stringContext.recipesTagLunch) {
      return [
        plantBased,
        dairyFree,
      ];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        color: Colors.white,
        child: FractionallySizedBox(
          heightFactor: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                      style: TextStyle(
                        color: backgroundColor,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 35),
              Text(
                "Types of meal",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  openBottomSheet(
                    context,
                    RecipeFilterList(
                      values: _getTagValues(),
                      onSelectItem: (tag) {
                        setState(() {
                          selectedDietType.clear();
                          selectedMealType = tag;
                        });
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
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              if (selectedMealType == S.of(context).recipesTagBreakfast ||
                  selectedMealType == S.of(context).recipesTagLunch) ...[
                SizedBox(height: 25),
                Text(
                  "Types of diets",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    openBottomSheet(
                      context,
                      RecipeFilterList(
                        values: _getTagValuesSecondary(),
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
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
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
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor.withOpacity(0.8),
                      ),
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
                  widget.onSearchPressed
                      ?.call(selectedMealType, selectedDietType);
                },
              )
            ],
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/shared/filter/filter_list_sheet.dart';
import '/widgets/shared/filled_button.dart' as Ovie;

abstract class FilterSheet extends StatefulWidget {
  const FilterSheet(
      {Key? key,
      required this.currentPrimaryCriteria,
      this.currentSecondaryCriteria,
      this.onSearchPressed,
      this.isSecondaryMultiSelect = true})
      : super(key: key);

  final String currentPrimaryCriteria;
  final List<String>? currentSecondaryCriteria;
  final Function(String, List<String>?)? onSearchPressed;
  final bool isSecondaryMultiSelect;

  String getSearchDefaultPreferenceKey();
  String getPrimaryCriteriaPreferenceKey();
  String getSecondaryCriteriaPreferenceKey();

  List<String> getPrimaryCriteriaChoices();
  List<String> getSecondaryCriteriaChoices();
  String getPrimaryCriteriaLabel();
  String getSecondaryCriteriaLabel();

  String getAnalyticsPrimaryCriteria();
  String getAnalyticsSecondaryCriteria();

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  String currentPrimaryCriteria = "All";
  List<String> currentSecondaryCriteria = [];
  bool isDefaultFilter = false;

  @override
  void initState() {
    super.initState();
    currentPrimaryCriteria = widget.currentPrimaryCriteria;
    currentSecondaryCriteria = widget.currentSecondaryCriteria ?? [];

    initializeDefaultFilter();
  }

  void initializeDefaultFilter() async {
    final isDefault = await PreferencesController()
        .getBool(widget.getSearchDefaultPreferenceKey());

    setState(() => isDefaultFilter = isDefault);
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
                        currentSecondaryCriteria.clear();
                        currentPrimaryCriteria = "All";
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
                widget.getPrimaryCriteriaLabel(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  openBottomSheet(
                    context,
                    FilterList(
                      values: widget.getPrimaryCriteriaChoices(),
                      onSelectItem: (tag) {
                        setState(() => currentPrimaryCriteria = tag);
                      },
                    ),
                    widget.getAnalyticsPrimaryCriteria(),
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
                    currentPrimaryCriteria,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
              if (currentPrimaryCriteria != 'All') ...[
                SizedBox(height: 25),
                Text(
                  widget.getSecondaryCriteriaLabel(),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    openBottomSheet(
                      context,
                      FilterList(
                        values: widget.getSecondaryCriteriaChoices(),
                        onSelectItem: (tag) => setState(() {
                          if (!currentSecondaryCriteria.contains(tag)) {
                            if (!widget.isSecondaryMultiSelect &&
                                currentSecondaryCriteria.length == 1) {
                              currentSecondaryCriteria.clear();
                            }
                            currentSecondaryCriteria.add(tag);
                          } else {
                            currentSecondaryCriteria.remove(tag);
                          }
                        }),
                        selectedItems: currentSecondaryCriteria,
                      ),
                      widget.getAnalyticsSecondaryCriteria(),
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
                      currentSecondaryCriteria.isNotEmpty
                          ? currentSecondaryCriteria.reduce(
                              (value, element) => value + ", " + element)
                          : "",
                      style: Theme.of(context).textTheme.bodyText1,
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
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: textColor.withOpacity(0.8)),
                    )
                  ],
                ),
              ),
              SizedBox(height: 25),
              Ovie.FilledButton(
                text: "FILTER SEARCH",
                margin: EdgeInsets.zero,
                foregroundColor: Colors.white,
                backgroundColor: backgroundColor,
                onPressed: () {
                  Navigator.pop(context);

                  PreferencesController().saveBool(
                      widget.getSearchDefaultPreferenceKey(), isDefaultFilter);

                  PreferencesController().saveString(
                      widget.getPrimaryCriteriaPreferenceKey(),
                      currentPrimaryCriteria);

                  currentSecondaryCriteria.forEach(
                    (diet) => PreferencesController().addToStringList(
                        widget.getSecondaryCriteriaPreferenceKey(), diet),
                  );

                  widget.onSearchPressed
                      ?.call(currentPrimaryCriteria, currentSecondaryCriteria);
                },
              )
            ],
          ),
        ),
      );
}

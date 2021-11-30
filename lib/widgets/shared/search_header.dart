import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/search_header_secondary_filter.dart';

class SearchHeader extends StatelessWidget {
  final formKey;
  final TextEditingController searchController;
  final List<String> tagValues;
  final String tagValueSelected;
  final Function(String) onTagSelected;
  final Function onSearchClicked;
  final bool isSearching;
  final List<MultiSelectItem<String>> tagValuesSecondary;
  final List<String> tagValuesSelectedSecondary;
  final Function(List<String>) onSecondaryTagSelected;
  final List<Module> modules;
  final int selectedModule;
  final String selectedModuleTitle;
  final Function(String) onModuleSelected;

  SearchHeader({
    @required this.formKey,
    @required this.searchController,
    @required this.tagValues,
    @required this.tagValueSelected,
    @required this.onTagSelected,
    @required this.onSearchClicked,
    @required this.isSearching,
    this.tagValuesSecondary,
    this.tagValuesSelectedSecondary,
    this.onSecondaryTagSelected,
    this.modules,
    this.selectedModule,
    this.selectedModuleTitle,
    this.onModuleSelected,
  });

  void _clearTextAndSearch() {
    if (searchController.text.trim().length > 0) {
      searchController.clear();
      onSearchClicked();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMultiFilter =
        tagValuesSecondary != null && tagValuesSecondary.length > 0;
    final bool hasModulesDropdown = modules != null && modules.length > 0;
    var size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width - 130,
                      height: 40,
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: S.of(context).searchInputText,
                          suffixIcon: IconButton(
                            onPressed: () => _clearTextAndSearch(),
                            icon: Icon(Icons.clear, color: secondaryColor),
                          ),
                        ),
                      ),
                    ),
                    ColorButton(
                      width: 70,
                      isUpdating: isSearching,
                      label: S.of(context).searchInputText,
                      onTap: () {
                        onSearchClicked();
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    tagValues.length > 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Text(
                                    S.of(context).searchHeaderFilterText,
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: tagValueSelected,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: primaryColor,
                                  ),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: secondaryColor),
                                  underline: Container(
                                    height: 2,
                                    color: primaryColor,
                                  ),
                                  onChanged: (String newValue) {
                                    onTagSelected(newValue);
                                  },
                                  items: tagValues
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                isMultiFilter
                                    ? SearchHeaderSecondaryFilter(
                                        tagValuesSecondary: tagValuesSecondary,
                                        tagValuesSelectedSecondary:
                                            tagValuesSelectedSecondary,
                                        onSecondaryTagSelected:
                                            onSecondaryTagSelected)
                                    : Container(),
                              ])
                        : hasModulesDropdown
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: Text(
                                        S.of(context).searchHeaderFilterText,
                                      ),
                                    ),
                                    DropdownButton<String>(
                                      value: selectedModule.toString(),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: primaryColor,
                                      ),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: secondaryColor),
                                      underline: Container(
                                        height: 2,
                                        color: primaryColor,
                                      ),
                                      onChanged: (String newValue) {
                                        onModuleSelected(newValue);
                                      },
                                      items: modules.map((Module module) {
                                        return DropdownMenuItem<String>(
                                          value: module.moduleID.toString(),
                                          child: Text(module.title),
                                        );
                                      }).toList(),
                                    ),
                                  ])
                            : Container(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

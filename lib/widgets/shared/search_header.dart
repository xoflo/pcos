import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';

class SearchHeader extends StatelessWidget {
  final Size screenSize;
  final TextEditingController searchController;
  final List<String> tagValues;
  final String tagValueSelected;
  final Function(String) onTagSelected;
  final Function onSearchClicked;
  final bool isSearching;
  final List<MultiSelectItem<String>> tagValuesSecondary;
  final List<String> tagValuesSelectedSecondary;
  final Function(List<String>) onSecondaryTagSelected;

  SearchHeader({
    @required this.screenSize,
    @required this.searchController,
    @required this.tagValues,
    @required this.tagValueSelected,
    @required this.onTagSelected,
    @required this.onSearchClicked,
    @required this.isSearching,
    this.tagValuesSecondary,
    this.tagValuesSelectedSecondary,
    this.onSecondaryTagSelected,
  });

  final _formKey = GlobalKey<FormState>();

  void clearTextAndSearch() {
    if (searchController.text.trim().length > 0) {
      searchController.clear();
      onSearchClicked();
    }
  }

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          backgroundColor: backgroundColor,
          items: tagValuesSecondary,
          initialValue: tagValuesSelectedSecondary,
          onConfirm: (values) {
            onSecondaryTagSelected(values);
          },
          searchIcon: Icon(
            Icons.search,
            color: primaryColor,
          ),
        );
      },
    );
  }

  Widget _getSecondaryDropdown(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showMultiSelect(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2.0, color: primaryColor),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 3.0,
                ),
                child: Text(
                  "More options...",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            this.tagValuesSelectedSecondary.length > 0
                ? Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircleAvatar(
                        backgroundColor: primaryColor,
                        child: Text(
                          this.tagValuesSelectedSecondary.length.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMultiFilter =
        tagValuesSecondary != null && tagValuesSecondary.length > 0;
    var size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
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
                            onPressed: () => clearTextAndSearch(),
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
                                    ? _getSecondaryDropdown(context)
                                    : Container(),
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

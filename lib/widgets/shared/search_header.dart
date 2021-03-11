import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';

class SearchHeader extends StatelessWidget {
  final TextEditingController searchController;
  final List<String> tagValues;
  final String tagValue;
  final Function(String) onTagSelected;
  final Function onSearchClicked;
  final bool isSearching;
  final int widthAdjustment;

  SearchHeader({
    @required this.searchController,
    @required this.tagValues,
    @required this.tagValue,
    @required this.onTagSelected,
    @required this.onSearchClicked,
    @required this.isSearching,
    @required this.widthAdjustment,
  });

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                      width: size.width - (28 + widthAdjustment),
                      height: 40,
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: S.of(context).searchInputText,
                          suffixIcon: IconButton(
                            onPressed: () => searchController.clear(),
                            icon: Icon(Icons.clear, color: secondaryColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).searchHeaderFilterText),
                      ),
                      tagValues.length > 0
                          ? DropdownButton<String>(
                              value: tagValue,
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
                              items: tagValues.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          : Container(),
                    ]),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ColorButton(
                        isUpdating: isSearching,
                        label: S.of(context).searchInputText,
                        onTap: () {
                          onSearchClicked();
                        },
                        width: 70,
                      ),
                    ),
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

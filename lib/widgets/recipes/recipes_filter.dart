import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/shared/spinner_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';

class RecipeFilter extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  void _performSearch() {
    debugPrint("implement the Search");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final TextEditingController searchController = TextEditingController();
    bool isSearching = false;

    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: size.width - 160,
                  height: 40,
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: S.of(context).searchInputText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    width: 120,
                    height: 40,
                    child: isSearching
                        ? SpinnerButton(width: 120, height: 40)
                        : ColorButton(
                            isUpdating: false,
                            label: S.of(context).searchInputText,
                            onTap: _performSearch,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

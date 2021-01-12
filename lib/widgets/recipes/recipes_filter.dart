import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/other/spinner_button.dart';

class RecipeFilter extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

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
              children: [
                Container(
                  width: size.width * 0.6,
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
                    width: size.width * 0.3,
                    height: 40,
                    child: isSearching
                        ? SpinnerButton()
                        : FlatButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                            ),
                            color: primaryColorDark,
                            onPressed: () {
                              debugPrint("Search");
                            },
                            child: Text(
                              S.of(context).searchInputText,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
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

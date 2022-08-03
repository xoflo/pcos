import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/screens/tabs/library/library_module_wiki_page.dart';
import 'package:thepcosprotocol_app/screens/tabs/library/library_search_list.dart';
import 'package:thepcosprotocol_app/screens/tabs/library/library_search_page.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<String> searchItems = [];

  // This parameter checks if the search items to be deleted are going to be
  // removable. When the user goes to another page, all attempts to delete
  // search items should be reset (i.e. hiding the close button)
  bool shouldRefreshForDeletion = false;

  void loadSearchItems() async {
    await PreferencesController().getStringList(SEARCH_ITEMS).then((value) {
      if (mounted) setState(() => searchItems = value);
    });
  }

  void goToLibrarySearchPage({String? searchText}) =>
      Navigator.pushNamed(context, LibrarySearchPage.id, arguments: searchText)
          .then((value) {
        loadSearchItems();
        setState(() => shouldRefreshForDeletion = true);
      });

  @override
  Widget build(BuildContext context) {
    loadSearchItems();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          color: primaryColorLight,
          child: TextFormField(
            onTap: () => goToLibrarySearchPage(),
            focusNode:
                AlwaysDisabledFocusNode(), // Tappable text field, but not editable
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              hintText: "Search",
              isDense: true,
              contentPadding: EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  if (searchItems.isNotEmpty)
                    LibrarySearchList(
                      shouldRefreshItemsForDeletion: shouldRefreshForDeletion,
                      searchItems: searchItems,
                      onLongPressSearchItem: () =>
                          setState(() => shouldRefreshForDeletion = false),
                      onTapSearchItem: (searchItem) =>
                          goToLibrarySearchPage(searchText: searchItem),
                      onRemoveSearchItem: (searchItem) =>
                          setState(() => searchItems.remove(searchItem)),
                    ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      LibraryModuleWikiPage.id,
                      arguments: true,
                    ).then((value) =>
                        setState(() => shouldRefreshForDeletion = true)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              "Module Library",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(color: backgroundColor),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Image(
                              image: AssetImage(
                                  'assets/library_previous_modules.png'),
                              height: 52,
                              width: 52,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      LibraryModuleWikiPage.id,
                      arguments: false,
                    ).then((value) {
                      setState(() => shouldRefreshForDeletion = true);
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              "Wiki Library",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(color: backgroundColor),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Image(
                              image: AssetImage(
                                  'assets/library_knowledge_base.png'),
                              height: 52,
                              width: 52,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

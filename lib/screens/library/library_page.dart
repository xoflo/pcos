import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/screens/library/library_module_wiki_page.dart';
import 'package:thepcosprotocol_app/screens/library/library_search_item.dart';
import 'package:thepcosprotocol_app/screens/library/library_search_page.dart';
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

  void loadSearchItems() async {
    await PreferencesController().getStringList(SEARCH_ITEMS).then((value) {
      if (mounted) setState(() => searchItems = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    loadSearchItems();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          color: primaryColorLight,
          child: TextFormField(
            onTap: () => Navigator.pushNamed(
              context,
              LibrarySearchPage.id,
            ).then((value) => loadSearchItems()),
            focusNode:
                AlwaysDisabledFocusNode(), // Tappable text field, but not editable
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
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
                  Container(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(vertical: 25),
                      itemCount: searchItems.length,
                      itemBuilder: (context, index) {
                        final searchItem = searchItems[index];

                        return LibrarySearchItem(
                          searchItem: searchItem,
                          onCloseTapped: () async {
                            final updatedItems = await PreferencesController()
                                .removeFromStringList(SEARCH_ITEMS, searchItem);
                            setState(() {
                              searchItems = updatedItems;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      LibraryModuleWikiPage.id,
                      arguments: true,
                    ),
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
                              style: TextStyle(
                                color: backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
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
                    ),
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
                              style: TextStyle(
                                color: backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
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

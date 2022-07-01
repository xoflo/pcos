import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/screens/library/library_search_item.dart';

class LibrarySearchList extends StatefulWidget {
  const LibrarySearchList({
    Key? key,
    required this.searchItems,
    required this.shouldRefreshItemsForDeletion,
    required this.onLongPressSearchItem,
    required this.onTapSearchItem,
    required this.onRemoveSearchItem,
  }) : super(key: key);

  final List<String> searchItems;
  final bool shouldRefreshItemsForDeletion;
  final Function onLongPressSearchItem;
  final Function(String) onTapSearchItem;
  final Function(String) onRemoveSearchItem;

  @override
  State<LibrarySearchList> createState() => _LibrarySearchListState();
}

class _LibrarySearchListState extends State<LibrarySearchList> {
  List<String> itemsForDeletion = [];

  @override
  Widget build(BuildContext context) {
    if (widget.shouldRefreshItemsForDeletion) {
      itemsForDeletion.clear();
    }

    return Container(
      height: 90,
      clipBehavior: Clip.none,
      child: ListView.builder(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(vertical: 25),
        itemCount: widget.searchItems.length,
        itemBuilder: (context, index) {
          final searchItem = widget.searchItems[index];

          return LibrarySearchItem(
              searchItem: searchItem,
              showClose: itemsForDeletion.contains(searchItem),
              onSearchItemLongPressed: () {
                widget.onLongPressSearchItem.call();
                setState(() {
                  if (!itemsForDeletion.contains(searchItem)) {
                    itemsForDeletion.add(searchItem);
                  } else {
                    itemsForDeletion.remove(searchItem);
                  }
                });
              },
              onSearchItemTapped: () => widget.onTapSearchItem(searchItem),
              onCloseTapped: () async {
                await PreferencesController()
                    .removeFromStringList(SEARCH_ITEMS, searchItem);
                widget.onRemoveSearchItem(searchItem);
              });
        },
      ),
    );
  }
}

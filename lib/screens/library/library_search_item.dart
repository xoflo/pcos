import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class LibrarySearchItem extends StatefulWidget {
  const LibrarySearchItem({
    Key? key,
    required this.searchItem,
    required this.onCloseTapped,
    required this.onSearchItemTapped,
  }) : super(key: key);

  final String searchItem;
  final Function onCloseTapped;
  final Function onSearchItemTapped;

  @override
  State<LibrarySearchItem> createState() => _LibrarySearchItemState();
}

class _LibrarySearchItemState extends State<LibrarySearchItem> {
  bool showClose = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onSearchItemTapped.call(),
      onLongPress: () => setState(() => showClose = !showClose),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: EdgeInsets.only(right: 15),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: Text(
              widget.searchItem,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: textColor.withOpacity(0.8),
              ),
            ),
          ),
          if (showClose)
            Positioned(
              top: -10,
              left: -10,
              child: GestureDetector(
                onTap: () => widget.onCloseTapped.call(),
                child: Container(
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  padding: EdgeInsets.all(2.5),
                  child: Icon(
                    Icons.close,
                    color: backgroundColor,
                    size: 20,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

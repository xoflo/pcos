import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class LibrarySearchItem extends StatefulWidget {
  const LibrarySearchItem({
    Key? key,
    required this.searchItem,
    required this.showClose,
    required this.onCloseTapped,
    required this.onSearchItemLongPressed,
    required this.onSearchItemTapped,
  }) : super(key: key);

  final String searchItem;
  final bool showClose;
  final Function onCloseTapped;
  final Function onSearchItemLongPressed;
  final Function onSearchItemTapped;

  @override
  State<LibrarySearchItem> createState() => _LibrarySearchItemState();
}

class _LibrarySearchItemState extends State<LibrarySearchItem> {
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => widget.onSearchItemTapped.call(),
        onLongPress: () {
          widget.onSearchItemLongPressed.call();
        },
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
            if (widget.showClose)
              Positioned(
                top: -10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    widget.onCloseTapped.call();
                  },
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

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';

class DialogHeader extends StatefulWidget {
  final dynamic item;
  final FavouriteType favouriteType;
  final String title;
  final bool isFavourite;
  final Function closeItem;
  final Function(dynamic, bool) addToFavourites;

  DialogHeader({
    @required this.item,
    @required this.favouriteType,
    @required this.title,
    @required this.isFavourite,
    @required this.closeItem,
    @required this.addToFavourites,
  });

  @override
  _DialogHeaderState createState() => _DialogHeaderState();
}

class _DialogHeaderState extends State<DialogHeader> {
  bool isFavouriteOnHeader = false;

  @override
  void initState() {
    super.initState();
    if (widget.isFavourite) {
      isFavouriteOnHeader = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.favouriteType == FavouriteType.None
              ? SizedBox(width: 35)
              : GestureDetector(
                  onTap: () {
                    final bool add = !isFavouriteOnHeader;
                    setState(() {
                      isFavouriteOnHeader = add;
                    });
                    widget.addToFavourites(widget.item, add);
                  },
                  child: Icon(
                    isFavouriteOnHeader
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    color: secondaryColorLight,
                    size: 35,
                  ),
                ),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          GestureDetector(
            onTap: () {
              widget.closeItem();
            },
            child: SizedBox(
              width: 35,
              height: 35,
              child: Container(
                color: primaryColorDark,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

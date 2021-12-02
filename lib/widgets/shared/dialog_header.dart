import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';

class DialogHeader extends StatefulWidget {
  final Size screenSize;
  final FavouriteType favouriteType;
  final String title;
  final bool isFavourite;
  final Function closeItem;
  final Function onAction;
  final dynamic item;
  final bool isToolkit;

  DialogHeader({
    @required this.screenSize,
    @required this.favouriteType,
    @required this.title,
    @required this.isFavourite,
    @required this.closeItem,
    @required this.onAction,
    this.item,
    this.isToolkit = false,
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

  void _onTap() async {
    final bool add = !isFavouriteOnHeader;
    final itemId = widget.favouriteType == FavouriteType.Lesson
        ? widget.item.lessonID
        : widget.favouriteType == FavouriteType.Wiki
            ? widget.item.questionId
            : widget.item.recipeId;
    Provider.of<FavouritesProvider>(context, listen: false)
        .addToFavourites(widget.favouriteType, itemId);
    await widget.onAction();
    setState(() {
      isFavouriteOnHeader = add;
    });
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
              : widget.isToolkit
                  ? Icon(
                      Icons.construction,
                      color: primaryColor,
                      size: 35,
                    )
                  : GestureDetector(
                      onTap: () {
                        _onTap();
                      },
                      child: Icon(
                        isFavouriteOnHeader
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: secondaryColor,
                        size: 35,
                      ),
                    ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Container(
              width: widget.screenSize.width - 108,
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.headline6,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.closeItem();
            },
            child: SizedBox(
              width: 35,
              height: 35,
              child: Container(
                color: primaryColor,
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

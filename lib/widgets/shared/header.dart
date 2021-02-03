import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';

class Header extends StatelessWidget {
  final int itemId;
  final FavouriteType favouriteType;
  final String title;
  final bool isFavourite;
  final Function closeItem;

  Header(
      {this.itemId,
      this.favouriteType,
      this.title,
      this.isFavourite,
      this.closeItem});

  void _addToFavourites() {
    debugPrint("Add to favourites - id=$itemId type=$favouriteType");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          favouriteType == FavouriteType.None
              ? SizedBox(width: 35)
              : GestureDetector(
                  onTap: () {
                    _addToFavourites();
                  },
                  child: Icon(
                    isFavourite ? Icons.favorite : Icons.favorite_outline,
                    color: primaryColorDark,
                    size: 35,
                  ),
                ),
          Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
          GestureDetector(
            onTap: () {
              closeItem();
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

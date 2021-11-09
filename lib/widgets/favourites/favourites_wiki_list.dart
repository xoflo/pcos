import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_wiki_item.dart';

class FavouritesWikiList extends StatelessWidget {
  final List<LessonWiki> lessonWikis;
  final double width;
  final bool isToolkit;
  final Function(FavouriteType, int) removeFavourite;
  final Function(FavouriteType, dynamic) openFavourite;

  FavouritesWikiList({
    @required this.lessonWikis,
    @required this.width,
    @required this.isToolkit,
    @required this.removeFavourite,
    @required this.openFavourite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: lessonWikis.map((LessonWiki lessonWiki) {
        return FavouritesWikiItem(
          lessonWiki: lessonWiki,
          width: width,
          isToolkit: isToolkit,
          removeFavourite: removeFavourite,
          openFavourite: openFavourite,
        );
      }).toList(),
    );
  }
}

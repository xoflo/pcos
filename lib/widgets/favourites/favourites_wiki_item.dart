import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class FavouritesWikiItem extends StatelessWidget {
  final LessonWiki lessonWiki;
  final double width;
  final bool isToolkit;
  final Function(FavouriteType, dynamic) removeFavourite;
  final Function(FavouriteType, dynamic) openFavourite;

  FavouritesWikiItem({
    @required this.lessonWiki,
    @required this.width,
    @required this.isToolkit,
    @required this.removeFavourite,
    @required this.openFavourite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width - 75,
                child: Text(
                  lessonWiki.question,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              isToolkit
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        removeFavourite(FavouriteType.Wiki, lessonWiki);
                      },
                      child: Icon(
                        Icons.delete,
                        size: 24.0,
                        color: secondaryColor,
                      ),
                    ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GestureDetector(
              onTap: () {
                openFavourite(FavouriteType.Wiki, lessonWiki);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Text(
                      S.of(context).favouritesViewWiki,
                      style: TextStyle(color: secondaryColor),
                    ),
                  ),
                  Icon(
                    Icons.open_in_new,
                    size: 26.0,
                    color: secondaryColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Divider(
              color: primaryColor,
            ),
          )
        ],
      ),
    );
  }
}

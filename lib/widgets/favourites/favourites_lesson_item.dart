import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class FavouritesLessonItem extends StatelessWidget {
  final Lesson lesson;
  final double width;
  final bool isToolkit;
  final Function(FavouriteType, dynamic) removeFavourite;
  final Function(FavouriteType, dynamic) openFavourite;

  FavouritesLessonItem({
    @required this.lesson,
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
                  lesson.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              isToolkit
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        removeFavourite(FavouriteType.Lesson, lesson);
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
            child: Container(
              width: width,
              child: HtmlWidget(lesson.introduction),
            ),
          ),
          GestureDetector(
            onTap: () {
              openFavourite(FavouriteType.Lesson, lesson);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Text(
                    S.of(context).favouritesViewLesson,
                    style: TextStyle(color: secondaryColor),
                  ),
                ),
                Icon(
                  Icons.play_circle_fill,
                  size: 30.0,
                  color: secondaryColor,
                ),
              ],
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

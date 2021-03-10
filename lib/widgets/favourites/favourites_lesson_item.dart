import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class FavouritesLessonItem extends StatelessWidget {
  final Lesson lesson;
  final double width;
  final Function(FavouriteType, int, bool) removeFavourite;
  final Function(FavouriteType, dynamic) openFavourite;

  FavouritesLessonItem({
    @required this.lesson,
    @required this.width,
    @required this.removeFavourite,
    @required this.openFavourite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
            GestureDetector(
              onTap: () {
                removeFavourite(FavouriteType.Lesson, lesson.lessonId, false);
              },
              child: Icon(
                Icons.delete,
                size: 24.0,
                color: secondaryColor,
              ),
            ),
          ],
        ),
        Container(
          width: width,
          child: Text(
            lesson.description,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Text("Watch now"),
            ),
            GestureDetector(
              onTap: () {
                openFavourite(FavouriteType.Lesson, lesson);
              },
              child: Icon(
                Icons.play_circle_fill,
                size: 30.0,
                color: secondaryColor,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: Divider(
            color: primaryColor,
          ),
        )
      ],
    );
  }
}

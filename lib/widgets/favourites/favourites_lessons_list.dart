import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_lesson_item.dart';

class FavouritesLessonsList extends StatelessWidget {
  final List<Lesson> lessons;
  final double width;
  final Function(FavouriteType, int, bool) removeFavourite;
  final Function(FavouriteType, dynamic) openFavourite;

  FavouritesLessonsList({
    @required this.lessons,
    @required this.width,
    @required this.removeFavourite,
    @required this.openFavourite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: lessons.map((Lesson lesson) {
        return FavouritesLessonItem(
          lesson: lesson,
          width: width,
          removeFavourite: removeFavourite,
          openFavourite: openFavourite,
        );
      }).toList(),
    );
  }
}

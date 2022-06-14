import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class LibraryPreviousModuleItemLesson extends StatefulWidget {
  const LibraryPreviousModuleItemLesson({
    Key? key,
    required this.favouritesProvider,
    required this.lesson,
  }) : super(key: key);

  final FavouritesProvider favouritesProvider;
  final Lesson lesson;

  @override
  State<LibraryPreviousModuleItemLesson> createState() =>
      _LibraryPreviousModuleItemLessonState();
}

class _LibraryPreviousModuleItemLessonState
    extends State<LibraryPreviousModuleItemLesson> {
  bool? isFavorite;

  @override
  Widget build(BuildContext context) {
    if (isFavorite == null) {
      isFavorite = widget.favouritesProvider.isFavourite(
        FavouriteType.Lesson,
        widget.lesson.lessonID,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.lesson.title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: backgroundColor,
              fontSize: 16,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            widget.favouritesProvider.addToFavourites(
              FavouriteType.Lesson,
              widget.lesson.lessonID,
            );
            setState(() {
              isFavorite = !(isFavorite ?? true);
            });
          },
          icon: Icon(
            isFavorite == true ? Icons.favorite : Icons.favorite_outline,
            color: redColor,
          ),
        )
      ],
    );
  }
}

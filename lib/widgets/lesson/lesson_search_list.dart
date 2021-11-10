import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_card.dart';

class LessonSearchList extends StatelessWidget {
  final bool isComplete;
  final ModulesProvider modulesProvider;
  final Function(Lesson, ModulesProvider) openLesson;

  LessonSearchList({
    @required this.isComplete,
    @required this.modulesProvider,
    @required this.openLesson,
  });

  void _openLesson(final Lesson lesson) {
    this.openLesson(lesson, this.modulesProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: modulesProvider.searchLessons.map((Lesson lesson) {
          return lesson.isComplete == this.isComplete
              ? LessonCard(
                  lessonNumber: 0,
                  lesson: lesson,
                  lessonFavourite: lesson.isFavorite,
                  isNew: false,
                  openLesson: _openLesson,
                  isSearch: true,
                  refreshPreviousModules: () {},
                )
              : Container();
        }).toList(),
      ),
    );
  }
}

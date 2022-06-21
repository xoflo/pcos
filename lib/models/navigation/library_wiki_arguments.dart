import 'package:thepcosprotocol_app/models/lesson_wiki.dart';

class LibraryWikiArguments {
  final String moduleTitle;
  final List<LessonWiki> lessonWikis;

  LibraryWikiArguments(
    this.moduleTitle,
    this.lessonWikis,
  );
}

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/question.dart';

class LessonWikiFull extends StatelessWidget {
  final Question wiki;
  final Function closeWiki;
  final Function(Question) addToFavourites;

  LessonWikiFull({
    @required this.wiki,
    @required this.closeWiki,
    @required this.addToFavourites,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

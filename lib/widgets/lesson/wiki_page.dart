import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/question_list.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class WikiPage extends StatelessWidget {
  final bool isHorizontal;
  final List<Question> wikis;

  WikiPage({
    @required this.isHorizontal,
    @required this.wikis,
  });

  void _addFavourite(final FavouriteType favouriteType, final Question question,
      final bool add) async {}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              S.of(context).lessonWiki,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: QuestionList(
              questions: this.wikis,
              showIcon: true,
              iconData: Icons.favorite_outline,
              iconDataOn: Icons.favorite,
              iconAction: _addFavourite,
            ),
          ),
        ],
      ),
    );
  }
}

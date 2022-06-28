import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/question_list.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class WikiPage extends StatelessWidget {
  final bool isHorizontal;
  final List<LessonWiki> wikis;
  final BuildContext parentContext;

  WikiPage({
    required this.isHorizontal,
    required this.wikis,
    required this.parentContext,
  });

  void _addToFavourites(
      FavouriteType favouriteType, final dynamic item, final bool add) async {
    Provider.of<FavouritesProvider>(parentContext, listen: false)
        .addToFavourites(favouriteType, item.questionId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              S.current.lessonWiki,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          this.wikis.length > 0
              ? QuestionList(
                  questions: [],
                  wikis: this.wikis,
                  showIcon: true,
                  iconData: Icons.favorite_outline,
                  iconDataOn: Icons.favorite,
                  iconAction: _addToFavourites,
                )
              : Container(),
        ],
      ),
    );
  }
}
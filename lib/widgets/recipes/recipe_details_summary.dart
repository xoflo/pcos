import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/view_models/recipe_view_model.dart';

class RecipeDetailsSummary extends StatelessWidget {
  final RecipeViewModel recipe;

  RecipeDetailsSummary({this.recipe});

  List<Column> _getSummaryIcons(BuildContext context) {
    List<Column> summaryIcons = List<Column>();

    summaryIcons.add(_iconColumn(
      context,
      Icons.restaurant,
      primaryColorDark,
      recipe.servings.toString(),
    ));

    summaryIcons.add(_iconColumn(
      context,
      Icons.timer,
      primaryColorDark,
      recipe.durationMinutes.toString() + " " + S.of(context).minutesShort,
    ));

    summaryIcons.add(_iconColumn(
      context,
      Icons.sort,
      _getDifficultyColor(recipe.difficulty),
      _getDifficultyText(
        context,
        recipe.difficulty,
      ),
    ));

    return summaryIcons;
  }

  Column _iconColumn(BuildContext context, IconData icon, Color iconColor,
      String displayText) {
    return Column(children: [
      Icon(
        icon,
        size: 30.0,
        color: iconColor,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          displayText,
          style: Theme.of(context).textTheme.headline4.copyWith(
                color: textColor,
              ),
        ),
      ),
    ]);
  }

  String _getDifficultyText(BuildContext context, int difficulty) {
    switch (difficulty) {
      case 0:
        return S.of(context).recipeDifficultyEasy;
      case 1:
        return S.of(context).recipeDifficultyMedium;
      case 2:
        return S.of(context).recipeDifficultyHard;
    }
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 0:
        return Colors.green;
      case 1:
        return primaryColor;
      case 2:
        return darkAlternative;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _getSummaryIcons(context),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500, maxHeight: 670),
            child: Image.network(recipe.thumbnail),
          ),
        ),
      ],
    );
  }
}

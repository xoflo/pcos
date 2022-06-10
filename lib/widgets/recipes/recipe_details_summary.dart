import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/utils/datetime_utils.dart';

class RecipeDetailsSummary extends StatelessWidget {
  final Recipe? recipe;

  RecipeDetailsSummary({this.recipe});

  List<Column> _getSummaryIcons(BuildContext context) {
    List<Column> summaryIcons = [];

    summaryIcons.add(_iconColumn(
      context,
      Icons.restaurant,
      primaryColor,
      (recipe?.servings).toString(),
    ));

    summaryIcons.add(_iconColumn(
      context,
      Icons.timer,
      primaryColor,
      DateTimeUtils.convertMillisecondsToMinutes(recipe?.duration ?? 0)
              .toString() +
          " " +
          S.current.minutesShort,
    ));

    summaryIcons.add(_iconColumn(
      context,
      Icons.sort,
      _getDifficultyColor(recipe?.difficulty ?? -1),
      _getDifficultyText(
        context,
        recipe?.difficulty ?? -1,
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
          style: Theme.of(context).textTheme.headline4?.copyWith(
                color: iconColor,
              ),
        ),
      ),
    ]);
  }

  String _getDifficultyText(BuildContext context, int difficulty) {
    switch (difficulty) {
      case 1:
        return S.current.recipeDifficultyEasy;
      case 2:
        return S.current.recipeDifficultyMedium;
      case 3:
        return S.current.recipeDifficultyHard;
    }
    return "";
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.redAccent;
    }
    return primaryColor;
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Text(recipe?.description ?? ""),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: FadeInImage.memoryNetwork(
              alignment: Alignment.center,
              placeholder: kTransparentImage,
              image: recipe?.thumbnail ?? "",
              fit: BoxFit.fitWidth,
              width: double.maxFinite,
              height: 300,
            ),
          ),
        ),
      ],
    );
  }
}

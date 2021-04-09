import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/utils/datetime_utils.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

class RecipeDetailsSummary extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailsSummary({this.recipe});

  List<Column> _getSummaryIcons(BuildContext context) {
    List<Column> summaryIcons = [];

    summaryIcons.add(_iconColumn(
      context,
      Icons.restaurant,
      primaryColor,
      recipe.servings.toString(),
    ));

    summaryIcons.add(_iconColumn(
      context,
      Icons.timer,
      primaryColor,
      DateTimeUtils.convertMillisecondsToMinutes(recipe.duration).toString() +
          " " +
          S.of(context).minutesShort,
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
    return "";
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 0:
        return Colors.green;
      case 1:
        return primaryColor;
      case 2:
        return tertiaryColor;
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
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: FadeInImage.memoryNetwork(
              alignment: Alignment.center,
              placeholder: kTransparentImage,
              image:
                  "${FlavorConfig.instance.values.imageStorageUrl}${recipe.thumbnail}",
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

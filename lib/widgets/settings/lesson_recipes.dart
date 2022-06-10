import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class LessonRecipes extends StatelessWidget {
  final bool isLessonRecipesOn;
  final Function(bool) saveLessonRecipes;

  LessonRecipes({
    required this.isLessonRecipesOn,
    required this.saveLessonRecipes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.settingsLessonRecipesText,
                style: Theme.of(context).textTheme.headline5,
              ),
              Switch(
                value: isLessonRecipesOn,
                onChanged: (value) {
                  saveLessonRecipes(value);
                },
                activeTrackColor: secondaryColor,
                activeColor: secondaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

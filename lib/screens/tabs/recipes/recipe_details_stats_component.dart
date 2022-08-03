import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class RecipeDetailsStatsComponent extends StatelessWidget {
  const RecipeDetailsStatsComponent({
    Key? key,
    required this.duration,
    required this.servings,
    required this.difficulty,
  }) : super(key: key);

  final int? duration;
  final int? servings;
  final String difficulty;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Divider(
              thickness: 1,
              height: 1,
              color: textColor.withOpacity(0.5),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "Serves",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(color: textColor.withOpacity(0.8)),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "$servings",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: textColor.withOpacity(0.8)),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Duration",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(color: textColor.withOpacity(0.8)),
                    ),
                    SizedBox(height: 15),
                    Text(
                      Duration(milliseconds: duration ?? 0)
                              .inMinutes
                              .toString() +
                          " " +
                          S.current.minutesShort,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: textColor.withOpacity(0.8)),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Difficulty",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(color: textColor.withOpacity(0.8)),
                    ),
                    SizedBox(height: 15),
                    Text(
                      difficulty,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: textColor.withOpacity(0.8)),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            Divider(
              thickness: 1,
              height: 1,
              color: textColor.withOpacity(0.5),
            ),
          ],
        ),
      );
}

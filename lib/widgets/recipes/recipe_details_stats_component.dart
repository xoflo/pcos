import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/datetime_utils.dart';

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
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: textColor.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "$servings",
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.8),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Duration",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: textColor.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      DateTimeUtils.convertMillisecondsToMinutes(duration ?? 0)
                              .toString() +
                          " " +
                          S.current.minutesShort,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.8),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Difficulty",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: textColor.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      difficulty,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.8),
                      ),
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

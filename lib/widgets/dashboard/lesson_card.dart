import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/new_indicator.dart';

class LessonCard extends StatelessWidget {
  final int lessonId;
  final bool isNew;

  LessonCard({@required this.lessonId, @required this.isNew});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Lesson $lessonId",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 16),
                ),
                Text(
                  "Afternoon Cravings",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "In the final lesson of the Reducing Sugar module we look at how you can avoid those afternoon snack cravings, and choose a healthier alternative.",
                    textAlign: TextAlign.justify,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Listen now",
                        style: TextStyle(color: secondaryColorLight)),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Icon(
                        Icons.volume_up,
                        color: secondaryColorLight,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isNew ? NewIndicator() : Container(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class PreviousLessonsNavigator extends StatelessWidget {
  final String title;
  final int titleNumber;

  PreviousLessonsNavigator({@required this.title, @required this.titleNumber});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.first_page,
          color: secondaryColor,
          size: 30,
        ),
        Icon(
          Icons.chevron_left,
          color: secondaryColor,
          size: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: 100,
            child: Align(
              alignment: Alignment.center,
              child: Text("$title $titleNumber"),
            ),
          ),
        ),
        Icon(
          Icons.chevron_right,
          color: secondaryColor,
          size: 30,
        ),
        Icon(
          Icons.skip_next,
          color: secondaryColor,
          size: 30,
        ),
      ],
    );
  }
}

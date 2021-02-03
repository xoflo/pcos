import 'package:flutter/material.dart';

class TextThemes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Headline 1 Text",
          style: Theme.of(context).textTheme.headline1,
        ),
        Text(
          "Headline 2 Text",
          style: Theme.of(context).textTheme.headline2,
        ),
        Text(
          "Headline 3 Text",
          style: Theme.of(context).textTheme.headline3,
        ),
        Text(
          "Headline 4 Text",
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          "Headline 5 Text",
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          "Headline 6 Text",
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(
          "BodyText 1 Text (default text)",
        ),
        Text(
          "BodyText 2 Text",
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }
}

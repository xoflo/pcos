import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class NoResults extends StatelessWidget {
  final String? message;

  NoResults({this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Text(
            message ?? "",
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: textColor),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Icon(
              Icons.block,
              color: textColor,
              size: 60.0,
            ),
          ),
        ],
      ),
    );
  }
}

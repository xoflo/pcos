import 'package:flutter/material.dart';

class PinCorrect extends StatelessWidget {
  final String message;

  PinCorrect({this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              message,
              style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          SizedBox(
            child: Icon(
              Icons.thumb_up_rounded,
              size: 48.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
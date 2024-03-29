import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class PinCorrect extends StatelessWidget {
  final String message;
  final String? messageWhy;

  PinCorrect({required this.message, this.messageWhy});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Text(
                message,
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: textColor,
                    ),
              ),
            ),
            SizedBox(
              child: Icon(
                Icons.thumb_up_rounded,
                size: 48.0,
                color: textColor,
              ),
            ),
            messageWhy != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Text(
                      messageWhy ?? "",
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: textColor,
                          ),
                    ),
                  )
                : Container()
          ],
        ),
      );
}

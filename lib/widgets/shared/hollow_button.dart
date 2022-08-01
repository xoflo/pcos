import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class HollowButton extends StatelessWidget {
  const HollowButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.style,
      required this.margin,
      this.verticalPadding = 15,
      this.width = double.infinity,
      this.isUpdating = false,
      this.textAlignment = Alignment.center})
      : super(key: key);

  final Function()? onPressed;
  final String text;
  final ButtonStyle style;
  final EdgeInsetsGeometry margin;
  final double width;
  final double verticalPadding;
  final bool isUpdating;
  final textAlignment;

  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        width: width,
        child: OutlinedButton(
          onPressed: isUpdating ? null : onPressed,
          child: Padding(
            padding: EdgeInsets.all(verticalPadding),
            child: isUpdating
                ? SizedBox(
                    child: CircularProgressIndicator(
                      backgroundColor: backgroundColor,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                    height: 20.0,
                    width: 20.0,
                  )
                : Align(
                    alignment: textAlignment,
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
          ),
          style: style,
        ),
      );
}

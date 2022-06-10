import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class HollowButton extends StatelessWidget {
  const HollowButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.style,
    required this.margin,
    this.verticalPadding = 15,
    this.width = double.infinity,
    this.isUpdating = false,
  }) : super(key: key);

  final Function() onPressed;
  final String text;
  final ButtonStyle style;
  final EdgeInsetsGeometry margin;
  final double width;
  final double verticalPadding;
  final bool isUpdating;

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
                : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
          style: style,
        ),
      );
}

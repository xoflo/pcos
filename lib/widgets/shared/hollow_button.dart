import 'package:flutter/material.dart';

class HollowButton extends StatelessWidget {
  const HollowButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.style,
    required this.margin,
    this.verticalPadding = 15,
    this.width = double.infinity,
  }) : super(key: key);

  final Function() onPressed;
  final String text;
  final ButtonStyle style;
  final EdgeInsetsGeometry margin;
  final double width;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        width: width,
        child: OutlinedButton(
          onPressed: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding,
            ),
            child: Text(
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

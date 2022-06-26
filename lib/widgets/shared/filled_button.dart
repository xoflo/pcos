import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class FilledButton extends StatelessWidget {
  const FilledButton({
    Key? key,
    required this.text,
    required this.margin,
    required this.foregroundColor,
    required this.backgroundColor,
    this.icon,
    this.onPressed,
    this.width = double.infinity,
    this.isUpdating = false,
    this.isRoundedButton = false,
  }) : super(key: key);

  final Function()? onPressed;
  final Widget? icon;
  final String text;
  final double width;
  final EdgeInsetsGeometry margin;
  final Color foregroundColor;
  final Color backgroundColor;
  final bool isUpdating;
  final bool isRoundedButton;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        margin: margin,
        child: ElevatedButton(
          onPressed: isUpdating ? null : onPressed,
          child: Padding(
            padding: EdgeInsets.all(icon != null ? 10 : 15),
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
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...{
                        icon!,
                        SizedBox(
                          width: 10,
                        )
                      },
                      Text(
                        text,
                      ),
                    ],
                  ),
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              return Colors.white;
            }),
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.disabled)) {
                return backgroundColor.withOpacity(0.5);
              }
              return backgroundColor;
            }),
            textStyle: MaterialStateProperty.resolveWith(
              (states) => const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
              (states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isRoundedButton ? 16 : 12),
              ),
            ),
          ),
        ),
      );
}

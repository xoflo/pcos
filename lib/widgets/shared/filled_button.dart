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
    this.borderColor,
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
  final Color? borderColor;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        margin: margin,
        child: ElevatedButton(
          onPressed: isUpdating ? null : onPressed,
          child: FittedBox(
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
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
            ),
          ),
          style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                return foregroundColor;
              }),
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled)) {
                  return backgroundColor.withOpacity(0.5);
                }
                return backgroundColor;
              }),
              textStyle: MaterialStateProperty.resolveWith(
                (states) => Theme.of(context).textTheme.button,
              ),
              shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                (states) => RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(isRoundedButton ? 16 : 12),
                ),
              ),
              side: MaterialStateProperty.all(BorderSide(
                  color: borderColor != null ? foregroundColor : Colors.transparent, width: 1.0, style: BorderStyle.solid)
                )
              ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class ColorButton extends StatelessWidget {
  final bool isUpdating;
  final String label;
  final Function onTap;
  final Color color;
  final Color textColor;
  final double width;

  ColorButton({
    @required this.isUpdating,
    @required this.label,
    @required this.onTap,
    this.color = primaryColor,
    this.textColor = Colors.white,
    this.width = 100,
  });

  Color getBackgroundColor(Set<MaterialState> states) {
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith(getBackgroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ))),
      onPressed: () {
        if (!isUpdating) {
          onTap();
        }
      },
      child: isUpdating
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: (width - 20) / 2),
                  child: SizedBox(
                    child: CircularProgressIndicator(
                      backgroundColor: backgroundColor,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                    height: 20.0,
                    width: 20.0,
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: width,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
    );
  }
}

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
    this.width = 0,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(5.0),
      ),
      color: color,
      onPressed: () {
        if (!isUpdating) {
          onTap();
        }
      },
      child: isUpdating
          ? Container(
              width: width,
              child: Container(
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
          : Text(
              label,
              style: TextStyle(
                color: textColor,
              ),
            ),
    );
  }
}

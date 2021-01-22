import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class ColorButton extends StatelessWidget {
  final String label;
  final Function onTap;
  final Color color;
  final Color textColor;

  ColorButton({
    this.label,
    this.onTap,
    this.color = primaryColorDark,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(5.0),
      ),
      color: color,
      onPressed: () {
        onTap();
      },
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}

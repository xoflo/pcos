import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class StandardButton extends StatelessWidget {
  final String label;
  final Function onTap;
  final Color color;

  StandardButton({this.label, this.onTap, this.color = primaryColorDark});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all<BorderSide>(BorderSide(color: color)),
      ),
      onPressed: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          label,
          style: TextStyle(
            color: color,
          ),
        ),
      ),
    );
  }
}

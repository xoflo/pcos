import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class StandardButton extends StatelessWidget {
  final bool isUpdating;
  final String label;
  final Function onTap;
  final Color color;

  StandardButton({
    @required this.isUpdating,
    @required this.label,
    @required this.onTap,
    this.color = primaryColorDark,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all<BorderSide>(BorderSide(color: color)),
      ),
      onPressed: () {
        onTap();
      },
      child: isUpdating
          ? SizedBox(
              child: CircularProgressIndicator(
                backgroundColor: backgroundColor,
                valueColor: new AlwaysStoppedAnimation<Color>(primaryColorDark),
              ),
              height: 20.0,
              width: 20.0,
            )
          : Padding(
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

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class SpinnerButton extends StatelessWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  final Color borderColor;
  final Color spinnerColor;

  SpinnerButton({
    required this.width,
    required this.height,
    this.backgroundColor = Colors.white,
    this.borderColor = primaryColor,
    this.spinnerColor = primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              backgroundColor: backgroundColor,
              valueColor: new AlwaysStoppedAnimation<Color>(spinnerColor),
            ),
            height: 20.0,
            width: 20.0,
          ),
        ),
      ),
    );
  }
}

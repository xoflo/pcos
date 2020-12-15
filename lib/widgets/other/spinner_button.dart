import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class SpinnerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: primaryColorDark,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
            ),
            height: 20.0,
            width: 20.0,
          ),
        ),
      ),
    );
  }
}

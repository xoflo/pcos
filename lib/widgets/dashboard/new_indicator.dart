import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class NewIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 4.0,
          right: 2.0,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 36.0,
                left: 22,
              ),
              child: Text("New",
                  style: TextStyle(
                    fontSize: 14,
                    color: primaryColorDark,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Icon(
                Icons.stars,
                size: 40.0,
                color: primaryColorDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

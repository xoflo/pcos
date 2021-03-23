import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class YourWhy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "Your why:",
                style: TextStyle(
                  fontFamily: 'Courgette',
                  fontSize: 20,
                  color: primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30.0,
                left: 40,
                right: 20,
                bottom: 8,
              ),
              child: Text(
                "I want to feel healthier and be able to live my life happier.",
                style: TextStyle(
                  fontFamily: 'Courgette',
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

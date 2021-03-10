import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class LessonMiniCard extends StatelessWidget {
  final Size screenSize;
  final int moduleNumber;
  final String moduleName;

  LessonMiniCard(
      {@required this.screenSize,
      @required this.moduleNumber,
      @required this.moduleName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 4.0,
          ),
          child: Container(
            width: screenSize.width * 0.5,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: secondaryColorLight, width: 2.0),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  moduleName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondaryColorLight,
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 0.0,
              top: 0,
            ),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircleAvatar(
                backgroundColor: secondaryColorLight,
                child: Text(
                  moduleNumber.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

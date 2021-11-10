import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class ModuleCard extends StatelessWidget {
  final Size screenSize;
  final int moduleNumber;
  final String moduleName;
  final bool isSelected;

  ModuleCard({
    @required this.screenSize,
    @required this.moduleNumber,
    @required this.moduleName,
    @required this.isSelected,
  });

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
              color: isSelected ? backgroundColor : Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                  color: primaryColor, width: isSelected ? 3.0 : 2.0),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  moduleName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
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
              height: isSelected ? 24 : 20,
              width: isSelected ? 24 : 20,
              child: CircleAvatar(
                backgroundColor: primaryColor,
                child: Text(
                  moduleNumber.toString(),
                  style: TextStyle(
                    fontSize: isSelected ? 14 : 12,
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

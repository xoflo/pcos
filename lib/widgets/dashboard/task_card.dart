import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/progress/progress_slider.dart';

class TaskCard extends StatelessWidget {
  final Size screenSize;
  final bool isHorizontal;
  final Function onSubmit;

  TaskCard({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ProgressSlider(
            screenSize: screenSize,
            isHorizontal: isHorizontal,
            onSubmit: onSubmit,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class ToggleSwitch extends StatefulWidget {
  const ToggleSwitch({
    Key? key,
    required this.leftText,
    required this.rightText,
    this.onTapLeft,
    this.onTapRight,
  }) : super(key: key);

  final String leftText;
  final String rightText;
  final Function()? onTapLeft;
  final Function()? onTapRight;

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  double xAlign = -1;
  Color selectedColor = Colors.white;
  Color regularColor = textColor.withOpacity(0.5);

  late Color leftColor;
  late Color rightColor;

  @override
  void initState() {
    super.initState();
    leftColor = selectedColor;
    rightColor = regularColor;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: primaryColorLight,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(xAlign, 0),
            duration: Duration(milliseconds: 300),
            child: Container(
              width: width * 0.48,
              height: 40,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (xAlign != -1) {
                  widget.onTapLeft?.call();
                }
                xAlign = -1;
                leftColor = selectedColor;
                rightColor = regularColor;
              });
            },
            child: Align(
              alignment: Alignment(-1, 0),
              child: Container(
                width: width * 0.48,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  widget.leftText,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(color: leftColor),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (xAlign != 1) {
                  widget.onTapRight?.call();
                }
                xAlign = 1;
                rightColor = selectedColor;
                leftColor = regularColor;
              });
            },
            child: Align(
              alignment: Alignment(1, 0),
              child: Container(
                width: width * 0.48,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  widget.rightText,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(color: rightColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

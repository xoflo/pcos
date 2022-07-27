import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/drawing_utils.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class PinPad extends StatelessWidget {
  final double pinButtonSize;
  final String headerText;
  final String subheaderText;
  final List<bool> progress;
  final int currentPosition;
  final bool? showForgottenPin;
  final Function removeLastPinCharacter;
  final Function(String) pinButtonPressed;
  final Function(BuildContext)? forgotPin;

  PinPad({
    required this.pinButtonSize,
    required this.headerText,
    required this.subheaderText,
    required this.progress,
    required this.currentPosition,
    required this.showForgottenPin,
    required this.pinButtonPressed,
    required this.removeLastPinCharacter,
    this.forgotPin,
  });

  SizedBox pinProgress() {
    return SizedBox(
      width: 140,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          pinProgressItem(0),
          pinProgressItem(1),
          pinProgressItem(2),
          pinProgressItem(3)
        ],
      ),
    );
  }

  Stack pinProgressItem(final int position) {
    final isComplete = progress[position];
    return Stack(
      children: [
        Container(
          width: 9,
          height: 9,
          child: CustomPaint(
            painter: DrawCircle(
              circleColor: backgroundColor,
              isFilled: true,
            ),
          ),
        ),
        Container(
          width: 7,
          height: 7,
          child: CustomPaint(
            painter: DrawCircle(
              circleColor: isComplete ? backgroundColor : primaryColorLight,
              isFilled: true,
            ),
          ),
        ),
      ],
    );
  }

  Row pinPadRow(BuildContext context, final List<String> pinNumbers) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: pinNumbers.map((number) {
          return pinButton(context, number);
        }).toList());
  }

  SizedBox pinButton(BuildContext context, final String pinNumber) {
    final double pinButtonPadding = pinButtonSize / 6;

    var pinButton = SizedBox(
      width: pinButtonSize,
      height: pinButtonSize,
      child: Padding(
        padding: EdgeInsets.all(pinButtonPadding),
        child: pinNumber.isEmpty
            ? Container()
            : OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                ),
                onPressed: () {
                  if (pinNumber == "<") {
                    removeLastPinCharacter();
                  } else if (currentPosition < 4) {
                    pinButtonPressed(pinNumber.toString());
                  }
                },
                child: pinNumber == "<"
                    ? Image(
                        image: AssetImage("assets/pin_back.png"),
                        width: 24,
                        height: 24,
                      )
                    : Text(
                        pinNumber,
                        style: Theme.of(context).textTheme.headline1,
                      ),
              ),
      ),
    );

    return pinButton;
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 30),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
            child: Image(
              image: AssetImage("assets/pin_lock.png"),
              width: 24,
              height: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 5,
            ),
            child: Text(
              headerText,
              style: Theme.of(context).textTheme.headline3?.copyWith(
                    color: textColor,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              subheaderText,
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: textColor.withOpacity(0.5),
                  ),
            ),
          ),
          pinProgress(),
          SizedBox(
            height: 30,
          ),
          pinPadRow(context, [1, 2, 3].map((e) => e.toString()).toList()),
          pinPadRow(context, [4, 5, 6].map((e) => e.toString()).toList()),
          pinPadRow(context, [7, 8, 9].map((e) => e.toString()).toList()),
          pinPadRow(context, ["", 0, "<"].map((e) => e.toString()).toList()),
          showForgottenPin == true
              ? GestureDetector(
                  onTap: () {
                    forgotPin?.call(context);
                  },
                  child: Text(
                    S.current.pinForgottenTitle,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(color: backgroundColor),
                  ),
                )
              : Container(),
        ],
      );
}

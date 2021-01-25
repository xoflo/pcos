import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/drawing_utils.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';

class PinPad extends StatelessWidget {
  final double pinButtonSize;
  final String headerText;
  final List<bool> progress;
  final int currentPosition;
  final bool showForgottenPin;
  final Function(String) pinButtonPressed;
  final Function resetPinPad;
  final Function(BuildContext) forgotPin;

  PinPad({
    @required this.pinButtonSize,
    @required this.headerText,
    @required this.progress,
    @required this.currentPosition,
    @required this.showForgottenPin,
    @required this.pinButtonPressed,
    @required this.resetPinPad,
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
              circleColor: Colors.white,
            ),
          ),
        ),
        Container(
          width: 7,
          height: 7,
          child: CustomPaint(
            painter: DrawCircle(
              circleColor: isComplete ? Colors.white : primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Row pinPadRow(final List<int> pinNumbers) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: pinNumbers.map((number) {
          return pinButton(number);
        }).toList());
  }

  SizedBox pinButton(final int pinNumber) {
    final double pinButtonPadding = pinButtonSize / 6;

    var pinButton = SizedBox(
      width: pinButtonSize,
      height: pinButtonSize,
      child: Padding(
        padding: EdgeInsets.all(pinButtonPadding),
        child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(
                color: Colors.white,
                width: 2.0,
              ),
            ),
          ),
          onPressed: () {
            if (currentPosition < 4) {
              pinButtonPressed(pinNumber.toString());
            }
          },
          child: Text(
            pinNumber.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
            ),
          ),
        ),
      ),
    );

    return pinButton;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(
            headerText,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
        pinProgress(),
        pinPadRow([1, 2, 3]),
        pinPadRow([4, 5, 6]),
        pinPadRow([7, 8, 9]),
        pinPadRow([0]),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            width: 150,
            child: ColorButton(
              isUpdating: false,
              label: S.of(context).clearButton,
              color: Colors.white,
              textColor: primaryColorDark,
              onTap: () {
                resetPinPad();
              },
            ),
          ),
        ),
        showForgottenPin
            ? GestureDetector(
                onTap: () {
                  forgotPin(context);
                },
                child: Text(
                  "Forgotten PIN",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

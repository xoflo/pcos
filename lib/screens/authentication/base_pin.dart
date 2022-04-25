import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thepcosprotocol_app/constants/pin_entry.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/shared/pin_pad.dart';

mixin BasePin<T extends StatefulWidget> on State<T> {
  List<bool> progress = [false, false, false, false];
  int currentPosition = 0;
  String pinEntered = "";
  PinEntry pinEntry = PinEntry.NONE;

  String get subheaderText;

  Function(BuildContext)? get forgotPin;

  void pinButtonPressed(final String pinNumber) async {
    HapticFeedback.lightImpact();
    updatePin(pinNumber);

    if (currentPosition > 3) {
      await Future.delayed(const Duration(milliseconds: 200), () {});
      updatePinEntryState();
      validatePin();
    }
  }

  void resetPinPad() {
    progress = [false, false, false, false];
    currentPosition = 0;
  }

  void deletePinPadDigit() {
    currentPosition -= 1;
    progress[currentPosition] = false;
  }

  void startPinAgain(String title, String message) {
    showFlushBar(
      context,
      title,
      message,
      backgroundColor: Colors.white,
      borderColor: primaryColorLight,
      primaryColor: primaryColor,
    );
  }

  void updatePin(final String pinNumber) {
    progress[currentPosition] = true;
    currentPosition++;
  }

  void validatePin();

  void updatePinEntryState();

  Widget getPinPad(final double pinButtonSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 10.0),
        PinPad(
          pinButtonSize: pinButtonSize,
          subheaderText: subheaderText,
          progress: progress,
          currentPosition: currentPosition,
          showForgottenPin: forgotPin != null,
          forgotPin: forgotPin,
          pinButtonPressed: (pinNumber) {
            pinButtonPressed(pinNumber);
          },
          removeLastPinCharacter: deletePinPadDigit,
        ),
      ],
    );
  }
}

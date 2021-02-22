import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thepcosprotocol_app/screens/app_tabs.dart';
import 'package:thepcosprotocol_app/widgets/shared/header_image.dart';
import 'package:thepcosprotocol_app/widgets/shared/pin_pad.dart';
import 'package:thepcosprotocol_app/widgets/pin_set/pin_correct.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/pin_entry.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';

class PinSet extends StatefulWidget {
  static const String id = "pin_set_screen";

  @override
  _PinSetState createState() => _PinSetState();
}

class _PinSetState extends State<PinSet> {
  List<bool> _progress = [false, false, false, false];
  int _currentPosition = 0;
  String _pinEntered = "";
  String _pinConfirmed = "";
  PinEntry _pinEntry = PinEntry.NONE;

  void pinButtonPressed(final String pinNumber) async {
    HapticFeedback.lightImpact();
    updatePin(pinNumber);
    if (_currentPosition > 3) {
      await Future.delayed(const Duration(milliseconds: 200), () {});
      updatePinEntryState();
      if (_pinEntry == PinEntry.ENTERED) {
        resetPinPad();
      } else if (_pinEntry == PinEntry.CONFIRMED) {
        if (validatePins()) {
          updatePinEntryState();
          if (_pinEntry == PinEntry.COMPLETE) {
            //pin entry is complete, update parent to open app dashboard
            pinEntryComplete();
          }
        } else {
          startPinAgain();
        }
      }
    }
  }

  void resetPinPad() {
    setState(() {
      _progress = [false, false, false, false];
      _currentPosition = 0;
      if (_pinEntry == PinEntry.NONE) {
        _pinEntered = "";
      } else {
        _pinConfirmed = "";
      }
    });
  }

  void startPinAgain() {
    showFlushBar(context, S.of(context).pinEntryErrorTitle,
        S.of(context).pinEntryErrorText,
        backgroundColor: Colors.white,
        borderColor: primaryColorLight,
        primaryColor: primaryColorDark);

    setState(() {
      _progress = [false, false, false, false];
      _currentPosition = 0;
      _pinEntered = "";
      _pinConfirmed = "";
      _pinEntry = PinEntry.NONE;
    });
  }

  void updatePin(final String pinNumber) {
    setState(() {
      if (_pinEntry == PinEntry.NONE) {
        _pinEntered += pinNumber.toString();
      } else {
        _pinConfirmed += pinNumber.toString();
      }
      _progress[_currentPosition] = true;
      _currentPosition++;
    });
  }

  void updatePinEntryState() {
    setState(() {
      if (_pinEntry == PinEntry.NONE) {
        _pinEntry = PinEntry.ENTERED;
      } else if (_pinEntry == PinEntry.ENTERED) {
        _pinEntry = PinEntry.CONFIRMED;
      } else if (_pinEntry == PinEntry.CONFIRMED) {
        _pinEntry = PinEntry.COMPLETE;
      }
    });
  }

  bool validatePins() {
    if (_pinEntered == _pinConfirmed) {
      return true;
    }
    return false;
  }

  void pinEntryComplete() async {
    //Save the Pin to secure storage
    final bool savePinSuccessful =
        await AuthenticationController().savePin(_pinEntered);
    int openAppDelay = 3;

    if (!savePinSuccessful) {
      openAppDelay = 4;
      showFlushBar(
        context,
        S.of(context).pinSaveErrorTitle,
        S.of(context).pinSaveErrorText,
        backgroundColor: Colors.white,
        borderColor: primaryColorLight,
        primaryColor: primaryColorDark,
        displayDuration: 3,
      );
    }

    //Pin entry is complete now show the app
    await Future.delayed(Duration(seconds: openAppDelay), () {
      Navigator.pushReplacementNamed(context, AppTabs.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double pinButtonSize =
        screenSize.width > 600 ? 100 : screenSize.width * .25;
    return Scaffold(
      backgroundColor: primaryColorDark,
      body: SafeArea(
        child: _pinEntry == PinEntry.COMPLETE
            ? PinCorrect(
                message: S.of(context).pinSetSuccessfulTitle,
                messageWhy: S.of(context).pinSetSuccessfulMessage,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  HeaderImage(screenSize: screenSize),
                  SizedBox(height: 10.0),
                  PinPad(
                    pinButtonSize: pinButtonSize,
                    headerText: _pinEntry == PinEntry.NONE
                        ? S.of(context).pinSetTitle
                        : S.of(context).pinConfirmTitle,
                    progress: _progress,
                    currentPosition: _currentPosition,
                    showForgottenPin: false,
                    pinButtonPressed: (pinNumber) {
                      pinButtonPressed(pinNumber);
                    },
                    resetPinPad: resetPinPad,
                  ),
                ],
              ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/screens/authentication/base_pin.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/authentication/pin_correct.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/pin_entry.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';

class PinSet extends StatefulWidget {
  static const String id = "pin_set_screen";

  @override
  _PinSetState createState() => _PinSetState();
}

class _PinSetState extends State<PinSet> with BasePin {
  String _pinConfirmed = "";

  bool get isPinValid => pinEntered == _pinConfirmed;

  Function(BuildContext)? get forgotPin => null;

  @override
  String get subheaderText => pinEntry == PinEntry.NONE
      ? S.current.pinSetTitle
      : S.current.pinConfirmTitle;

  @override
  String get headerText => "SET YOUR PIN";

  @override
  void validatePin() {
    if (pinEntry == PinEntry.ENTERED) {
      resetPinPad();
    } else if (pinEntry == PinEntry.CONFIRMED) {
      if (isPinValid) {
        updatePinEntryState();
        if (pinEntry == PinEntry.COMPLETE) {
          //pin entry is complete, update parent to open app dashboard
          pinEntryComplete();
        }
      } else {
        startPinAgain(
          S.current.pinEntryErrorTitle,
          S.current.pinEntryErrorText,
        );
      }
    }
  }

  @override
  void resetPinPad() {
    setState(() {
      super.resetPinPad();
      if (pinEntry == PinEntry.NONE) {
        pinEntered = "";
      } else {
        _pinConfirmed = "";
      }
    });
  }

  @override
  void deletePinPadDigit() {
    if (currentPosition > 0) {
      setState(
        () {
          super.deletePinPadDigit();
          if (pinEntry == PinEntry.NONE) {
            pinEntered = pinEntered.substring(0, pinEntered.length - 1);
          } else {
            _pinConfirmed =
                _pinConfirmed.substring(0, _pinConfirmed.length - 1);
          }
        },
      );
    }
  }

  @override
  void startPinAgain(String title, String message) {
    setState(() {
      progress = [false, false, false, false];
      currentPosition = 0;
      pinEntered = "";
      _pinConfirmed = "";
      pinEntry = PinEntry.NONE;
    });
    super.startPinAgain(title, message);
  }

  @override
  void updatePin(final String pinNumber) {
    setState(() {
      if (pinEntry == PinEntry.NONE) {
        pinEntered += pinNumber.toString();
      } else {
        _pinConfirmed += pinNumber.toString();
      }
      super.updatePin(pinNumber);
    });
  }

  @override
  void updatePinEntryState() {
    setState(() {
      if (pinEntry == PinEntry.NONE) {
        pinEntry = PinEntry.ENTERED;
      } else if (pinEntry == PinEntry.ENTERED) {
        pinEntry = PinEntry.CONFIRMED;
      } else if (pinEntry == PinEntry.CONFIRMED) {
        pinEntry = PinEntry.COMPLETE;
      }
    });
  }

  void pinEntryComplete() async {
    //Save the Pin to secure storage
    final bool savePinSuccessful =
        await AuthenticationController().savePin(pinEntered);

    if (!savePinSuccessful) {
      showAlertDialog(
        context,
        S.current.pinSaveErrorTitle,
        S.current.pinSaveErrorText,
        "",
        "Okay",
        null,
        null,
      );
    } else {
      navigateToNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final showBackButton =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;

    return WillPopScope(
      onWillPop: () async => !Platform.isIOS,
      child: getBaseWidget(
        context,
        SafeArea(
          child: pinEntry == PinEntry.COMPLETE
              ? PinCorrect(
                  message: S.current.pinSetSuccessfulTitle,
                  messageWhy: S.current.pinSetSuccessfulMessage,
                )
              : Stack(
                  children: [
                    getPinPad(),
                    if (showBackButton)
                      Padding(
                        padding: EdgeInsets.only(
                          left: 15,
                          top: 25,
                        ),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back,
                            color: backgroundColor,
                            size: 30,
                          ),
                        ),
                      )
                  ],
                ),
        ),
      ),
    );
  }
}

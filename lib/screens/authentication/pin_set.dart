import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/screens/app_tabs.dart';
import 'package:thepcosprotocol_app/screens/authentication/base_pin.dart';
import 'package:thepcosprotocol_app/widgets/pin_set/pin_correct.dart';
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
            S.current.pinEntryErrorTitle, S.current.pinEntryErrorText);
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
    super.startPinAgain(title, message);

    setState(() {
      progress = [false, false, false, false];
      currentPosition = 0;
      pinEntered = "";
      _pinConfirmed = "";
      pinEntry = PinEntry.NONE;
    });
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
    int openAppDelay = 3;

    if (!savePinSuccessful) {
      openAppDelay = 4;
      showFlushBar(
        context,
        S.current.pinSaveErrorTitle,
        S.current.pinSaveErrorText,
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
    return getBaseWidget(
      context,
      SafeArea(
        child: pinEntry == PinEntry.COMPLETE
            ? PinCorrect(
                message: S.current.pinSetSuccessfulTitle,
                messageWhy: S.current.pinSetSuccessfulMessage,
              )
            : getPinPad(),
      ),
    );
  }
}

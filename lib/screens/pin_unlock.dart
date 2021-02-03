import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/widgets/shared/header_image.dart';
import 'package:thepcosprotocol_app/widgets/authentication/pin_pad.dart';
import 'package:thepcosprotocol_app/widgets/authentication/pin_correct.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/app_state.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/constants/pin_entry.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class PinUnlock extends StatefulWidget {
  final Function(AppState) updateAppState;

  PinUnlock({this.updateAppState});

  @override
  PinUnlockState createState() => PinUnlockState();
}

class PinUnlockState extends State<PinUnlock> {
  List<bool> _progress = [false, false, false, false];
  int _currentPosition = 0;
  String _pinEntered = "";
  PinEntry _pinEntry = PinEntry.NONE;
  int _pinAttempts = 0;

  void pinButtonPressed(final String pinNumber) async {
    HapticFeedback.lightImpact();
    updatePin(pinNumber);
    if (_currentPosition > 3) {
      await Future.delayed(const Duration(milliseconds: 200), () {});
      updatePinEntryState();
      if (_pinEntry == PinEntry.ENTERED) {
        checkPin(_pinEntered);
      }
    }
  }

  void updatePin(final String pinNumber) {
    setState(() {
      _pinEntered += pinNumber.toString();
      _progress[_currentPosition] = true;
      _currentPosition++;
    });
  }

  void updatePinEntryState() {
    setState(() {
      if (_pinEntry == PinEntry.NONE) {
        _pinEntry = PinEntry.ENTERED;
      } else if (_pinEntry == PinEntry.ENTERED) {
        _pinEntry = PinEntry.COMPLETE;
      }
    });
  }

  Future<void> checkPin(final String pinEntered) async {
    if (await WebServices().checkInternetConnectivity()) {
      _pinAttempts++;
      if (await AuthenticationController().checkPin(pinEntered)) {
        pinEntryComplete();
      } else {
        if (_pinAttempts < 5) {
          startPinAgain();
        } else {
          //have tried pin five times, clear pin, and send back to sign in
          sendToSignIn(false);
        }
      }
    } else {
      //not connected to internet, inform user
      showFlushBar(context, S.of(context).internetConnectionTitle,
          S.of(context).internetConnectionText,
          backgroundColor: Colors.white,
          borderColor: primaryColorLight,
          primaryColor: primaryColorDark);
    }
  }

  void pinEntryComplete() async {
    //refresh the access token so it doesn't expire during this session, if it fails, logout user
    final bool refreshToken = await AuthenticationController().refreshToken();

    if (refreshToken) {
      //token refreshed and Pin entry is complete now show the app
      widget.updateAppState(AppState.APP);
    } else {
      //couldn't refresh token, so wait a few seconds and try again
      await Future.delayed(const Duration(seconds: 3), () {
        tryRefreshAgain();
      });
    }
  }

  void tryRefreshAgain() async {
    final bool refreshToken = await AuthenticationController().refreshToken();

    if (refreshToken) {
      //token refreshed and Pin entry is complete now show the app
      widget.updateAppState(AppState.APP);
    } else {
      //couldn't refresh token, so refresh token must have expired, so logout user
      sendToSignIn(true);
    }
  }

  void startPinAgain() {
    showFlushBar(context, S.of(context).pinUnlockErrorTitle,
        S.of(context).pinUnlockErrorText,
        backgroundColor: Colors.white,
        borderColor: primaryColorLight,
        primaryColor: primaryColorDark);

    resetPinPad();
  }

  void sendToSignIn(final bool isRefreshTokenExpired) async {
    final title = isRefreshTokenExpired
        ? S.of(context).pinRefreshErrorTitle
        : S.of(context).pinUnlockAttemptsErrorTitle;
    final message = isRefreshTokenExpired
        ? S.of(context).pinRefreshErrorText
        : S.of(context).pinUnlockAttemptsErrorText;

    showFlushBar(
      context,
      title,
      message,
      backgroundColor: Colors.white,
      borderColor: primaryColorLight,
      primaryColor: primaryColorDark,
      displayDuration: 5,
    );

    AuthenticationController().deletePin();
    AuthenticationController().deleteCredentials();

    await Future.delayed(Duration(seconds: 6), () {
      widget.updateAppState(AppState.SIGN_IN);
    });
  }

  void resetPinPad() {
    setState(() {
      _progress = [false, false, false, false];
      _currentPosition = 0;
      _pinEntered = "";
      _pinEntry = PinEntry.NONE;
    });
  }

  void forgottenPin(BuildContext context) {
    showAlertDialog(
        context,
        S.of(context).pinForgottenTitle,
        S.of(context).pinForgottenMessage,
        S.of(context).pinForgottenCancel,
        S.of(context).pinForgottenContinue,
        continueForgottenPin);
  }

  void continueForgottenPin(BuildContext context) {
    AuthenticationController().deletePin();
    AuthenticationController().deleteCredentials();
    Navigator.of(context).pop();
    widget.updateAppState(AppState.SIGN_IN);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double pinButtonSize =
        screenSize.width > 600 ? 100 : screenSize.width * .23;
    final double headerPadding = screenSize.width > 600 ? 20.0 : 0.0;
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: headerPadding),
            child: HeaderImage(screenSize: screenSize),
          ),
          _pinEntry != PinEntry.COMPLETE
              ? PinPad(
                  pinButtonSize: pinButtonSize,
                  headerText: S.of(context).pinUnlockTitle,
                  progress: _progress,
                  currentPosition: _currentPosition,
                  showForgottenPin: true,
                  pinButtonPressed: (pinNumber) {
                    pinButtonPressed(pinNumber);
                  },
                  resetPinPad: resetPinPad,
                  forgotPin: forgottenPin,
                )
              : PinCorrect(message: S.of(context).pinEnteredSuccessfulTitle),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thepcosprotocol_app/models/navigation/pin_unlock_arguments.dart';
import 'package:thepcosprotocol_app/screens/authentication/base_pin.dart';
import 'package:thepcosprotocol_app/screens/authentication/sign_in.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/constants/pin_entry.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/models/member.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_generic.dart';

class PinUnlock extends StatefulWidget {
  static const String id = "pin_unlock_screen";

  @override
  PinUnlockState createState() => PinUnlockState();
}

class PinUnlockState extends State<PinUnlock> with BasePin {
  int _pinAttempts = 0;

  @override
  String get headerText => "ENTER YOUR PIN";

  @override
  String get subheaderText => S.current.pinUnlockTitle;

  Future<bool> onBackPressed(BuildContext context) async {
    if (Platform.isIOS) return Future.value(false);

    return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(S.current.areYouSureText,
                style: TextStyle(fontSize: 20)),
            content: new Text(S.current.exitAppText),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.current.noText, style: TextStyle(fontSize: 24)),
                ),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(true);
                  SystemNavigator.pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text(S.current.yesText, style: TextStyle(fontSize: 24)),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void validatePin() {
    if (pinEntry == PinEntry.ENTERED) {
      checkPin(pinEntered);
    }
  }

  @override
  void updatePin(final String pinNumber) {
    setState(() {
      pinEntered += pinNumber.toString();
      super.updatePin(pinNumber);
    });
  }

  @override
  void updatePinEntryState() {
    setState(() {
      if (pinEntry == PinEntry.NONE) {
        pinEntry = PinEntry.ENTERED;
      } else if (pinEntry == PinEntry.ENTERED) {
        pinEntry = PinEntry.COMPLETE;
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
          startPinAgain(
              S.current.pinUnlockErrorTitle, S.current.pinEntryErrorText);
        } else {
          //have tried pin five times, clear pin, and send back to sign in
          sendToSignIn(false);
        }
      }
    } else {
      //not connected to internet, inform user
      showAlertDialog(
        context,
        S.current.internetConnectionTitle,
        S.current.internetConnectionText,
        "",
        "Okay",
        null,
        null,
      );
    }
  }

  void pinEntryComplete() async {
    //refresh the access token so it doesn't expire during this session, if it fails, logout user
    final bool refreshToken = await AuthenticationController().refreshToken();

    if (refreshToken) {
      await saveNextLessonAvailableDate();
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
      await saveNextLessonAvailableDate();
    } else {
      //couldn't refresh token, so refresh token must have expired, so logout user
      sendToSignIn(true);
    }
  }

  Future<void> saveNextLessonAvailableDate() async {
    // After getting member details, check if the user subscription is still
    // updated. Otherwise, the app logs out, indicating that the subscription
    // may have expired.
    final Member memberDetails = await WebServices().getMemberDetails();
    if (memberDetails.isSubscriptionValid) {
      await PreferencesController().saveString(
          SharedPreferencesKeys.NEXT_LESSON_AVAILABLE_DATE,
          memberDetails.dateNextLessonAvailableLocal?.toIso8601String() ?? "");
      openAppTabs();
    } else {
      showAlertDialog(
        context,
        "Warning",
        "Your subscription has expired. You will now be logged out of the app. Please update your subscription to continue using the Ovie app.",
        "",
        "Okay",
        continueLogout,
        null,
      );
    }
  }

  @override
  void startPinAgain(String title, String message) {
    resetPinPad();
    super.startPinAgain(title, message);
  }

  void openAppTabs() async {
    final PinUnlockArguments args =
        ModalRoute.of(context)?.settings.arguments as PinUnlockArguments;
    args.setIsLocked(false);
    if (args.isAppTabsOpen) {
      Navigator.pop(context);
    } else {
      navigateToNextPage();
    }
  }

  void sendToSignIn(final bool isRefreshTokenExpired) async {
    final title = isRefreshTokenExpired
        ? S.current.pinRefreshErrorTitle
        : S.current.pinUnlockAttemptsErrorTitle;
    final message = isRefreshTokenExpired
        ? S.current.pinRefreshErrorText
        : S.current.pinUnlockAttemptsErrorText;

    showAlertDialog(
      context,
      title,
      message,
      "",
      "Okay",
      (BuildContext context) async {
        await Future.delayed(
            Duration(seconds: 6), deleteCredentialsAndGotoSignIn);
      },
      null,
    );
  }

  @override
  void resetPinPad() {
    super.resetPinPad();
    setState(() {
      pinEntered = "";
      pinEntry = PinEntry.NONE;
    });
  }

  @override
  void deletePinPadDigit() {
    if (currentPosition > 0) {
      setState(() {
        super.deletePinPadDigit();
        pinEntered = pinEntered.substring(0, pinEntered.length - 1);
      });
    }
  }

  void forgottenPin(BuildContext context) {
    showAlertDialog(
      context,
      S.current.pinForgottenTitle,
      S.current.pinForgottenMessage,
      S.current.pinForgottenCancel,
      S.current.pinForgottenContinue,
      continueLogout,
      null,
    );
  }

  void continueLogout(BuildContext context) {
    analytics.logEvent(
      name: Analytics.ANALYTICS_EVENT_BUTTONCLICK,
      parameters: {
        Analytics.ANALYTICS_PARAMETER_BUTTON:
            Analytics.ANALYTICS_BUTTON_FORGOTTEN_PIN
      },
    );
    Navigator.of(context).pop();
    deleteCredentialsAndGotoSignIn();
  }

  void deleteCredentialsAndGotoSignIn() {
    AuthenticationController().clearData(context);

    Navigator.of(context)
        .pushNamedAndRemoveUntil(SignIn.id, (Route<dynamic> route) => false);
  }

  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () => onBackPressed(context),
        child: getBaseWidget(
          context,
          Stack(
            children: [
              getPinPad(forgotPin: forgottenPin),
              if (pinEntry == PinEntry.ENTERED) GenericLoaderOverlay()
            ],
          ),
        ),
      );
}

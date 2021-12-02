import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/models/navigation/pin_unlock_arguments.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/screens/app_tabs.dart';
import 'package:thepcosprotocol_app/screens/authentication/sign_in.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/widgets/shared/header_image.dart';
import 'package:thepcosprotocol_app/widgets/shared/pin_pad.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/constants/pin_entry.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/models/member.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';

class PinUnlock extends StatefulWidget {
  static const String id = "pin_unlock_screen";

  @override
  PinUnlockState createState() => PinUnlockState();
}

class PinUnlockState extends State<PinUnlock> {
  List<bool> _progress = [false, false, false, false];
  int _currentPosition = 0;
  String _pinEntered = "";
  PinEntry _pinEntry = PinEntry.NONE;
  int _pinAttempts = 0;

  Future<bool> onBackPressed(BuildContext context) {
    if (Platform.isIOS) return Future.value(false);

    return showDialog(
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
      showFlushBar(context, S.current.internetConnectionTitle,
          S.current.internetConnectionText,
          backgroundColor: Colors.white,
          borderColor: primaryColorLight,
          primaryColor: primaryColor);
    }
  }

  void pinEntryComplete() async {
    //refresh the access token so it doesn't expire during this session, if it fails, logout user
    final bool refreshToken = await AuthenticationController().refreshToken();

    if (refreshToken) {
      //token refreshed and Pin entry is complete now get next lesson date and show the app
      await saveNextLessonAvailableDate();
      openAppTabs();
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
      //token refreshed and Pin entry is complete now get next lesson date and show the app
      await saveNextLessonAvailableDate();
      openAppTabs();
    } else {
      //couldn't refresh token, so refresh token must have expired, so logout user
      sendToSignIn(true);
    }
  }

  Future<void> saveNextLessonAvailableDate() async {
    //get the dateNextLessonAvailable and update in shared prefs
    final Member memberDetails = await WebServices().getMemberDetails();
    await PreferencesController().saveString(
        SharedPreferencesKeys.NEXT_LESSON_AVAILABLE_DATE,
        memberDetails.dateNextLessonAvailableLocal.toIso8601String());
  }

  void startPinAgain() {
    showFlushBar(
        context, S.current.pinUnlockErrorTitle, S.current.pinUnlockErrorText,
        backgroundColor: Colors.white,
        borderColor: primaryColorLight,
        primaryColor: primaryColor);

    resetPinPad();
  }

  void openAppTabs() {
    final PinUnlockArguments args = ModalRoute.of(context).settings.arguments;
    args.setIsLocked(false);
    if (args.isAppTabsOpen) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppTabs.id);
    }
  }

  void sendToSignIn(final bool isRefreshTokenExpired) async {
    final title = isRefreshTokenExpired
        ? S.current.pinRefreshErrorTitle
        : S.current.pinUnlockAttemptsErrorTitle;
    final message = isRefreshTokenExpired
        ? S.current.pinRefreshErrorText
        : S.current.pinUnlockAttemptsErrorText;

    showFlushBar(
      context,
      title,
      message,
      backgroundColor: Colors.white,
      borderColor: primaryColorLight,
      primaryColor: primaryColor,
      displayDuration: 5,
    );

    await Future.delayed(Duration(seconds: 6), () {
      deleteCredentialsAndGotoSignIn();
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
      S.current.pinForgottenTitle,
      S.current.pinForgottenMessage,
      S.current.pinForgottenCancel,
      S.current.pinForgottenContinue,
      continueForgottenPin,
      (BuildContext context) {
        Navigator.of(context).pop();
      },
    );
  }

  void continueForgottenPin(BuildContext context) {
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
    DatabaseProvider dbProvider =
        Provider.of<DatabaseProvider>(context, listen: false);
    AuthenticationController authController = AuthenticationController();
    authController.deleteCredentials();
    authController.deletePin();
    authController.deleteOtherPrefs();
    dbProvider.deleteAllData();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(SignIn.id, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double pinButtonSize =
        screenSize.width > 600 ? 100 : screenSize.width * .22;
    final double headerPadding = screenSize.width > 600 ? 20.0 : 0.0;
    return WillPopScope(
      onWillPop: () {
        return onBackPressed(context);
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: headerPadding),
                child: HeaderImage(
                  screenSize: screenSize,
                  isOrange: false,
                  verticalTopPadding: 80,
                ),
              ),
              PinPad(
                pinButtonSize: pinButtonSize,
                headerText: S.current.pinUnlockTitle,
                progress: _progress,
                currentPosition: _currentPosition,
                showForgottenPin: true,
                pinButtonPressed: (pinNumber) {
                  pinButtonPressed(pinNumber);
                },
                resetPinPad: resetPinPad,
                forgotPin: forgottenPin,
              )
            ],
          ),
        ),
      ),
    );
  }
}

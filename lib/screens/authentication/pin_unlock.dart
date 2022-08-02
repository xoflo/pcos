import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/models/navigation/app_tutorial_arguments.dart';
import 'package:thepcosprotocol_app/models/navigation/pin_unlock_arguments.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/screens/app_tabs.dart';
import 'package:thepcosprotocol_app/screens/authentication/base_pin.dart';
import 'package:thepcosprotocol_app/screens/authentication/sign_in.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
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
import 'package:thepcosprotocol_app/widgets/app_tutorial/app_tutorial_page.dart';

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
      showFlushBar(
        context,
        S.current.internetConnectionTitle,
        S.current.internetConnectionText,
      );
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
        memberDetails.dateNextLessonAvailableLocal?.toIso8601String() ?? "");
  }

  @override
  void startPinAgain(String title, String message) {
    super.startPinAgain(title, message);

    resetPinPad();
  }

  void openAppTabs() async {
    final PinUnlockArguments args =
        ModalRoute.of(context)?.settings.arguments as PinUnlockArguments;
    args.setIsLocked(false);
    if (args.isAppTabsOpen) {
      Navigator.pop(context);
    } else {
      if (!await PreferencesController()
          .getBool(SharedPreferencesKeys.VIEWED_TUTORIAL)) {
        analytics.logEvent(name: Analytics.ANALYTICS_EVENT_TUTORIAL_BEGIN);

        await Future.delayed(Duration(seconds: 2), () {
          Navigator.pushNamed(
            context,
            AppTutorialPage.id,
            arguments: AppTutorialArguments(),
          );
        });
      } else {
        Navigator.pushReplacementNamed(context, AppTabs.id);
      }
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
    return WillPopScope(
      onWillPop: () {
        return onBackPressed(context);
      },
      child: getBaseWidget(
        context,
        SafeArea(
          child: getPinPad(forgotPin: forgottenPin),
        ),
      ),
    );
  }
}

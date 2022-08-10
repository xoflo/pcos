import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thepcosprotocol_app/constants/pin_entry.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/models/navigation/app_tutorial_arguments.dart';
import 'package:thepcosprotocol_app/screens/app_tabs.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/app_tutorial/app_tutorial_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/ellipsis_painter.dart';
import 'package:thepcosprotocol_app/widgets/shared/pin_pad.dart';

import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

mixin BasePin<T extends StatefulWidget> on State<T> {
  List<bool> progress = [false, false, false, false];
  int currentPosition = 0;
  String pinEntered = "";
  PinEntry pinEntry = PinEntry.NONE;

  String get headerText;

  String get subheaderText;

  void pinButtonPressed(final String pinNumber) async {
    HapticFeedback.lightImpact();
    updatePin(pinNumber);

    if (currentPosition == 4) {
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

  void navigateToNextPage() async {
    await Future.delayed(Duration(seconds: 2), () async {
      if (!await PreferencesController()
          .getBool(SharedPreferencesKeys.VIEWED_TUTORIAL)) {
        analytics.logEvent(name: Analytics.ANALYTICS_EVENT_TUTORIAL_BEGIN);
        Navigator.pushNamed(
          context,
          AppTutorialPage.id,
          arguments: AppTutorialArguments(),
        );
      } else {
        Navigator.pushReplacementNamed(context, AppTabs.id);
      }
    });
  }

  void startPinAgain(String title, String message) {
    showFlushBar(
      context,
      title,
      message,
    );
  }

  void updatePin(final String pinNumber) {
    progress[currentPosition] = true;
    currentPosition++;
  }

  void validatePin();

  void updatePinEntryState();

  Widget getPinPad({Function(BuildContext)? forgotPin}) {
    final Size screenSize = MediaQuery.of(context).size;
    final double pinButtonSize =
        screenSize.width > 600 ? 100 : screenSize.width * .25;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 10.0),
        PinPad(
          pinButtonSize: pinButtonSize,
          headerText: headerText,
          subheaderText: subheaderText,
          progress: progress,
          currentPosition: currentPosition,
          showForgottenPin: forgotPin != null,
          forgotPin: forgotPin,
          pinButtonPressed: (pinNumber) => pinButtonPressed(pinNumber),
          removeLastPinCharacter: deletePinPadDigit,
        ),
      ],
    );
  }

  Widget getBaseWidget(BuildContext context, Widget child) {
    final Size screenSize = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Colors.white),
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Stack(
          children: [
            CustomPaint(
              painter: EllipsisPainter(
                color: Colors.white,
                heightMultiplier: 0.3,
                x1Multiplier: 0.5,
                y1Multiplier: 0.5,
                y2Multiplier: 0.3,
              ),
              child: Container(
                width: screenSize.width,
                height: screenSize.height,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

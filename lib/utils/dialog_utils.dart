import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/screens/app_tabs.dart';

void showFlushBar(final BuildContext scaffoldContext, final String title,
    final String message,
    {final IconData icon = Icons.warning_outlined,
    final Color backgroundColor = Colors.white,
    final Color borderColor = Colors.black38,
    final Color primaryColor = Colors.black87,
    final int displayDuration = 5}) {
  analytics.logEvent(
    name: Analytics.ANALYTICS_EVENT_FLUSHBAR,
    parameters: {Analytics.ANALYTICS_PARAMETER_FLUSHBAR_TITLE: title},
  );

  Flushbar(
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(10),
    borderRadius: BorderRadius.circular(5),
    icon: Icon(
      icon,
      color: primaryColor,
      size: 30.0,
    ),
    borderColor: borderColor,
    backgroundColor: backgroundColor,
    dismissDirection: FlushbarDismissDirection.VERTICAL,
    isDismissible: false,
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    titleText: Text(
      title,
      style: TextStyle(
        color: primaryColor,
        fontSize: 20.0,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyle(color: primaryColor),
    ),
    duration: Duration(seconds: displayDuration),
    flushbarPosition: FlushbarPosition.TOP,
  )..show(scaffoldContext);
}

showAlertDialog(
  final BuildContext context,
  final String title,
  final String message,
  final String cancelText,
  final String continueText,
  final Function? continueAction,
  final Function cancelAction,
) {
  analytics.logEvent(
    name: Analytics.ANALYTICS_EVENT_OPENDIALOG,
    parameters: {Analytics.ANALYTICS_PARAMETER_DIALOG_TITLE: title},
  );
  // set up the buttons
  Widget cancelButton = ColorButton(
    isUpdating: false,
    label: cancelText,
    onTap: () {
      cancelAction(context);
    },
  );

  Widget continueButton = ColorButton(
    isUpdating: false,
    label: continueText,
    onTap: () {
      //log user out and clear credentials etc
      continueAction?.call(context);
    },
  );

  List<Widget> actions = [];
  if (continueText.length > 0) {
    actions.add(continueButton);
  }
  actions.add(cancelButton);

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: actions,
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

openBottomSheet(final BuildContext context, final Widget widget,
    final String screenName, final String? id) {
  final String analyticsScreenName =
      screenName == Analytics.ANALYTICS_SCREEN_TUTORIAL
          ? screenName
          : id != null
              ? "${AppTabs.id}/$screenName/$id"
              : "${AppTabs.id}/$screenName";
  analytics.setCurrentScreen(
    screenName: analyticsScreenName,
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => widget,
  );
}

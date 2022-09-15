import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart' as colors;
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/screens/tabs/app_tabs.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';

showAlertDialog(
  final BuildContext context,
  final String title,
  final String message,
  final String cancelText,
  final String continueText,
  final Function? continueAction,
  final Function? cancelAction,
) {
  analytics.logEvent(
    name: Analytics.ANALYTICS_EVENT_OPENDIALOG,
    parameters: {Analytics.ANALYTICS_PARAMETER_DIALOG_TITLE: title},
  );
  // set up the buttons
  Widget cancelButton = FilledButton(
    margin: EdgeInsets.zero,
    text: cancelText,
    foregroundColor: Colors.white,
    backgroundColor: colors.backgroundColor,
    onPressed: () {
      Navigator.pop(context);
      cancelAction?.call(context);
    },
  );

  Widget continueButton = FilledButton(
    margin: EdgeInsets.zero,
    text: continueText,
    foregroundColor: Colors.white,
    backgroundColor: colors.backgroundColor,
    onPressed: () {
      Navigator.pop(context);
      continueAction?.call(context);
    },
  );

  List<Widget> actions = [];
  actions.add(continueButton);
  if (cancelText.length > 0) {
    actions.add(SizedBox(height: 10));
    actions.add(cancelButton);
  }

  AlertDialog alert = createAlertDialogWidget(title, message, actions);

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

AlertDialog createAlertDialogWidget(
    String title, String message, List<Widget> actions) {
  AlertDialog alert = AlertDialog(
    titlePadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
    contentPadding: EdgeInsets.symmetric(horizontal: 15),
    actionsPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    alignment: Alignment.center,
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: colors.textColor,
      ),
    ),
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: colors.textColor,
      ),
    ),
    actions: actions,
  );

  return alert;
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

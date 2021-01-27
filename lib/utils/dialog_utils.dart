import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';

void showFlushBar(final BuildContext scaffoldContext, final String title,
    final String message,
    {final IconData icon = Icons.warning_outlined,
    final Color backgroundColor = Colors.white,
    final Color borderColor = Colors.black38,
    final Color primaryColor = Colors.black87,
    final int displayDuration = 5}) {
  Flushbar(
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(10),
    borderRadius: 8,
    icon: Icon(
      icon,
      color: primaryColor,
      size: 30.0,
    ),
    borderColor: borderColor,
    backgroundColor: backgroundColor,
    dismissDirection: FlushbarDismissDirection.VERTICAL,
    isDismissible: true,
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
    final Function continueAction) {
  // set up the buttons
  Widget cancelButton = ColorButton(
    isUpdating: false,
    label: cancelText,
    onTap: () {
      Navigator.of(context).pop();
    },
  );

  Widget continueButton = ColorButton(
    isUpdating: false,
    label: continueText,
    onTap: () {
      //log user out and clear credentials etc
      continueAction(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      continueButton,
      cancelButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

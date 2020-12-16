import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

void showFlushBar(final BuildContext scaffoldContext, final String title,
    final String message,
    {final IconData icon = Icons.warning_outlined,
    final Color backgroundColor = Colors.white,
    final Color borderColor = Colors.black38,
    final Color primaryColor = Colors.black87}) {
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
    duration: Duration(seconds: 5),
    flushbarPosition: FlushbarPosition.TOP,
  )..show(scaffoldContext);
}

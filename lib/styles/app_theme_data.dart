import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

ThemeData appThemeData() {
  return ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // Define the default brightness and colors.
    brightness: Brightness.light,
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    backgroundColor: backgroundColor,

    // Define the default font family.
    fontFamily: 'Roboto',
    primaryIconTheme: IconThemeData(color: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
    accentIconTheme: IconThemeData(color: Colors.white),

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline1: TextStyle(
        color: primaryColorDark,
        fontSize: 40.0,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: primaryColorDark,
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: primaryColor,
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
      ),
      headline4: TextStyle(
        color: primaryColor,
        fontSize: 24.0,
      ),
      headline5: TextStyle(
        color: primaryColorLight,
        fontSize: 22.0,
      ),
      headline6: TextStyle(
        color: primaryColorLight,
        fontSize: 20.0,
      ),
      bodyText1: TextStyle(
        color: textColor,
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: TextStyle(
        color: textColorAlt,
        fontSize: 16.0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(
          color: primaryColorDark,
        ),
        padding: EdgeInsets.all(8),
        textStyle: TextStyle(
          fontSize: 16,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: primaryColorDark,
        ),
      ),
      labelStyle: TextStyle(
        color: primaryColorDark,
      ),
    ),
  );
}

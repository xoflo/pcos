import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

ThemeData appThemeData() {
  return ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // Define the default brightness and colors.
    brightness: Brightness.light,
    primaryColor: primaryColor,
    primaryColorLight: primaryColorLight,
    backgroundColor: backgroundColor,
    cardColor: Colors.white,

    // Define the default font family.
    fontFamily: 'Roboto',
    primaryIconTheme: IconThemeData(color: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
    //accentIconTheme: IconThemeData(color: Colors.white), deprecated
    canvasColor: backgroundColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primaryColor,
      selectedIconTheme: IconThemeData(
        color: Colors.white,
        size: 30.0,
      ),
      unselectedIconTheme: IconThemeData(
        color: backgroundColor,
        size: 26.0,
      ),
    ),
    appBarTheme: AppBarTheme(
      color: backgroundColor,
      iconTheme: IconThemeData(color: primaryColor),
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),
    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline1: TextStyle(
        color: primaryColor,
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: primaryColor,
        fontSize: 26.0,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: primaryColor,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
      headline4: TextStyle(
        color: primaryColor,
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
      ),
      headline5: TextStyle(
        color: primaryColor,
        fontSize: 20.0,
      ),
      headline6: TextStyle(
        color: primaryColor,
        fontSize: 18.0,
      ),
      bodyText1: TextStyle(
        color: textColor,
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: TextStyle(
        color: textColor,
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(
          color: primaryColor,
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
          color: primaryColor,
        ),
      ),
      labelStyle: TextStyle(
        color: primaryColor,
      ),
    ),
    tabBarTheme: TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: secondaryColor,
        ),
      ),
    ),
  );
}

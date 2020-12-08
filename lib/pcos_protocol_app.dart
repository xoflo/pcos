import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/flavor_banner.dart';
import 'package:thepcosprotocol_app/widgets/app_body.dart';
import 'package:thepcosprotocol_app/widgets/app_loading.dart';

class PCOSProtocolApp extends StatelessWidget {
  final bool initialised;

  PCOSProtocolApp({@required this.initialised});

  //This is where we check device size and show relevant layout widget

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xffff976f);
    final primaryColorDark = Color(0xfff3755f);
    final primaryColorLight = Color(0xfff79499);
    final backgroundColor = Color(0xfffde8e4);
    final textColor = Color(0xff666666);
    final textColorAlt = Color(0xfff3755f);

    return MaterialApp(
      title: 'The PCOS Protocol',
      theme: ThemeData(
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
            fontSize: 48.0,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            color: primaryColorDark,
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
          ),
          headline3: TextStyle(
            color: primaryColor,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
          headline4: TextStyle(
            color: primaryColor,
            fontSize: 28.0,
          ),
          headline5: TextStyle(
            color: primaryColorLight,
            fontSize: 26.0,
          ),
          headline6: TextStyle(
            color: primaryColorLight,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            color: textColor,
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
          ),
          bodyText2: TextStyle(
            color: textColorAlt,
            fontSize: 20.0,
          ),
        ),
      ),
      home: FlavorBanner(
        child: initialised
            ? AppBody()
            : AppLoading(
                backgroundColor: backgroundColor,
                valueColor: primaryColorDark,
              ),
      ),
    );
  }
}

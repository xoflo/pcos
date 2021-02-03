import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  final Color backgroundColor;
  final Color valueColor;

  AppLoading({@required this.backgroundColor, @required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: valueColor,
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: backgroundColor,
          valueColor: new AlwaysStoppedAnimation<Color>(valueColor),
        ),
      ),
    );
  }
}

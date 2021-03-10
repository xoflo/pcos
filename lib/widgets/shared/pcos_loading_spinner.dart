import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class PcosLoadingSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Align(
          child: CircularProgressIndicator(
        backgroundColor: backgroundColor,
        valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
      )),
    );
  }
}

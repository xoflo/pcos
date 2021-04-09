import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/policy/policy_layout.dart';

class Privacy extends StatelessWidget {
  static const String id = "privacy_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: PolicyLayout(
            title: S.of(context).privacyTitle,
            cmsAssetName: "Privacy",
            tryAgainText: S.of(context).tryAgain,
          ),
        ),
      ),
    );
  }
}

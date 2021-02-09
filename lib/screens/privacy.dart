import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/policy/policy_layout.dart';

class Privacy extends StatelessWidget {
  final Function closeMenuItem;

  Privacy({this.closeMenuItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: PolicyLayout(
            title: S.of(context).privacyTitle,
            cmsAssetName: "Privacy",
            tryAgainText: S.of(context).tryAgain,
            closeMenuItem: closeMenuItem,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/help/help_layout.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class Help extends StatelessWidget {
  final Function closeMenuItem;

  Help({this.closeMenuItem});

  @override
  Widget build(BuildContext context) {
    return HelpLayout(
      tryAgainText: S.of(context).tryAgain,
      closeMenuItem: closeMenuItem,
    );
  }
}

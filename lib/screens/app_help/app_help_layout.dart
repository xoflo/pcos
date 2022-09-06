import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/app_help_provider.dart';
import 'package:thepcosprotocol_app/screens/app_help/question_tab.dart';

class AppHelpLayout extends StatefulWidget {
  @override
  _AppHelpLayoutState createState() => _AppHelpLayoutState();
}

class _AppHelpLayoutState extends State<AppHelpLayout> {
  @override
  Widget build(BuildContext context) {
    final appHelpProvider =
        Provider.of<AppHelpProvider>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Header(
          title: S.current.appHelpTitle,
          closeItem: () => Navigator.pop(context),
          showDivider: true,
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                Container(
              height: constraints.maxHeight,
              decoration: BoxDecoration(color: primaryColor),
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: QuestionTab(faqProvider: appHelpProvider),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

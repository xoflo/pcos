import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/app_help_provider.dart';
import 'package:thepcosprotocol_app/widgets/app_help/question_tab.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';

class AppHelpLayout extends StatefulWidget {
  @override
  _AppHelpLayoutState createState() => _AppHelpLayoutState();
}

class _AppHelpLayoutState extends State<AppHelpLayout> {
  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Header(
            title: S.of(context).appHelpTitle,
            closeItem: _cancel,
          ),
          Expanded(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                height: constraints.maxHeight,
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Consumer<AppHelpProvider>(
                    builder: (context, faqModel, child) => QuestionTab(
                      isHorizontal: isHorizontal,
                      faqProvider: faqModel,
                    ),
                  ),
                ),
              );
            }),
          ),
        ]));
  }
}

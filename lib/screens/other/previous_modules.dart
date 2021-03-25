import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/navigation/previous_modules_arguments.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/modules/previous_modules_layout.dart';

class PreviousModules extends StatelessWidget {
  static const String id = "previous_modules_screen";

  @override
  Widget build(BuildContext context) {
    final PreviousModulesArguments args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: PreviousModulesLayout(modulesProvider: args.modulesProvider),
        ),
      ),
    );
  }
}

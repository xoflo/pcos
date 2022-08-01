import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/models/navigation/recipe_method_tips_arguments.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';

class RecipeMethodTipsPage extends StatelessWidget {
  const RecipeMethodTipsPage({Key? key}) : super(key: key);

  static const id = "recipe_method_tips_page";

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as RecipeMethodTipsArguments;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Header(
                  title: args.isTips ? "Tips" : "Method",
                  closeItem: () => Navigator.pop(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: HtmlWidget(
                        args.text,
                        textStyle:
                            Theme.of(context).textTheme.bodyText1?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: textColor.withOpacity(0.8),
                                ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

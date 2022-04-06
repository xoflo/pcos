import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/wiki/wiki_search_layout.dart';

class WikiSearch extends StatelessWidget {
  static const String id = "wiki_search_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: WikiSearchLayout(),
        ),
      ),
    );
  }
}

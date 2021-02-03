import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class GettingStarted extends StatelessWidget {
  final String gettingStartedContent;

  GettingStarted({this.gettingStartedContent});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Html(
        data: gettingStartedContent,
      ),
    );
  }
}

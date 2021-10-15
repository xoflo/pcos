import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class WikiCard extends StatefulWidget {
  final Question wiki;

  WikiCard({
    @required this.wiki,
  });

  @override
  _WikiCardState createState() => _WikiCardState();
}

class _WikiCardState extends State<WikiCard> {
  double _questionContainerHeight = 228;
  double _answerContainerHeight = 0;

  void _switchQuestionAnswer(final DragUpdateDetails details) {
    bool showQuestion = true;
    int sensitivity = 8;
    if (details.delta.dy > sensitivity) {
      // Down Swipe
      showQuestion = true;
    } else if (details.delta.dy < -sensitivity) {
      //Up Swipe
      showQuestion = false;
    }

    setState(() {
      _questionContainerHeight = showQuestion ? 228 : 0;
      _answerContainerHeight = showQuestion ? 0 : 228;
    });

    setState(() {
      _questionContainerHeight = showQuestion ? 228 : 0;
      _answerContainerHeight = showQuestion ? 0 : 228;
    });
  }

  Widget _getAnimatedContainer(
      final String html, final double height, final String swipeText) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
      height: height,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: ClipRect(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HtmlWidget(html),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotatedBox(
                  quarterTurns: -1,
                  child: Icon(
                    Icons.swipe,
                    size: 26,
                    color: Colors.grey,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Text(
                  swipeText,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          _switchQuestionAnswer(details);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 0,
                  ),
                  child: Column(
                    children: [
                      _getAnimatedContainer(
                          widget.wiki.question,
                          _questionContainerHeight,
                          S.of(context).swipeUpForAnswer),
                      _getAnimatedContainer(
                          widget.wiki.answer,
                          _answerContainerHeight,
                          S.of(context).swipeDownForQuestion),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

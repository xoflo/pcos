import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_wiki_full.dart';

class WikiCard extends StatefulWidget {
  final Question wiki;
  final Function(Question) addToFavourites;

  WikiCard({
    @required this.wiki,
    @required this.addToFavourites,
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

  Widget _getAnimatedContainer(final BuildContext context, final bool isAnswer,
      final Question wiki, final double height, final String swipeText) {
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
                    HtmlWidget(isAnswer ? wiki.answer : wiki.question),
                  ],
                ),
              ),
            ),
          ),
          !wiki.isLongAnswer
              ? Row(
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
                )
              : GestureDetector(
                  onTap: () {
                    _openWiki(context, wiki);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).viewWiki,
                          style: TextStyle(color: secondaryColor)),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Icon(
                          Icons.open_in_browser,
                          color: secondaryColor,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  void _openWiki(final BuildContext context, final Question wiki) {
    openBottomSheet(
      context,
      LessonWikiFull(
        wiki: wiki,
        closeWiki: () {
          Navigator.pop(context);
        },
        addToFavourites: widget.addToFavourites,
      ),
      Analytics.ANALYTICS_SCREEN_LESSON,
      wiki.id.toString(),
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
                          context,
                          false,
                          widget.wiki,
                          _questionContainerHeight,
                          S.of(context).swipeUpForAnswer),
                      _getAnimatedContainer(
                          context,
                          true,
                          widget.wiki,
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

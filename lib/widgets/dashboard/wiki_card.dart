import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_wiki_full.dart';

class WikiCard extends StatefulWidget {
  final Size screenSize;
  final LessonWiki wiki;
  final Function(LessonWiki) addToFavourites;

  WikiCard({
    @required this.wiki,
    @required this.addToFavourites,
    @required this.screenSize,
  });

  @override
  _WikiCardState createState() => _WikiCardState();
}

class _WikiCardState extends State<WikiCard> {
  final double _containerHeight = 244;
  bool _showQuestion = true;

  void _switchQuestionAnswer(final DragUpdateDetails details) {
    bool showQuestion = false;
    int sensitivity = 8;
    if (details.delta.dy > sensitivity) {
      // Down Swipe
      showQuestion = true;
    } else if (details.delta.dy < -sensitivity) {
      //Up Swipe
      showQuestion = false;
    }

    setState(() {
      _showQuestion = showQuestion;
    });
  }

  void _addToFavourites(final LessonWiki wiki) async {
    widget.addToFavourites(wiki);
    setState(() {
      widget.wiki.isFavorite = !widget.wiki.isFavorite;
    });
  }

  Widget _getContainer(final BuildContext context, final bool isAnswer,
      final LessonWiki wiki, final double height, final String swipeText) {
    return Container(
      width: widget.screenSize.width - 54,
      height: height,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HtmlWidget(isAnswer ? wiki.answer : wiki.question),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: !wiki.isLongAnswer
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
          ),
        ],
      ),
    );
  }

  void _openWiki(final BuildContext context, final LessonWiki wiki) {
    openBottomSheet(
      context,
      LessonWikiFull(
        wiki: wiki,
        closeWiki: () {
          Navigator.pop(context);
        },
        addToFavourites: widget.addToFavourites,
      ),
      Analytics.ANALYTICS_SCREEN_WIKI,
      wiki.questionId.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          if (!widget.wiki.isLongAnswer) {
            _switchQuestionAnswer(details);
          }
        },
        child: Container(
          width: widget.screenSize.width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 0,
                ),
                child: Container(
                  width: widget.screenSize.width,
                  height: _containerHeight,
                  child: OverflowBox(
                    minHeight: _containerHeight,
                    maxHeight: _containerHeight,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        AnimatedPositioned(
                          top: _showQuestion ? 0 : (_containerHeight * -1),
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn,
                          child: Column(
                            children: [
                              _getContainer(
                                  context,
                                  false,
                                  widget.wiki,
                                  _containerHeight,
                                  S.of(context).swipeUpForAnswer),
                              _getContainer(
                                  context,
                                  true,
                                  widget.wiki,
                                  _containerHeight,
                                  S.of(context).swipeDownForQuestion),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _addToFavourites(widget.wiki);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Icon(
                              widget.wiki.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: secondaryColor,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                /*child: Column(
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
                ),*/
              ),
            ],
          ),
        ),
      ),
    );
  }
}

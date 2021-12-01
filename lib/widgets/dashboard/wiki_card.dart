import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_wiki_full.dart';

class WikiCard extends StatefulWidget {
  final Size screenSize;
  final LessonWiki wiki;
  final bool isLessonComplete;

  WikiCard({
    @required this.wiki,
    @required this.screenSize,
    @required this.isLessonComplete,
  });

  @override
  _WikiCardState createState() => _WikiCardState();
}

class _WikiCardState extends State<WikiCard> {
  final double _containerHeight = 244;
  bool _showQuestion = true;

  void _switchQuestionAnswer() {
    setState(() {
      _showQuestion = !_showQuestion;
    });
  }

  Widget _getContainer(
      final FavouritesProvider favouritesProvider,
      final BuildContext context,
      final bool isAnswer,
      final LessonWiki wiki,
      final double height,
      final String swipeText) {
    void _openWiki(final BuildContext context, final LessonWiki wiki) {
      openBottomSheet(
        context,
        LessonWikiFull(
          parentContext: context,
          wiki: wiki,
          isFavourite: favouritesProvider.isFavourite(
              FavouriteType.Wiki, widget.wiki.questionId),
          closeWiki: () {
            Navigator.pop(context);
          },
        ),
        Analytics.ANALYTICS_SCREEN_WIKI,
        wiki.questionId.toString(),
      );
    }

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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: HtmlWidget(isAnswer ? wiki.answer : wiki.question),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: GestureDetector(
              onTap: () {
                if (wiki.isLongAnswer) {
                  _openWiki(context, wiki);
                } else {
                  _switchQuestionAnswer();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      isAnswer
                          ? S.current.viewWikiQuestion
                          : S.current.viewWikiAnswer,
                      style: TextStyle(color: secondaryColor)),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: isAnswer
                        ? RotatedBox(
                            quarterTurns: 2,
                            child: Icon(
                              Icons.present_to_all,
                              color: secondaryColor,
                              size: 32,
                            ),
                          )
                        : Icon(
                            wiki.isLongAnswer
                                ? Icons.open_in_new
                                : Icons.present_to_all,
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

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouritesProvider>(
      builder: (context, favouritesProvider, child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: widget.isLessonComplete
            ? Container(
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
                                top:
                                    _showQuestion ? 0 : (_containerHeight * -1),
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastOutSlowIn,
                                child: Column(
                                  children: [
                                    _getContainer(
                                        favouritesProvider,
                                        context,
                                        false,
                                        widget.wiki,
                                        _containerHeight,
                                        S.current.swipeUpForAnswer),
                                    widget.wiki.isLongAnswer
                                        ? Container()
                                        : _getContainer(
                                            favouritesProvider,
                                            context,
                                            true,
                                            widget.wiki,
                                            _containerHeight,
                                            S.current.swipeDownForQuestion),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  favouritesProvider.addToFavourites(
                                    FavouriteType.Wiki,
                                    widget.wiki.questionId,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, right: 3.0),
                                  child: Icon(
                                    favouritesProvider.isFavourite(
                                            FavouriteType.Wiki,
                                            widget.wiki.questionId)
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
                    ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }
}

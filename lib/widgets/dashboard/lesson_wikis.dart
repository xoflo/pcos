import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/wiki_card.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';

class LessonWikis extends StatefulWidget {
  final Size screenSize;
  final int lessonId;
  final bool isLessonComplete;
  final List<LessonWiki> lessonWikis;
  final ModulesProvider modulesProvider;
  final LoadingStatus loadingStatus;
  final int selectedWiki;
  final double width;
  final bool isHorizontal;
  final Function(BuildContext, ModulesProvider) openWikiSearch;

  LessonWikis({
    @required this.screenSize,
    @required this.lessonId,
    @required this.isLessonComplete,
    @required this.lessonWikis,
    @required this.modulesProvider,
    @required this.loadingStatus,
    @required this.selectedWiki,
    @required this.width,
    @required this.isHorizontal,
    @required this.openWikiSearch,
  });

  @override
  _LessonWikisState createState() => _LessonWikisState();
}

class _LessonWikisState extends State<LessonWikis> {
  bool _isNoneMessageVisible = false;
  bool _isCarouselVisible = true;

  void _changeVisibility() {
    if (!_isNoneMessageVisible &&
        (widget.lessonWikis.length == 0 || !widget.isLessonComplete)) {
      //play animation to show no wikis/locked msg
      setState(() {
        _isNoneMessageVisible = true;
        _isCarouselVisible = false;
      });
    } else if (_isNoneMessageVisible && widget.lessonWikis.length > 0) {
      //play animation to hide no wikis/locked msg
      setState(() {
        _isNoneMessageVisible = false;
        _isCarouselVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String noWikisMessage = "";

    if (widget.loadingStatus == LoadingStatus.success) {
      if (!widget.isLessonComplete && widget.lessonWikis.length > 0) {
        noWikisMessage = S.current.lockedWikis;
      } else {
        noWikisMessage = S.current.noWikis;
      }
      _changeVisibility();
    }

    return widget.loadingStatus == LoadingStatus.success
        ? Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        S.current.lessonWiki,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: widget.width,
                    child: Stack(
                      children: [
                        AnimatedOpacity(
                          // If the widget is visible, animate to 0.0 (invisible).
                          // If the widget is hidden, animate to 1.0 (fully visible).
                          opacity: _isNoneMessageVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 1000),
                          // The green box must be a child of the AnimatedOpacity widget.
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              width: widget.width,
                              height: 253.0,
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  noWikisMessage.length > 0
                                      ? Icon(
                                          !widget.isLessonComplete &&
                                                  widget.lessonWikis.length > 0
                                              ? Icons.lock_outline
                                              : Icons.block,
                                          size: 44,
                                          color: backgroundColor)
                                      : Container(),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      noWikisMessage,
                                      style: TextStyle(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          // If the widget is visible, animate to 0.0 (invisible).
                          // If the widget is hidden, animate to 1.0 (fully visible).
                          opacity: _isCarouselVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 1500),
                          // The green box must be a child of the AnimatedOpacity widget.
                          child: widget.lessonWikis.length > 0 &&
                                  widget.isLessonComplete
                              ? CarouselSlider.builder(
                                  itemCount: widget.lessonWikis.length,
                                  options: CarouselOptions(
                                    height: 260,
                                    enableInfiniteScroll: false,
                                    viewportFraction:
                                        widget.isHorizontal ? 0.50 : 0.92,
                                    initialPage: widget.selectedWiki,
                                  ),
                                  itemBuilder: (ctx, index, realIdx) {
                                    LessonWiki lessonWiki =
                                        widget.lessonWikis[index];
                                    return WikiCard(
                                      screenSize: widget.screenSize,
                                      wiki: lessonWiki,
                                      isFavorite: lessonWiki.isFavorite,
                                      isLessonComplete: widget.isLessonComplete,
                                    );
                                  },
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            widget.openWikiSearch(
                                context, widget.modulesProvider);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Icon(
                              Icons.search,
                              color: secondaryColor,
                              size: 32,
                            ),
                          ),
                        ),
                        Container(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : widget.loadingStatus == LoadingStatus.empty
            ? NoResults(message: S.current.noResultsLessons)
            : Container();
  }
}

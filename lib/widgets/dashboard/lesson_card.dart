import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/controllers/favourites_controller.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class LessonCard extends StatefulWidget {
  final int lessonNumber;
  final Lesson lesson;
  final bool lessonFavourite;
  final bool isNew;
  final bool isSearch;
  final bool isPreviousModules;
  final Function(Lesson) openLesson;
  final Function refreshPreviousModules;

  LessonCard({
    @required this.lessonNumber,
    @required this.lesson,
    @required this.lessonFavourite,
    @required this.isNew,
    this.isSearch = false,
    this.isPreviousModules = false,
    @required this.openLesson,
    @required this.refreshPreviousModules,
  });

  @override
  _LessonCardState createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isFavourite = widget.lessonFavourite;
    });
  }

  void _onTap() async {
    await FavouritesController().addToFavourites(
      context,
      FavouriteType.Lesson,
      widget.lesson,
      widget.isPreviousModules ? !widget.lessonFavourite : !_isFavourite,
      refreshData: false,
    );
    setState(() {
      _isFavourite = !_isFavourite;
    });
    if (widget.isPreviousModules) {
      await widget.refreshPreviousModules();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLessonComplete = widget.lesson.isComplete;
    final Color cardColor = widget.lesson.isToolkit
        ? altBackgroundColor
        : isLessonComplete || widget.isNew
            ? backgroundColor
            : Colors.grey;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.isSearch
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(width: 32),
                            Text(
                              "${S.of(context).lessonText} ${widget.lessonNumber}",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            widget.lesson.isToolkit
                                ? Icon(Icons.construction,
                                    size: 30, color: primaryColor)
                                : GestureDetector(
                                    onTap: () {
                                      _onTap();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0, right: 3.0),
                                      child: Icon(
                                        (widget.isPreviousModules &&
                                                    widget.lessonFavourite) ||
                                                (!widget.isPreviousModules &&
                                                    _isFavourite)
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color: secondaryColor,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                  SizedBox(
                    height: 56,
                    child: Center(
                      child: Text(
                        widget.lesson.title,
                        textAlign: TextAlign.center,
                        style: isLessonComplete || widget.isNew
                            ? Theme.of(context).textTheme.headline5
                            : Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: Colors.white70),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 0,
                    ),
                    child: SizedBox(
                      height: 106,
                      child: Center(
                        child: ClipRect(
                          child: HtmlWidget(widget.lesson.introduction),
                        ),
                      ),
                    ),
                  ),
                  isLessonComplete || widget.isNew
                      ? GestureDetector(
                          onTap: () {
                            widget.openLesson(widget.lesson);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(S.of(context).viewNow,
                                  style: TextStyle(color: secondaryColor)),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Icon(
                                  Icons.open_in_new,
                                  color: secondaryColor,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.lock,
                                color: Colors.black87,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
        !widget.lesson.isComplete && this.widget.isNew
            ? Align(
                alignment: Alignment.topRight,
                child: AvatarGlow(
                  glowColor: Colors.blue,
                  endRadius: 33.0,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 1000),
                  child: Material(
                    // Replace this child with your own
                    elevation: 8.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: primaryColor,
                      child: Icon(
                        Icons.fiber_new,
                        color: Colors.white,
                        size: 25.0,
                      ),
                      radius: 17.0,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

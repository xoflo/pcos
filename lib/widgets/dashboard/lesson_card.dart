import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class LessonCard extends StatelessWidget {
  final int lessonNumber;
  final Lesson lesson;
  final bool isNew;
  final Function(Lesson) openLesson;

  LessonCard({
    @required this.lessonNumber,
    @required this.lesson,
    @required this.isNew,
    @required this.openLesson,
  });

  @override
  Widget build(BuildContext context) {
    final isLessonComplete = lesson.isComplete;
    final Color cardColor = lesson.isToolkit
        ? altBackgroundColor
        : isLessonComplete || isNew
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
                  lessonNumber > 0
                      ? lesson.isToolkit
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(width: 32),
                                Text(
                                  "${S.of(context).lessonText} $lessonNumber",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Icon(Icons.construction,
                                    size: 32, color: primaryColor),
                              ],
                            )
                          : Text(
                              "${S.of(context).lessonText} $lessonNumber",
                              style: Theme.of(context).textTheme.headline6,
                            )
                      : Container(),
                  SizedBox(
                    height: 56,
                    child: Center(
                      child: Text(
                        lesson.title,
                        textAlign: TextAlign.center,
                        style: isLessonComplete || isNew
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
                          child: HtmlWidget(lesson.introduction),
                        ),
                      ),
                    ),
                  ),
                  isLessonComplete || isNew
                      ? GestureDetector(
                          onTap: () {
                            openLesson(lesson);
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
        !lesson.isComplete && this.isNew
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

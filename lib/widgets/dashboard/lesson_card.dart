import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final Function(Lesson) openLesson;

  LessonCard({
    @required this.lesson,
    @required this.openLesson,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  Text(
                    "${S.of(context).lessonText} ${lesson.orderIndex + 1}",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    lesson.title,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HtmlWidget(lesson.introduction),
                  ),
                  GestureDetector(
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
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        !lesson.isComplete
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

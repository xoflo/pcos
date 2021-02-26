import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/diagonal_banner.dart';

class CurrentLesson extends StatelessWidget {
  final bool isNew;
  final Size screenSize;
  final bool isHorizontal;
  final Function openLesson;
  final Function closeLesson;

  CurrentLesson({
    @required this.isNew,
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.openLesson,
    @required this.closeLesson,
  });

  final String moduleTitle = "Increasing Protein";
  final String lessonTitle = "Why a high protein breakfast?";
  final String lessonIntro =
      "In this lesson we look at why it is so important to start the day off with a healthy high protein breakfast, and how you can do this everyday.";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: SizedBox(
        width: screenSize.width,
        child: Card(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        "Module 3 - $moduleTitle",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      "Lesson 1",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        lessonTitle,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        lessonIntro,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                        top: 8.0,
                        bottom: 2.0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          openLesson();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Watch now",
                                style: TextStyle(color: secondaryColorLight)),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.ondemand_video,
                                color: secondaryColorLight,
                                size: 36,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: DiagonalBanner(bannerText: "New Lesson"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
